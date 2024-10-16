Follow MVVN Design Pattern
- Model is where you define the data structure for the objects your app works with, such as a struct or class. Only the data attributes of the object should be declared here.
- View Model acts as a mediator between the Model and the View. It processes and prepares data from the Model for display and handles user interactions. All functions definitions should go here.
- View is responsible for presenting data to the user. It should call the functions from the ViewModel for logic

Branch Flow:
Main -> Develop -> feature/featureName
