class Voter {
  final int? localId; // autoincrement PK
  final String nationalId; // رقم البطاقة
  final String fullName; // الاسم
  final String registrarId; // الرقم التعريفي للمسجل (signed-in user id)
  final String? imagePath; // optional path to image
  final bool isVoted; // checkbox in second screen
  final bool isProcessConfirmed; // checkbox in third screen

  const Voter({
    this.localId,
    required this.nationalId,
    required this.fullName,
    required this.registrarId,
    this.imagePath,
    this.isVoted = false,
    this.isProcessConfirmed = false,
  });

  Voter copyWith({
    int? localId,
    String? nationalId,
    String? fullName,
    String? registrarId,
    String? imagePath,
    bool? isVoted,
    bool? isProcessConfirmed,
  }) {
    return Voter(
      localId: localId ?? this.localId,
      nationalId: nationalId ?? this.nationalId,
      fullName: fullName ?? this.fullName,
      registrarId: registrarId ?? this.registrarId,
      imagePath: imagePath ?? this.imagePath,
      isVoted: isVoted ?? this.isVoted,
      isProcessConfirmed: isProcessConfirmed ?? this.isProcessConfirmed,
    );
  }

  Map<String, Object?> toMap() => {
        'id': localId,
        'nationalId': nationalId,
        'fullName': fullName,
        'registrarId': registrarId,
        'imagePath': imagePath,
        'isVoted': isVoted ? 1 : 0,
        'isProcessConfirmed': isProcessConfirmed ? 1 : 0,
      };

  factory Voter.fromMap(Map<String, Object?> map) => Voter(
        localId: map['id'] as int?,
        nationalId: map['nationalId'] as String,
        fullName: map['fullName'] as String,
        registrarId: map['registrarId'] as String,
        imagePath: map['imagePath'] as String?,
        isVoted: (map['isVoted'] as int) == 1,
        isProcessConfirmed: (map['isProcessConfirmed'] as int) == 1,
      );
}



