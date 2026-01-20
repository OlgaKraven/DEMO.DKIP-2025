namespace ClientValidationApp
{
    partial class Form1
    {
        private System.ComponentModel.IContainer components = null;

        private System.Windows.Forms.TextBox txtFio;
        private System.Windows.Forms.Button btnGetData;
        private System.Windows.Forms.Button btnRunTest;
        private System.Windows.Forms.Label lblStatus;
        private System.Windows.Forms.TextBox txtErrors;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            txtFio = new TextBox();
            btnGetData = new Button();
            btnRunTest = new Button();
            lblStatus = new Label();
            txtErrors = new TextBox();
            SuspendLayout();
            // 
            // txtFio
            // 
            txtFio.Location = new Point(24, 20);
            txtFio.Name = "txtFio";
            txtFio.Size = new Size(520, 23);
            txtFio.TabIndex = 0;
            // 
            // btnGetData
            // 
            btnGetData.Location = new Point(24, 58);
            btnGetData.Name = "btnGetData";
            btnGetData.Size = new Size(200, 35);
            btnGetData.TabIndex = 1;
            btnGetData.Text = "Получить данные";
            btnGetData.UseVisualStyleBackColor = true;
            btnGetData.Click += btnGetData_Click;
            // 
            // btnRunTest
            // 
            btnRunTest.Location = new Point(244, 58);
            btnRunTest.Name = "btnRunTest";
            btnRunTest.Size = new Size(300, 35);
            btnRunTest.TabIndex = 2;
            btnRunTest.Text = "Отправить результат теста";
            btnRunTest.UseVisualStyleBackColor = true;
            btnRunTest.Click += btnRunTest_Click;
            // 
            // lblStatus
            // 
            lblStatus.AutoSize = true;
            lblStatus.Location = new Point(24, 104);
            lblStatus.Name = "lblStatus";
            lblStatus.Size = new Size(61, 15);
            lblStatus.TabIndex = 3;
            lblStatus.Text = "Статус: —";
            // 
            // txtErrors
            // 
            txtErrors.Location = new Point(24, 164);
            txtErrors.Multiline = true;
            txtErrors.Name = "txtErrors";
            txtErrors.ReadOnly = true;
            txtErrors.ScrollBars = ScrollBars.Vertical;
            txtErrors.Size = new Size(520, 84);
            txtErrors.TabIndex = 4;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(570, 270);
            Controls.Add(txtErrors);
            Controls.Add(lblStatus);
            Controls.Add(btnRunTest);
            Controls.Add(btnGetData);
            Controls.Add(txtFio);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            Name = "Form1";
            StartPosition = FormStartPosition.CenterScreen;
            Text = "Валидация данных";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion
    }
}
