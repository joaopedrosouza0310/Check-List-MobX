import 'package:mobx/mobx.dart';
import 'package:todomobx/stores/todo_store.dart';

part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  @observable
  String newTodoTitle = "";

  //Lista observavel para que não precise sempre instanciar uma nova lista para que o mobx reconheça e observe a mudança
  ObservableList<TodoStore> todoList = ObservableList<TodoStore>();

  @action
  void addTodo() {
    todoList.insert(0, TodoStore(newTodoTitle));
    newTodoTitle = "";
  }

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;
}
