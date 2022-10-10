typedef NullParamCallback = Function();
typedef FunctionCallback<T1> = Function(T1 t);
typedef BiFunctionCallback<T1, T2> = Function(T1 t, T2 t2);

typedef NullParamFunctionReturn<R> = R Function();
typedef FunctionReturn<R, T1> = R Function(T1 t);
typedef BiFunctionReturn<R, T1, T2> = R Function(T1 t, T2 t2);
