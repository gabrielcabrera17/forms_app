part of 'counter_cubit.dart';

class CounterState extends Equatable{

  final int counter;
  final int transactionCount;

 /*-->  este estado */ const CounterState({
    this.counter = 0, 
    this.transactionCount = 0
  });

  //Un nuevo estado será una nueva instancia de este estado
 copyWith({
  int? counter,
  int? transactionCount
 }) => CounterState(
  counter: counter ?? this.counter,
  transactionCount: transactionCount ?? this.transactionCount
 );
 
  @override
  //Aquí tenemos un arreglo con todas las propiedades para considerar que el estado sea igual
  List<Object> get props => [counter, transactionCount];

}

 
