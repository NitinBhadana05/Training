"use client";

import { useEffect } from "react";

import {
  useAppDispatch,
  useAppSelector,
} from "../redux/hooks";

import { fetchUsers } from "../redux/features/userSlice";

import {
  increment,
  decrement,
} from "../redux/features/counterSlice";

import {
  useGetUsersQuery,
} from "../redux/services/userApi";
export default function Home() {

  const count = useAppSelector(
    (state) => state.counter.value
  );

  const dispatch = useAppDispatch();

  return (
    <div>
      <h1>Count: {count}</h1>

      <button onClick={() => dispatch(increment())}>
        Increment
      </button>

      &nbsp;&nbsp;

      <button onClick={() => dispatch(decrement())}>
        Decrement
      </button>

      <App />
      <App1 />
    </div>
  );
}

export function App() {

  const dispatch = useAppDispatch();

  const {
    users,
    loading,
    error,
  } = useAppSelector(
    (state) => state.users
  );

  useEffect(() => {
    dispatch(fetchUsers());
  }, [dispatch]);

  if (loading) {
    return <h1>Loading...</h1>;
  }

  if (error) {
    return <h1>Error: {error}</h1>;
  }

  return (
    <div>
      <h1>Users</h1>

      {users.map((user) => (
        <p key={user.id}>
          {user.name}
        </p>
      ))}
    </div>
  );
}




export  function App1() {

  const {
    data: users,
    error,
    isLoading,
  } = useGetUsersQuery("");

  if (isLoading) {
    return <h1>Loading...</h1>;
  }

  if (error) {
    return <h1>Error...</h1>;
  }

  return (
    <div>

      <h1>Users</h1>

      {users?.map((user) => (
        <p key={user.id}>
          {user.name}
        </p>
      ))}

    </div>
  );
}