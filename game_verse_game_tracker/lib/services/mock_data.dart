import '../models/game.dart';
import '../models/review.dart';
import '../models/news_article.dart';
import '../models/achievement.dart';

class MockData {
  static String _getNewsImage(String url) {
    try {
      if (url.isNotEmpty) return url;
    } catch (e) {
      return 'assets/images/fallbacks/news_fallback.png';
    }
    return 'assets/images/fallbacks/news_fallback.png';
  }

  static String _getAchievementImage(String url) {
    try {
      if (url.isNotEmpty) return url;
    } catch (e) {
      return 'assets/images/fallbacks/achievement_fallback.png';
    }
    return 'assets/images/fallbacks/achievement_fallback.png';
  }

  static final List<Game> games = [
    Game(
      id: 'elden-ring',
      title: 'Elden Ring',
      description: 'A fantasy action-RPG adventure developed by FromSoftware',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/library_hero.jpg',
      genres: ['Action RPG', 'Open World', 'Souls-like'],
      releaseDate: DateTime(2022, 2, 25),
      developer: 'FromSoftware',
      publisher: 'Bandai Namco',
      rating: 4.9,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'god-of-war-ragnarok',
      title: 'God of War Ragnarök',
      description: 'The sequel to the 2018 Game of the Year',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1593500/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1593500/library_hero.jpg',
      genres: ['Action-Adventure', 'Hack and Slash'],
      releaseDate: DateTime(2022, 11, 9),
      developer: 'Santa Monica Studio',
      publisher: 'Sony Interactive Entertainment',
      rating: 4.8,
      platforms: ['PlayStation'],
    ),
    Game(
      id: 'cyberpunk-2077',
      title: 'Cyberpunk 2077',
      description: 'An open-world RPG set in Night City',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/library_hero.jpg',
      genres: ['RPG', 'Open World', 'Cyberpunk'],
      releaseDate: DateTime(2020, 12, 10),
      developer: 'CD Projekt Red',
      publisher: 'CD Projekt',
      rating: 4.0,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'zelda-tears-of-the-kingdom',
      title: 'The Legend of Zelda: Tears of the Kingdom',
      description: 'The sequel to The Legend of Zelda: Breath of the Wild',
      coverImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSltToBiEOhqpmGwglZjMXzoJT2s6_qSV0ZjQ&s',
      bannerImage:
          'https://i.pinimg.com/736x/c8/c8/22/c8c822d28340c4ea9cf3fc6fb1490f07.jpg',
      genres: ['Action-Adventure', 'Open World', 'Fantasy'],
      releaseDate: DateTime(2023, 5, 12),
      developer: 'Nintendo EPD',
      publisher: 'Nintendo',
      rating: 4.9,
      platforms: ['Nintendo Switch'],
    ),
    Game(
      id: 'final-fantasy-xvi',
      title: 'Final Fantasy XVI',
      description: 'A dark fantasy RPG set in the world of Valisthea',
      coverImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS41vRU_YPgSZ7rln2crVZ93wh8POx02lJucQ&s',
      bannerImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShFBLDKWsHYW5ugq5oqLaxRBF8LsYC6RXejA&s',
      genres: ['Action RPG', 'Fantasy', 'Story-Rich'],
      releaseDate: DateTime(2023, 6, 22),
      developer: 'Square Enix',
      publisher: 'Square Enix',
      rating: 4.8,
      platforms: ['PlayStation'],
    ),
    Game(
      id: 'spiderman-2',
      title: 'Marvel\'s Spider-Man 2',
      description:
          'The next adventure in the Spider-Man universe with both Peter Parker and Miles Morales',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1817190/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1817190/library_hero.jpg',
      genres: ['Action-Adventure', 'Superhero'],
      releaseDate: DateTime(2023, 10, 20),
      developer: 'Insomniac Games',
      publisher: 'Sony Interactive Entertainment',
      rating: 4.8,
      platforms: ['PlayStation 5'],
    ),
    Game(
      id: 'starfield',
      title: 'Starfield',
      description:
          'Bethesda\'s next-generation role-playing game set amongst the stars',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1716740/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1716740/library_hero.jpg',
      genres: ['RPG', 'Sci-Fi', 'Open World'],
      releaseDate: DateTime(2023, 9, 6),
      developer: 'Bethesda Game Studios',
      publisher: 'Bethesda Softworks',
      rating: 4.5,
      platforms: ['PC', 'Xbox'],
    ),
    Game(
      id: 'baldurs-gate-3',
      title: 'Baldur\'s Gate 3',
      description:
          'A next-generation RPG set in the world of Dungeons & Dragons',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/library_hero.jpg',
      genres: ['RPG', 'Fantasy', 'CRPG'],
      releaseDate: DateTime(2023, 8, 3),
      developer: 'Larian Studios',
      publisher: 'Larian Studios',
      rating: 4.9,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'resident-evil-4',
      title: 'Resident Evil 4 Remake',
      description: 'A reimagining of the 2005 survival horror classic',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2050650/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2050650/library_hero.jpg',
      genres: ['Survival Horror', 'Action'],
      releaseDate: DateTime(2023, 3, 24),
      developer: 'Capcom',
      publisher: 'Capcom',
      rating: 4.7,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'diablo-4',
      title: 'Diablo IV',
      description: 'The next installment in the legendary action RPG series',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2344520/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2344520/library_hero.jpg',
      genres: ['ARPG', 'Dark Fantasy'],
      releaseDate: DateTime(2023, 6, 6),
      developer: 'Blizzard Entertainment',
      publisher: 'Blizzard Entertainment',
      rating: 4.6,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'hogwarts-legacy',
      title: 'Hogwarts Legacy',
      description: 'An open-world RPG set in the Wizarding World universe',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/990080/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/990080/library_hero.jpg',
      genres: ['Action RPG', 'Open World', 'Fantasy'],
      releaseDate: DateTime(2023, 2, 10),
      developer: 'Avalanche Software',
      publisher: 'Warner Bros. Games',
      rating: 4.7,
      platforms: ['PC', 'PlayStation', 'Xbox', 'Switch'],
    ),
    Game(
      id: 'street-fighter-6',
      title: 'Street Fighter 6',
      description: 'The latest entry in the legendary fighting game franchise',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1364780/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1364780/library_hero.jpg',
      genres: ['Fighting', 'Arcade'],
      releaseDate: DateTime(2023, 6, 2),
      developer: 'Capcom',
      publisher: 'Capcom',
      rating: 4.8,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'dead-space',
      title: 'Dead Space Remake',
      description: 'A complete remake of the 2008 survival horror classic',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1693980/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1693980/library_hero.jpg',
      genres: ['Survival Horror', 'Sci-Fi'],
      releaseDate: DateTime(2023, 1, 27),
      developer: 'Motive Studio',
      publisher: 'Electronic Arts',
      rating: 4.6,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'forza-motorsport',
      title: 'Forza Motorsport',
      description: 'The next generation of Forza racing simulation',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2440510/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2440510/library_hero.jpg',
      genres: ['Racing', 'Simulation'],
      releaseDate: DateTime(2023, 10, 10),
      developer: 'Turn 10 Studios',
      publisher: 'Xbox Game Studios',
      rating: 4.5,
      platforms: ['PC', 'Xbox'],
    ),
    Game(
      id: 'alan-wake-2',
      title: 'Alan Wake II',
      description:
          'The long-awaited sequel to the psychological action thriller',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2074900/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/2074900/library_hero.jpg',
      genres: ['Survival Horror', 'Psychological Thriller'],
      releaseDate: DateTime(2023, 10, 27),
      developer: 'Remedy Entertainment',
      publisher: 'Epic Games Publishing',
      rating: 4.7,
      platforms: ['PC', 'PlayStation', 'Xbox'],
    ),
    Game(
      id: 'mortal-kombat-1',
      title: 'Mortal Kombat 1',
      description: 'A franchise reboot featuring a new timeline',
      coverImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1971870/header.jpg',
      bannerImage:
          'https://cdn.cloudflare.steamstatic.com/steam/apps/1971870/library_hero.jpg',
      genres: ['Fighting', 'Gore'],
      releaseDate: DateTime(2023, 9, 19),
      developer: 'NetherRealm Studios',
      publisher: 'Warner Bros. Games',
      rating: 4.6,
      platforms: ['PC', 'PlayStation', 'Xbox', 'Switch'],
    ),
  ];

  static final Map<String, List<Review>> reviews = {
    'elden-ring': [
      Review(
        gameId: 'elden-ring',
        rating: 5.0,
        comment: 'A masterpiece that redefines open-world gaming.',
        datePosted: DateTime(2022, 3, 1),
      ),
      Review(
        gameId: 'elden-ring',
        rating: 4.5,
        comment: 'Challenging but rewarding. The world design is incredible.',
        datePosted: DateTime(2022, 3, 5),
      ),
    ],
    'god-of-war-ragnarok': [
      Review(
        gameId: 'god-of-war-ragnarok',
        rating: 5.0,
        comment:
            'An epic conclusion to the Norse saga. The story and combat are phenomenal.',
        datePosted: DateTime(2022, 11, 15),
      ),
    ],
    'cyberpunk-2077': [
      Review(
        gameId: 'cyberpunk-2077',
        rating: 4.0,
        comment:
            'After updates, the game is much better. Night City is amazing.',
        datePosted: DateTime(2023, 9, 21),
      ),
    ],
  };

  static final List<NewsArticle> newsArticles = [
    NewsArticle(
      title: 'Elden Ring DLC Shadow of the Erdtree Announced',
      summary: 'FromSoftware reveals first major expansion for Elden Ring',
      content:
          'FromSoftware and Bandai Namco have announced Shadow of the Erdtree, the first major expansion for their critically acclaimed action RPG Elden Ring. The DLC promises to expand the game\'s rich lore and introduce new challenges.',
      imageUrl: _getNewsImage(
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/ss_e80a907c2c43337e53316c71555c3c3035a1343e.600x338.jpg',
      ),
      publishDate: DateTime(2024, 2, 28),
      author: 'John Smith',
    ),
    NewsArticle(
      title: 'Next-Gen Update for Cyberpunk 2077 Released',
      summary: 'CD Projekt Red delivers major improvements for new consoles',
      content:
          'The highly anticipated next-gen update for Cyberpunk 2077 has finally arrived, bringing ray tracing, improved frame rates, and faster loading times to PS5 and Xbox Series X/S. The update also includes numerous gameplay improvements and bug fixes.',
      imageUrl: _getNewsImage(
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_872822c5e50dc71f345416098d29fc3ae5cd26c1.600x338.jpg',
      ),
      publishDate: DateTime(2024, 3, 15),
      author: 'Sarah Johnson',
    ),
    NewsArticle(
      title: 'Final Fantasy XVI Sales Exceed Expectations',
      summary: 'Square Enix\'s latest entry in the series proves successful',
      content:
          'Final Fantasy XVI has surpassed sales expectations in its first month, shipping over 5 million copies worldwide. The game\'s mature themes and action-focused combat have resonated with both longtime fans and newcomers to the series.',
      imageUrl: _getNewsImage(
        'https://cdn.cloudflare.steamstatic.com/steam/apps/2324650/ss_8b9d1a8e5c4dc7e2b17d8e4f7a81d4a9f4e32f5c.600x338.jpg',
      ),
      publishDate: DateTime(2024, 4, 1),
      author: 'Michael Chen',
    ),
  ];

  static final Map<String, List<Achievement>> achievements = {
    'elden-ring': [
      Achievement(
        id: 'elden-lord',
        title: 'Elden Lord',
        description: 'Become the Elden Lord',
        iconUrl: _getAchievementImage('https://picsum.photos/200/200'),
      ),
      Achievement(
        id: 'first-steps',
        title: 'First Steps',
        description: 'Defeat the first major boss',
        iconUrl: _getAchievementImage('https://picsum.photos/200/200'),
      ),
    ],
    'god-of-war-ragnarok': [
      Achievement(
        id: 'father-and-son',
        title: 'Father and Son',
        description: 'Complete the main story',
        iconUrl: _getAchievementImage('https://picsum.photos/200/200'),
      ),
    ],
    'cyberpunk-2077': [
      Achievement(
        id: 'street-cred',
        title: 'Street Cred',
        description: 'Reach maximum Street Cred level',
        iconUrl: _getAchievementImage('https://picsum.photos/200/200'),
      ),
    ],
  };
}
