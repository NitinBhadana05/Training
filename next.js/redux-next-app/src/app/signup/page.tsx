"use client";

import { useState } from "react";

import { useRouter }
from "next/navigation";

export default function SignupPage() {

  const router = useRouter();

  const [name, setName] =
    useState("");

  const [email, setEmail] =
    useState("");

  const [password, setPassword] =
    useState("");

  const handleSignup = async () => {

    // FAKE SIGNUP

    const userData = {

      name,
      email,
      password,

    };

    // SAVE TO LOCAL STORAGE
    localStorage.setItem(
      "signupUser",
      JSON.stringify(userData)
    );

    alert("Signup successful!");

    // REDIRECT TO LOGIN
    router.push("/login");
  };

  return (

    <div
      style={{
        padding: "30px",
      }}
    >

      <h1>Signup Page</h1>

      <br />

      <input
        type="text"
        placeholder="Name"
        value={name}
        onChange={(e) =>
          setName(e.target.value)
        }
      />

      <br /><br />

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

      <button onClick={handleSignup}>
        Signup
      </button>

    </div>
  );
}