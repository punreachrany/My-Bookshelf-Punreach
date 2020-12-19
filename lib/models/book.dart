class Book {
  String title,
      subtitle,
      isbn13,
      price,
      image,
      url,
      authors,
      publisher,
      language,
      isbn10,
      pages,
      year,
      rating,
      desc;
  Book(
      {this.title,
      this.subtitle,
      this.isbn13,
      this.price,
      this.image,
      this.url,
      this.authors,
      this.desc,
      this.isbn10,
      this.language,
      this.pages,
      this.publisher,
      this.rating,
      this.year});

  factory Book.fromJson(dynamic json) {
    return Book(
        title: json['title'],
        subtitle: json['subtitle'],
        isbn13: json['isbn13'],
        price: json['price'],
        image: json['image'],
        url: json['url'],
        authors: json['authors'],
        publisher: json['publisher'],
        language: json['language'],
        isbn10: json['isbn10'],
        pages: json['pages'],
        year: json['year'],
        rating: json['rating'],
        desc: json['desc']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();

  //   data['title'] = this.title;
  //   data['subtitle'] = this.subtitle;
  //   data['isbn13'] = this.isbn13;
  //   data['price'] = this.price;
  //   data['image'] = this.image;
  //   data['url'] = this.url;
  //   data['authors'] = this.authors;
  //   data['publisher'] = this.publisher;
  //   data['language'] = this.language;
  //   data['isbn10'] = this.isbn10;
  //   data['pages'] = this.pages;
  //   data['year'] = this.year;
  //   data['rating'] = this.rating;
  //   data['desc'] = this.desc;
  //   return data;
  // }
}
