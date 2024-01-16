import { createAsyncThunk } from '@reduxjs/toolkit';
import api from '../api';
import jwt_decode from 'jwt-decode';

// createAsyncThunk handles pending, fulfilled, and rejected states internally
export const actionLoginFetch = createAsyncThunk(
    'users/fetchByEmail',
    async ({ email, password }, { rejectWithValue }) => {
        try {
            const { data } = await api.post('/auth/login', {
                email: email,
                password: password,
            }).catch((error)=>{
                if(error.code== "ERR_BAD_REQUEST"){
                    alert("Invalid Username or Password...");
                }
            });
    
            // Store the token in localStorage or sessionStorage
            localStorage.setItem('token', data.token);

            // Set the Authorization header for future API requests
            api.defaults.headers.common.Authorization = `Bearer ${data.token}`;
            // Decode the token
            const decodedToken = jwt_decode(data.token);

            // if(data.token){
            //     window.location = '/admin';
            // }
           
            return {
                id: decodedToken.id,
                admin: decodedToken.admin,
                firstName: decodedToken.firstName,
                experience: decodedToken.experience,
                token: data.token
                // You may omit the token here if it's stored in localStorage/sessionStorage
            };
        } catch (error) {
            // Handle any error from the API here
            return rejectWithValue(error.response.data);
        }
    }
);

export const LOGOUT = 'LOGOUT';
export const actionLogOut = () => {
    // Remove the token from storage and headers when logging out
    localStorage.removeItem('token');
    delete api.defaults.headers.common.Authorization;
    
    return { type: LOGOUT };
};
