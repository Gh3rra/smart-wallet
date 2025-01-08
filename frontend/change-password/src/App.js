import "./App.css";
import React, { useState, useEffect } from "react";
import supabase from "./supabase-client";
import { CiCircleCheck, CiWarning } from "react-icons/ci";

function App() {
  const [isSame, setIsSame] = useState(true);
  const [isCorrect, setIsCorrect] = useState(true);
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [isCompleted, setIsCompleted] = useState(false);
  const [isError, setIsError] = useState(false);

  const getSessionByCode = async (tokenHash) => {
    console.log("GET SESSION");
    const {data,error} = await supabase.auth.verifyOtp({
      token_hash: tokenHash,
      type: "recovery",
    });
    if(error){
      setIsError(true);
    }
    
  };

  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search);
    const tokenHash = urlParams.get("token_hash"); // Assicurati che il tuo link contenga ?t
    console.log("USE EFFECT");

    if (tokenHash) {
      getSessionByCode(tokenHash);
    }
  }, []);

  async function save() {
    const same = newPassword === confirmPassword;
    setIsSame(same);
    const correct = RegExp(/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}/).test(
      newPassword
    );
    setIsCorrect(correct);
    if (same && correct) {
      try {
        await supabase.auth.updateUser({
          password: newPassword,
        });
        setIsCompleted(true);
      } catch (error) {
        console.log(error);
      }
    }
  }
  if (isCompleted) {
    return (
      <div className="App">
        <div className="success-container">
          <CiCircleCheck className="check-icon" />
          <h3>Password cambiata</h3>
          <p>
            La tua password è stata cambiata correttamente. Ora puoi chiudere la
            finestra.
          </p>
        </div>
      </div>
    );
  }

  if (isError) {
    return (
      <div className="App">
        <div className="success-container">
          <CiWarning className="error-icon" />
          <h3>Sessione scaduta</h3>
          <p>
            Il link è scaduto o è stato già utilizzato.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      <div className="container">
        <div className="header">
          <h2>Cambia password</h2>
        </div>
        <div className="section">
          <div className="form-container">
            <form action={save} id="reset-password-form">
              <div>
                <label htmlFor="">Nuova password</label>
                <input
                  name="new-password"
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                />
                {isCorrect === true ? (
                  <></>
                ) : (
                  <p className="correct-error">Non rispetta i requisiti.</p>
                )}
              </div>
              <br />
              <div>
                <label htmlFor="">Conferma password</label>
                <input
                  name="confirm-password"
                  value={confirmPassword}
                  type="password"
                  onChange={(e) => setConfirmPassword(e.target.value)}
                />
                {isSame === true ? (
                  <></>
                ) : (
                  <p className="same-password-error">
                    Le password non coincidono.
                  </p>
                )}
              </div>
              <div className="button-container">
                <button type="submit" className="save-button">
                  <p>Cambia password</p>
                </button>
              </div>
            </form>
          </div>
          <div className="rules-container">
            <h3>La password deve contenere:</h3>
            <ul>
              <li>Almeno un carattere minuscolo (a-z)</li>
              <li>Almeno un carattere maiuscolo (A-Z)</li>
              <li>Almeno un numero</li>
              <li>Almeno 8 caratteri</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
