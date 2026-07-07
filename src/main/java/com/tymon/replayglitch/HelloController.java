package com.tymon.replayglitch;

import javafx.fxml.FXML;
import javafx.scene.control.Label;

public class HelloController {
    @FXML
    private Label statusLabel;

    @FXML
    protected void onActionOneClic() {
        statusLabel.setText("Active");
    }
    @FXML
    protected void onActionTwoClick(){
        statusLabel.setText("Inactive");
    }
}
