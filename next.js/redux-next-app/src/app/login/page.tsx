"use client";

import { useState } from "react";

import {
  useLoginMutation,
} from "@/redux/services/authApi";

import { useDispatch } from "react-redux";

import {
  setCredentials,
} from "@/redux/features/authSlice";

export default function LoginPage() {

  const [email, setEmail] =
    useState("");

  const [password, setPassword] =
    useState("");

  const dispatch = useDispatch();

  const [
    login,
    { isLoading, error }
  ] = useLoginMutation();

  const handleLogin = async () => {

    try {

      // API CALL
      const response =
        await login({
          email,
          password,
        }).unwrap();

      // SAVE USER + TOKEN
      dispatch(
        setCredentials(response)
      );

      console.log(response);

    } catch (err) {

      console.log(err);

    }
  };

  return (
    <div>

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) =>
          setEmail(e.target.value)
        }
      />

      <br /><br />

      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) =>
          setPassword(e.target.value)
        }
      />

      <br /><br />

      <button onClick={handleLogin}>

        {isLoading
          ? "Loading..."
          : "Login"}

      </button>

      {error && (
        <p>Login failed</p>
      )}

    </div>
  );
}