"use client";

import {
  useEffect,
  useState,
} from "react";
import { useRouter } from "next/navigation";
import {
  adminCreateUserSchema,
  adminUpdateUserSchema,
} from "@/lib/validations";

type User = {
  id: string;
  name: string;
  email: string;
  role: "USER" | "ADMIN";
  isVerified: boolean;
};

const defaultForm = {
  name: "",
  email: "",
  password: "",
  role: "USER" as
    | "USER"
    | "ADMIN",
  isVerified: false,
};

export default function AdminPage() {
  const router =
    useRouter();

  const [users, setUsers] =
    useState<User[]>([]);
  const [
    loading,
    setLoading,
  ] = useState(true);
  const [form, setForm] =
    useState(defaultForm);
  const [
    editingId,
    setEditingId,
  ] = useState<
    string | null
  >(null);
  const [error, setError] =
    useState("");

  const fetchUsers =
    async () => {
      const res = await fetch(
        "/api/users",
        {
          cache: "no-store",
        }
      );
      if (!res.ok) {
        setLoading(false);
        return;
      }
      const data =
        await res.json();
      setUsers(data);
      setLoading(false);
    };

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void fetchUsers();
  }, []);

  const resetForm = () => {
    setForm(defaultForm);
    setEditingId(null);
  };

  const onSubmit = async (
    e: React.FormEvent
  ) => {
    e.preventDefault();
    setError("");

    const url = editingId
      ? `/api/users/${editingId}`
      : "/api/users";
    const method = editingId
      ? "PATCH"
      : "POST";

    const payload =
      editingId &&
      !form.password
        ? {
            name: form.name,
            email: form.email,
            role: form.role,
            isVerified:
              form.isVerified,
          }
        : form;

    const parsed = editingId
      ? adminUpdateUserSchema.safeParse(
          payload
        )
      : adminCreateUserSchema.safeParse(
          payload
        );

    if (!parsed.success) {
      setError(
        parsed.error.issues[0]
          ?.message ??
          "Invalid input"
      );
      return;
    }

    const res = await fetch(
      url,
      {
        method,
        headers: {
          "Content-Type":
            "application/json",
        },
        body: JSON.stringify(
          parsed.data
        ),
      }
    );

    const data =
      await res.json();
    if (!res.ok) {
      alert(
        data.message ||
          "Request failed"
      );
      return;
    }

    resetForm();
    await fetchUsers();
  };

  const onEdit = (user: User) => {
    setEditingId(user.id);
    setForm({
      name: user.name,
      email: user.email,
      password: "",
      role: user.role,
      isVerified:
        user.isVerified,
    });
  };

  const onDelete = async (
    id: string
  ) => {
    const ok = confirm(
      "Delete this user?"
    );
    if (!ok) return;

    const res = await fetch(
      `/api/users/${id}`,
      {
        method: "DELETE",
      }
    );
    const data =
      await res.json();
    if (!res.ok) {
      alert(
        data.message ||
          "Delete failed"
      );
      return;
    }

    await fetchUsers();
  };

  return (
    <div className="p-10">
      <h1 className="text-3xl font-bold">
        Admin Panel
      </h1>
      <button
        onClick={() =>
          router.push(
            "/dashboard"
          )
        }
        className="mt-3 border px-3 py-1"
      >
        Home
      </button>

      <p className="mb-6 mt-2">
        Full user CRUD
      </p>

      <form
        onSubmit={onSubmit}
        className="mb-8 grid max-w-2xl gap-3 border p-4"
      >
        {error ? (
          <p className="text-sm text-red-600">
            {error}
          </p>
        ) : null}
        <input
          className="border p-2"
          placeholder="Name"
          value={form.name}
          onChange={(e) =>
            setForm({
              ...form,
              name:
                e.target.value,
            })
          }
          required
        />
        <input
          className="border p-2"
          type="email"
          placeholder="Email"
          value={form.email}
          onChange={(e) =>
            setForm({
              ...form,
              email:
                e.target.value,
            })
          }
          required
        />
        <input
          className="border p-2"
          type="password"
          placeholder={
            editingId
              ? "New password (optional)"
              : "Password"
          }
          value={form.password}
          onChange={(e) =>
            setForm({
              ...form,
              password:
                e.target.value,
            })
          }
          required={!editingId}
        />
        <select
          className="border p-2"
          value={form.role}
          onChange={(e) =>
            setForm({
              ...form,
              role: e.target
                .value as
                | "USER"
                | "ADMIN",
            })
          }
        >
          <option value="USER">
            USER
          </option>
          <option value="ADMIN">
            ADMIN
          </option>
        </select>
        <label className="flex items-center gap-2">
          <input
            type="checkbox"
            checked={
              form.isVerified
            }
            onChange={(e) =>
              setForm({
                ...form,
                isVerified:
                  e.target
                    .checked,
              })
            }
          />
          Verified
        </label>
        <div className="flex gap-2">
          <button className="bg-black px-4 py-2 text-white">
            {editingId
              ? "Update User"
              : "Create User"}
          </button>
          {editingId ? (
            <button
              type="button"
              className="border px-4 py-2"
              onClick={
                resetForm
              }
            >
              Cancel
            </button>
          ) : null}
        </div>
      </form>

      {loading ? (
        <p>Loading users...</p>
      ) : (
        <table className="w-full border">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">
                Name
              </th>
              <th className="p-2">
                Email
              </th>
              <th className="p-2">
                Role
              </th>
              <th className="p-2">
                Verified
              </th>
              <th className="p-2">
                Actions
              </th>
            </tr>
          </thead>
          <tbody>
            {users.map(
              (user) => (
                <tr
                  key={user.id}
                  className="border-b"
                >
                  <td className="p-2">
                    {user.name}
                  </td>
                  <td className="p-2">
                    {user.email}
                  </td>
                  <td className="p-2">
                    {user.role}
                  </td>
                  <td className="p-2">
                    {String(
                      user.isVerified
                    )}
                  </td>
                  <td className="flex gap-2 p-2">
                    <button
                      className="border px-2 py-1"
                      onClick={() =>
                        onEdit(
                          user
                        )
                      }
                    >
                      Edit
                    </button>
                    <button
                      className="bg-red-600 px-2 py-1 text-white"
                      onClick={() =>
                        onDelete(
                          user.id
                        )
                      }
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              )
            )}
          </tbody>
        </table>
      )}
    </div>
  );
}
