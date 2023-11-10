Attribute VB_Name = "Module1"
Sub Stock_Info_Year()

Dim ws As Worksheet

For Each ws In ThisWorkbook.Sheets
    
    With ws
        
        'Setting the headers for each of the worksheets
        .Cells(1, 9).Value = "Ticker"
        .Cells(1, 10).Value = "Yearly Change"
        .Cells(1, 11).Value = "Percent Change"
        .Cells(1, 12).Value = "Volume"
        
        'set variable for storing Stock Ticker'
        Dim Ticker As String

        'set variable for calculating yearly change'
        Dim Yearly_Change As Double

        'set variable for calculating percentage change'
        Dim Percentage_Change As Double

        'Set Variable for Storing Stock Volume'
        Dim Stock_Volume As Double
        Stock_Volume = 0

        'Row_Counter is used to run in tandum with Row_ and is used later to subtract against row to get back to the front of the data set
        Dim Row_Counter As Double
        Row_Counter = 0

        'Keep track of the location for each Ticker in the sheet'
        Dim Year_Table_Row As Integer
        Year_Table_Row = 2
        .Columns("K:K").NumberFormat = "0.00%"

        'Loop through until last row. This tool was grabbed from ChatGPT-4
        Dim LastRow As Long
        LastRow = .Cells(Rows.Count, 1).End(xlUp).Row


        For Row_ = 2 To LastRow
    
            'Check if we are still within the same Stock Ticker, the Row_+1,1 is looking at the cell
            'ahead of the current cell, and checking if it is equal. If it is equal, then it skips to the
            'Else statement. If it is unequal, it proceeds with the code directly below
            If .Cells(Row_ + 1, 1).Value <> .Cells(Row_, 1).Value Then
            
                'The Ticker is equal to the value in the current row, and the first column (Row_, 1)
                Ticker = .Cells(Row_, 1).Value
        
                'Stock Volume is equal to the current stock volume + the value in the current
                'row and the seventh column
                Stock_Volume = Stock_Volume + .Cells(Row_, 7).Value
        
                'Print the stock ticker into column I + the current Year_Table_Row number
                .Range("I" & Year_Table_Row).Value = Ticker
        
                'Print the current accumulated stock volumn into column L + the current Year_Table_Row number
                .Range("L" & Year_Table_Row).Value = Stock_Volume
            
                'YEARLY CHANGE I've managed to get back to the first row in the set by creating a seperate variable called Row_Counter
                'Which I use to subtract to the Row_ amount.
                .Range("J" & Year_Table_Row).Value = .Cells(Row_, 6) - .Cells((Row_ - Row_Counter), 3)
            
                    'Cell color fill addition that will color the row directly after indexing the number
                    If .Range("J" & Year_Table_Row).Value < 0 Then
                        .Range("J" & Year_Table_Row).Interior.Color = vbRed
                    ElseIf .Range("J" & Year_Table_Row).Value > 0 Then
                        .Range("J" & Year_Table_Row).Interior.Color = vbGreen
                    Else
   
                    End If
            
                'PERCENT CHANGE I am trying to take the last row in column G for a Ticker, and divide by the value in the first row column C
                'This requires that I follow the percent change formula: Percentage Change = (Yearly Change/ Opening Price)
                'I am negelcting to mutiply the amount by 100 here becasue I have already coded to format column K to be percentage earlier in the script
                If .Cells((Row_ - Row_Counter), 3).Value <> 0 Then
                    Yearly_Change = .Cells(Row_, 6).Value - .Cells((Row_ - Row_Counter), 3).Value
                    Percentage_Change = (Yearly_Change / .Cells((Row_ - Row_Counter), 3).Value)
                    .Range("K" & Year_Table_Row).Value = Percentage_Change
    
                End If
            
                'add +1 to the current Year_Table_Row number so that it current row changes for the table
                Year_Table_Row = Year_Table_Row + 1
            
                'Reset stock volume so that the values for the next Ticker can start accumulating
                Stock_Volume = 0
            
                'Row_Counter needs to be set back to 0 so that the count can start over for the next ticker
                Row_Counter = 0
            
            Else

                'If the current cell and the previous cell aren't equal to one another, then Stock_Volume will add the current volume in row G
                'to the current amount stored in Stock_Volume
                Stock_Volume = Stock_Volume + .Cells(Row_, 7)
                Row_Counter = Row_Counter + 1
            
            End If

        Next Row_
        
        
        
       
      'Now I need to put together a sepeate nested loop for Greatest % Increase, Greateset % Decrease, and Greatest Total Volumn
            .Cells(1, 16).Value = "Ticker"
            .Cells(1, 17).Value = "Value"
            Dim Greatest_Increase As Double
            Dim Greatest_Decrease As Double
            Dim Greatest_Volume As Double
            Dim Ticker_Increase As String
            Dim Ticker_Decrease As String
            Dim Ticker_Volume As String
            
            'Creating a variable to store the greatest increase within
            Greatest_Increase = 0
            'Creating a variable to store the greatest decrease within
            Greatest_Decrease = 0
            'Creating a variable to store the greatest volumn within
            Greatest_Volume = 0

        

            ' Now I need to loop through my Year_Table_Row to find the values I want, and store them within the variables I just created
            For i = 2 To Year_Table_Row
                'If the current cell is greater than the current value...
                If .Cells(i, "K").Value > Greatest_Increase Then
                    'Replace the value of Greatest_Increase with the value in the current cell...
                    Greatest_Increase = .Cells(i, "K").Value
                    'And also grab the corresponding Ticker value, and replace the current value of Ticker_Increase
                    Ticker_Increase = .Cells(i, "I").Value
                End If
                
                 'If the current cell is less than the current value...
                If .Cells(i, "K").Value < Greatest_Decrease Then
                     'Replace the value of Greatest_Decrease with the value in the current cell...
                    Greatest_Decrease = .Cells(i, "K").Value
                    'And also grab the corresponding Ticker value, and replace the current value of Ticker_Decrease
                    Ticker_Decrease = .Cells(i, "I").Value
                End If
                
                'Same logic as abone
                If .Cells(i, "L").Value > Greatest_Volume Then
                    Greatest_Volume = .Cells(i, "L").Value
                    Ticker_Volume = .Cells(i, "I").Value
                End If
            Next i

            ' This is where all data collected above will be output in columns O-Q
            .Cells(2, 15).Value = "Greatest % Increase"
            .Cells(2, 16).Value = Ticker_Increase
            .Cells(2, 17).Value = Greatest_Increase
            .Cells(2, 17).NumberFormat = "0.00%"

            .Cells(3, 15).Value = "Greatest % Decrease"
            .Cells(3, 16).Value = Ticker_Decrease
            .Cells(3, 17).Value = Greatest_Decrease
            .Cells(3, 17).NumberFormat = "0.00%"

            .Cells(4, 15).Value = "Greatest Total Volume"
            .Cells(4, 16).Value = Ticker_Volume
            .Cells(4, 17).Value = Greatest_Volume
        
        End With
    
    Next ws

End Sub

