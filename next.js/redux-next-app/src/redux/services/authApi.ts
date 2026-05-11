import {
  createApi,
  fetchBaseQuery,
} from "@reduxjs/toolkit/query/react";



export const authApi = createApi({
  reducerPath: "authApi",

  baseQuery: fetchBaseQuery({

    baseUrl: "http://localhost:5000/api/",

    prepareHeaders: (
      headers,
      { }
    ) => {

      const token = localStorage.getItem('token');

      if (token) {

        headers.set(
          "authorization",
          `Bearer ${token}`
        );

      }

      return headers;
    },

  }),

  endpoints: (builder) => ({

    login: builder.mutation({

      query: (credentials) => ({

        url: "login",
        method: "POST",
        body: credentials,

      }),

    }),

  }),
});

export const {
  useLoginMutation,
} = authApi;