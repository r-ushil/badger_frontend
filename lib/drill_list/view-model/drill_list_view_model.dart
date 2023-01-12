class DisplayableDrill {
  //todo - replace with builder pattern for better readability
  DisplayableDrill(this.name, this.skills, this.thumbnailUrl,
      this.videoUrl, this.description, this.duration);

  final String name;
  final List<String> skills;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;
  final int duration;
}

// create drill view model
class DrillListViewModel {

}
