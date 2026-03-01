import 'package:uuid/uuid.dart';
import '../../core/config.dart';
import 'i_bounty_service.dart';
import 'mock_models/mock_bounty.dart';

/// [MockBountyService] — In-memory fake implementation of [IBountyService].
///
/// Returns realistic seed data with simulated network latency.
/// All state mutations (accept, complete, cancel) are reflected in [_db].
///
/// ⚠️  Phase 1 ONLY. Never reference this class directly in BLoC/domain layers —
///     always inject via [IBountyService].
class MockBountyService implements IBountyService {
  MockBountyService() {
    _db = List.from(_seed());
  }

  static const _uuid = Uuid();
  late List<MockBounty> _db;

  // ── Simulated latency ────────────────────────────────────────────────────
  Future<void> _fakeDelay() =>
      Future.delayed(AppConfig.mockLatency);

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<List<MockBounty>> fetchNearbyBounties({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    await _fakeDelay();
    // Return only open bounties within radius (mock: filter by distanceKm field)
    return _db
        .where((b) => b.isOpen && b.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  @override
  Future<MockBounty> postBounty({
    required String title,
    required String description,
    required int rewardCents,
    required BountyCategory category,
    required double lat,
    required double lng,
    required Duration expiresIn,
    bool isUrgent = false,
  }) async {
    await _fakeDelay();
    final now = DateTime.now();
    final bounty = MockBounty(
      id: _uuid.v4(),
      title: title,
      description: description,
      reward: rewardCents,
      lat: lat,
      lng: lng,
      status: BountyStatus.open,
      category: category,
      posterId: 'mock-current-user',
      posterName: 'You',
      posterAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      postedAt: now,
      expiresAt: now.add(expiresIn),
      distanceKm: 0.0,
      isUrgent: isUrgent,
    );
    _db.add(bounty);
    return bounty;
  }

  @override
  Future<MockBounty> acceptBounty({
    required String bountyId,
    required String hunterId,
  }) async {
    await _fakeDelay();
    final index = _db.indexWhere((b) => b.id == bountyId);
    if (index == -1) throw Exception('Bounty not found: $bountyId');
    final updated = _db[index].copyWith(
      status: BountyStatus.accepted,
      hunterId: hunterId,
      hunterName: 'Current Hunter',
    );
    _db[index] = updated;
    return updated;
  }

  @override
  Future<MockBounty> completeBounty({required String bountyId}) async {
    await _fakeDelay();
    final index = _db.indexWhere((b) => b.id == bountyId);
    if (index == -1) throw Exception('Bounty not found: $bountyId');
    final updated = _db[index].copyWith(status: BountyStatus.completed);
    _db[index] = updated;
    return updated;
  }

  @override
  Future<MockBounty> cancelBounty({required String bountyId}) async {
    await _fakeDelay();
    final index = _db.indexWhere((b) => b.id == bountyId);
    if (index == -1) throw Exception('Bounty not found: $bountyId');
    final updated = _db[index].copyWith(status: BountyStatus.cancelled);
    _db[index] = updated;
    return updated;
  }

  @override
  Future<List<MockBounty>> fetchMyPostedBounties({
    required String userId,
  }) async {
    await _fakeDelay();
    return _db.where((b) => b.posterId == userId).toList();
  }

  @override
  Future<List<MockBounty>> fetchMyAcceptedBounties({
    required String userId,
  }) async {
    await _fakeDelay();
    return _db.where((b) => b.hunterId == userId).toList();
  }

  @override
  Future<MockBounty?> fetchBountyById({required String bountyId}) async {
    await _fakeDelay();
    try {
      return _db.firstWhere((b) => b.id == bountyId);
    } catch (_) {
      return null;
    }
  }

  // ─── Seed Data ────────────────────────────────────────────────────────────
  static List<MockBounty> _seed() {
    final now = DateTime.now();
    return [
      MockBounty(
        id: 'bounty-001',
        title: 'Pick up my dry cleaning 🧥',
        description:
            'My order is ready at FreshPress on Main St. Bag has my name: "Alex K." Please handle with care.',
        reward: 1200, // \$12.00
        lat: 37.7751,
        lng: -122.4194,
        status: BountyStatus.open,
        category: BountyCategory.errand,
        posterId: 'user-002',
        posterName: 'Alex K.',
        posterAvatarUrl: 'https://i.pravatar.cc/150?img=7',
        postedAt: now.subtract(const Duration(minutes: 12)),
        expiresAt: now.add(const Duration(hours: 2)),
        distanceKm: 0.3,
      ),
      MockBounty(
        id: 'bounty-002',
        title: 'Tech support — WiFi setup 🔧',
        description:
            'New Eero mesh router arrived. Need someone to set up 3 nodes + configure guest network. Beer included.',
        reward: 3500, // \$35.00
        lat: 37.7761,
        lng: -122.4180,
        status: BountyStatus.open,
        category: BountyCategory.tech,
        posterId: 'user-003',
        posterName: 'Sam P.',
        posterAvatarUrl: 'https://i.pravatar.cc/150?img=12',
        postedAt: now.subtract(const Duration(minutes: 28)),
        expiresAt: now.add(const Duration(hours: 4)),
        distanceKm: 0.6,
        isUrgent: false,
      ),
      MockBounty(
        id: 'bounty-003',
        title: '🚨 URGENT: Pharmacy run — insulin',
        description:
            'My mobility is limited today. Need Humalog 100u/mL picked up from CVS on Market St. Will pay tip.',
        reward: 5000, // \$50.00
        lat: 37.7740,
        lng: -122.4210,
        status: BountyStatus.open,
        category: BountyCategory.delivery,
        posterId: 'user-004',
        posterName: 'Maria L.',
        posterAvatarUrl: 'https://i.pravatar.cc/150?img=5',
        postedAt: now.subtract(const Duration(minutes: 5)),
        expiresAt: now.add(const Duration(minutes: 45)),
        distanceKm: 0.9,
        isUrgent: true,
      ),
      MockBounty(
        id: 'bounty-004',
        title: 'Logo design — food truck brand',
        description:
            'Need a clean, modern logo for "Ghost Noodles" food truck. Dark theme. Turnaround 24h preferred.',
        reward: 8000, // \$80.00
        lat: 37.7770,
        lng: -122.4170,
        status: BountyStatus.open,
        category: BountyCategory.creative,
        posterId: 'user-005',
        posterName: 'Jake T.',
        posterAvatarUrl: 'https://i.pravatar.cc/150?img=15',
        postedAt: now.subtract(const Duration(hours: 1)),
        expiresAt: now.add(const Duration(hours: 23)),
        distanceKm: 1.4,
      ),
      MockBounty(
        id: 'bounty-005',
        title: 'Move 4 boxes to storage unit',
        description:
            'Heavy-ish boxes (books). Storage is 0.5mi from my apartment. Truck not needed — can do multiple trips.',
        reward: 2500, // \$25.00
        lat: 37.7730,
        lng: -122.4220,
        status: BountyStatus.open,
        category: BountyCategory.manual,
        posterId: 'user-006',
        posterName: 'Chris B.',
        posterAvatarUrl: 'https://i.pravatar.cc/150?img=9',
        postedAt: now.subtract(const Duration(hours: 2)),
        expiresAt: now.add(const Duration(hours: 6)),
        distanceKm: 2.1,
      ),
      MockBounty(
        id: 'bounty-006',
        title: 'Dog walk — Golden Retriever (30 min)',
        description:
            "Buddy needs his afternoon walk. Super friendly, leash-trained. Lives in Pacific Heights.",
        reward: 1500,
        lat: 37.7720,
        lng: -122.4230,
        status: BountyStatus.accepted,
        category: BountyCategory.errand,
        posterId: 'user-007',
        posterName: 'Priya N.',
        posterAvatarUrl: 'https://i.pravatar.cc/150?img=20',
        hunterId: 'user-008',
        hunterName: 'Ghost Runner #4',
        postedAt: now.subtract(const Duration(hours: 3)),
        expiresAt: now.add(const Duration(hours: 1)),
        distanceKm: 3.2,
      ),
    ];
  }
}
