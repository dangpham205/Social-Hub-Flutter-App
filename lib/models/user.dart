
class User{
  final String uid;
  final String email;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  const User({
      required this.uid,
      required this.email,
      required this.username,
      required this.bio,
      required this.followers,
      required this.following,
      required this.photoUrl,
  });

  Map<String, dynamic> toJSON() => {
    "uid": uid,
    "email": email,
    "username": username,
    "bio": bio,
    "followers": followers,
    "following": following,
    "photoUrl": photoUrl,
  };

    
}