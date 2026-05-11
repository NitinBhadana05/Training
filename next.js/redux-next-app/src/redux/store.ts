import { configureStore }
from "@reduxjs/toolkit";

import storage
from "redux-persist/lib/storage";

import {
  persistReducer,
  persistStore,
} from "redux-persist";

import authReducer
from "./features/authSlice";

import counterReducer
from "./features/counterSlice";

import userReducer
from "./features/userSlice";

import { userApi }
from "./services/userApi";

import { authApi }
from "./services/authApi";


// PERSIST CONFIG
const persistConfig = {

  key: "auth",

  storage,

};


// PERSISTED AUTH REDUCER
const persistedReducer =
  persistReducer(
    persistConfig,
    authReducer
  );


export const store =
  configureStore({

    reducer: {

      counter: counterReducer,

      users: userReducer,

      // persisted auth
      auth: persistedReducer,

      // RTK Query reducers
      [userApi.reducerPath]:
        userApi.reducer,

      [authApi.reducerPath]:
        authApi.reducer,

    },

    middleware:
      (getDefaultMiddleware) =>

        getDefaultMiddleware({

          serializableCheck: false,

        })

        .concat(userApi.middleware)

        .concat(authApi.middleware),

});


// PERSISTOR
export const persistor =
  persistStore(store);


// TYPES
export type RootState =
  ReturnType<typeof store.getState>;

export type AppDispatch =
  typeof store.dispatch;