%% a) Every student that failed both English and History, passed Maths.
%% b) Every student that failed history but passed math, passed English.
%% c) Every student that failed history but passed english, passed economics
%% d) Every student that failed economics but passed chemistry, failed history
%% e) Every studend that failed chemistry but passed history, failed english

%% • alexander, failed english but passed chemistry.
%% • peter, failed chemistry and passed history.
%% • tobias, failed history and passed maths.
%% • michael, failed maths and passed english.

%% killer, failed economics

student(alexander).
student(peter).
student(tobias).
student(michael).

%% a)
passed(X, maths):- failed(X, english), failed(X, history).
failed(X, maths):- passed(X, english), passed(X, history).
failed(X, maths):- failed(X, english), passed(X, history).
failed(X, maths):- passed(X, english), failed(X, history).


%% b)
passed(X, english):- failed(X, history), passed(X, maths).
failed(X, english):- passed(X, history), passed(X, maths).
failed(X, english):- passed(X, history), failed(X, maths).
failed(X, english):- failed(X, history), failed(X, maths).


%% c)
passed(X, economics):- failed(X, history), passed(X, english).
failed(X, economics):- passed(X, history), passed(X, english).
failed(X, economics):- passed(X, history), failed(X, english).
failed(X, economics):- failed(X, history), failed(X, english).

%% d)
failed(X, history):- failed(X, economics), passed(X, chemistry).
passed(X, history):- passed(X, economics), passed(X, chemistry).
passed(X, history):- passed(X, economics), failed(X, chemistry).
passed(X, history):- failed(X, economics), failed(X, chemistry).

%% e)
failed(X, english):- failed(X, chemistry), passed(X, history).
passed(X, english):- passed(X, chemistry), passed(X, history).
passed(X, english):- passed(X, chemistry), failed(X, history).
passed(X, english):- failed(X, chemistry), failed(X, history).


failed(alexander, english).
passed(alexander, chemistry).

failed(peter, chemistry).
passed(peter, history).

failed(tobias, history).
passed(tobias, maths).

failed(michael, maths).
passed(michael, english).

possible_killers(X):- student(X), not(passed(X, economics)).