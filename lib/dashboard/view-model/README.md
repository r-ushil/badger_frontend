Logic for detecting UI changes and business changes in here. view-model is responsible for updating and detecting changes in the UI / model



View: Gets data from the View Model - is notified on change (can change everywhere)
View Model: Gets data from model in correct format
Model: Gets data in incorrect format (from whatever source), converts to correct format
Repo / Service: Gets data in incorrect format (from API)