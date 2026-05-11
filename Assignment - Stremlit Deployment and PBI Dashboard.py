import streamlit as st
import pandas as os
import pickle
from PIL import Image
import os
import pandas as pd
import numpy as np

st.set_page_config(layout="wide")
with open('linear_model.pkl', 'rb') as file:
    lm2 = pickle.load(file)

side_image=Image.open(r"C:\Users\prati\Desktop\TM\Pic 1.PNG")
st.sidebar.image(image=side_image, use_column_width=True)
st.sidebar.header("Vehicle Features")

def get_user_input():
    Make = st.sidebar.selectbox('Make', ('Acura', 'Audi', 'BMW', 'Buick', 'Cadillac', 'Chevrolet', 'Chrysler', 'Dodge', 'Ford', 'GMC', 'Honda', 'Hyundai', 'Infiniti', 'Jeep', 'Kia', 'Lexus', 'Lincoln', 'Mazda', 'Mercedes-Benz', 'Nissan', 'Ram Trucks', 'Subaru', 'Tesla', 'Toyota', 'Volkswagen','Volvo'))
    Body_Size = st.sidebar.selectbox('Body Size', ('Compact Cars','Large Cars','Midsize Cars','Minicompact Cars','Small Station Wagons','Standard Pickup Trucks','Subcompact Cars','Two Seaters'))
    Body_Style = st.sidebar.selectbox('Body Style', ('Convertible','Coupe','Hatchback 4D','Hatchback 5D','Sedan','Wagon 4D'))
    Engine_Aspiration = st.sidebar.selectbox('Engine Aspiration', ('Natural Aspiration','Turbocharged'))
    Drivetrain = st.sidebar.selectbox('Drivetrain', ('All Wheel Drive','Front Wheel Drive','Rear Wheel Drive'))
    Transmission = st.sidebar.selectbox('Transmission Type', ('Automatic','Manual'))
    HousePower_No = st.sidebar.slider('Horsepower (HP)', 70, 1000, step=10)
    Torque_No = st.sidebar.slider('Torque (lb-ft)', 70, 1000, step=10)

    user_data = {
        "Make": Make,
        "Body Size": Body_Size,
        "Body Style": Body_Style,
        "Engine Aspiration": Engine_Aspiration,
        "Drivetrain": Drivetrain,
        "Transmission": Transmission,
        "HousePower_No": HousePower_No,
        "Torque_No": Torque_No
    }
    
    # user_data = pd.DataFrame(user_data, index=[0])
    return user_data

image_banner=Image.open(r"C:\Users\prati\Desktop\TM\Pic 2.PNG")
st.image(image_banner, use_column_width=True)

st.markdown('<h1 style="test-align: center; color: black;">Vehicle Price Prediction App</h1>', unsafe_allow_html=True)
left_col,right_col=st.columns(2)
with left_col:
    st.subheader("Feature details")
    user_input = get_user_input()
    st.write(user_input)

with right_col:
    st.header("Predict Vehicle Price")
    def prepare_input(data, feature_list):
        input_data = {feature: data.get(feature, 0) for feature in feature_list}
        return np.array([list(input_data.values())])

    
    features = [
        'Horsepower_No', 'Torque_No', 'Make_Aston Martin', 'Make_Audi', 'Make_BMW', 'Make_Bentley',
        'Make_Ford', 'Make_Mercedes-Benz', 'Make_Nissan', 'Body Size_Compact', 'Body Size_Large',
        'Body Size_Midsize', 'Body Style_Cargo Minivan', 'Body Style_Cargo Van', 
        'Body Style_Convertible', 'Body Style_Convertible SUV', 'Body Style_Coupe', 
        'Body Style_Hatchback', 'Body Style_Passenger Minivan', 'Body Style_Passenger Van',
        'Body Style_Pickup Truck', 'Body Style_SUV', 'Body Style_Sedan', 'Body Style_Wagon',
        'Engine Aspiration_Electric Motor', 'Engine Aspiration_Naturally Aspirated',
        'Engine Aspiration_Supercharged', 'Engine Aspiration_Turbocharged',
        'Engine Aspiration_Twin-Turbo', 'Engine Aspiration_Twincharged', 
        'Drivetrain_4WD', 'Drivetrain_AWD', 'Drivetrain_FWD', 'Drivetrain_RWD', 
        'Transmission_automatic', 'Transmission_manual'
    ]


    if st.button("Predict"):
        input_array=prepare_input(user_input,features)
        prediction=lm2.predict(input_array)
        st.subheader("Predicted Price")
        st.write(f"${prediction[0]:,.2f}")

    
