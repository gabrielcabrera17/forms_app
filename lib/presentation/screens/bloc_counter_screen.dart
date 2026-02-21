import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/counter_bloc/counter_bloc.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: BlocCounterView()
    );
  }
}

void increaseCounterBy(BuildContext context, [int value = 1]){
  context.read<CounterBloc>()
  .add(CounterIncreased(value));
}

class BlocCounterView extends StatelessWidget {
  const BlocCounterView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Counter 0'),
        actions: [
          IconButton( 
            onPressed: () => {},  
            icon: const Icon(Icons.refresh_rounded)
          )
        ],
      ),
      body: Center(
        child: context.select(
          (CounterBloc counterBloc) => Text('Counter Value: ${counterBloc.state.counter}')
        ) ,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '1',
            child: const Text('+3'),
            onPressed: () => increaseCounterBy(context, 3),
          ),
          
          const SizedBox(height: 15,),
    
           FloatingActionButton(
            heroTag: '2',
            child: const Text('+2'),
            onPressed: () => increaseCounterBy(context, 2),
          ),
    
          const SizedBox(height: 15,),
    
           FloatingActionButton(
            heroTag: '3',
            child: const Text('+1'),
            onPressed: () => increaseCounterBy(context, 1),
          )
        ],
      ),
    );
  }
}