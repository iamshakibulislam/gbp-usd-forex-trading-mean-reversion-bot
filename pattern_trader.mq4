//+------------------------------------------------------------------+
//|                                             autozonetraderEA.mq4 |
//|                                   Copyright 2021, shakibul islam |
//|                                      https://www.webheavenit.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, shakibul islam"
#property link      "https://www.webheavenit.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input bool five_digit_broker = true; //Is this five digit broker
input double stoplossOffset = 2;  //Stop loss offset
//input double risk_percentage = 1; // Risk percentage
input double riskreward = 20;  //Reward to Risk default 2:1
input double risk_amount_in_dollar = 1.0;
input bool is_mini_account = false;
input double sl = 3;

input double account_initial_balance = 0;
input double challange_profit_target = 0; //challange profit target($) stop trading


input double minimum_stoploss = 4; // Minumum Stoploss

input double stop_comp_amount = 20;

input double trailing_stop_pip = 5;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int start(){

return(INIT_SUCCEEDED);

}

int OnInit()
  {
//---

FileDelete("last_trade.txt");

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

double currop = 0.0;

double curr_price_trailing_sell = Bid;
double curr_price_trailing_buy = Ask;

void OnTick()
  {
//---



trailing_stop();

Print("account balance now",AccountBalance());


//for buy trade
   if(
      OrdersTotal() == 0
      
      
      )
      
     {

      double CalculatedPips = sl;
      
      //Print("close price is ",Close[1]," and minus 10 pips is ",Close);
      
      double lotsize = getLotSize(CalculatedPips,risk_amount_in_dollar);
      
      if(is_mini_account == true){
      
      lotsize = lotsize/10.0;
      
      };
      
      
      
      double Tp = Ask+((CalculatedPips)*riskreward)*Point*10;
      double sl = Ask - ((CalculatedPips)*Point*10);
      
      if(five_digit_broker == false){
        Tp = Ask+((CalculatedPips)*riskreward)*Point;
        sl = Ask - ((CalculatedPips)*Point);
      
      }
      
      if(lotsize != 0.00 && lotsize > 0 && (CalculatedPips)>=minimum_stoploss){
      
    
      
      if(last_trade_profit() < 0.0 ){
      
         //check and modify lot size
         
         double get_lost_amount = last_trade_profit();
         
         Print("lost amount is ",get_lost_amount);
         
         lotsize = getLotSize(CalculatedPips, MathAbs(get_lost_amount*2));
         
         if(last_trade_profit() < -stop_comp_amount){
         
            lotsize = getLotSize(CalculatedPips,risk_amount_in_dollar);
            write_into_file(0);
         
         }
         
         if(is_mini_account == true){
                  
                  lotsize = lotsize/10.0;
               }
      
      }
      
      
      
      int rsishift = 0;
      /*
      if(patternScanner() == Low[1]){
      
         rsishift = 1;
      
      }
      else if(patternScanner() == Low[2]){
         rsishift = 2;
      }
      
      else if(patternScanner() == Low[3]){
         rsishift = 3;
      }
      else{
      rsishift = 0;
      }
      */
      int rsival = iRSI(NULL,0,14,PRICE_CLOSE,0);
      
      
      
      double upperband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_UPPER,1);
      double lowerband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_LOWER,1);
      
      double prev_upperband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_UPPER,2);
      double prev_lowerband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_LOWER,2);
      
      int ticket = 0;
      
      double op = Open[2];
      double cl = Close[2];
      
      if(AccountBalance() < challange_profit_target+account_initial_balance || challange_profit_target == 0){
      
      if (lowerband > Close[1] && Close[1] < Open[1] && rsival < 30 && lowerband < Close[2]  ){
      
      Print("bought");
      
       ticket = OrderSend(Symbol(),OP_BUY,lotsize,Ask,2,sl,Tp,"traded from EA",9999,NULL,Blue);
       curr_price_trailing_buy = Ask;
       currop = Open[0];
      
         }
         
         }
       
       if(ticket > 0){
       //save the ticket into the file pending
       
       Print("curr ticket is ",ticket);
         
         //write_into_file(ticket);
       
       
       
       }
      
      }


     }
     
     
    
     
     
     
     
     
     
     
     
//for sell trade function starts here

if(
      OrdersTotal() == 0
      
      
      )
      
     {

      double CalculatedPips = sl;
      
      Print("calculated pips sellside ",CalculatedPips);
      
      double lotsize = getLotSize(CalculatedPips,risk_amount_in_dollar);
      
      if(is_mini_account == true){
      
      lotsize = lotsize/10.0;
      
      };
      
      
      double Tp = Bid-((CalculatedPips)*riskreward)*Point*10;
      double sl = Bid + ((CalculatedPips)*Point*10);
      
      if(five_digit_broker == false){
       Tp = Bid-((CalculatedPips)*riskreward)*Point;
       sl = Bid + ((CalculatedPips)*Point);
      
      }
      
      if(lotsize != 0.00 && lotsize > 0 &&(CalculatedPips)>=minimum_stoploss){
      
      
      /*
      
       if(last_trade_profit() < 0.0 ){
      
         //check and modify lot size
         
         double get_lost_amount = last_trade_profit();
         
         Print("get lost amount from sell side ",get_lost_amount);
         
         lotsize = getLotSize(CalculatedPips, MathAbs(get_lost_amount*2));
         
         if(last_trade_profit() < -stop_comp_amount){
         
            lotsize = getLotSize(CalculatedPips,risk_amount_in_dollar);
            write_into_file(0);
         
         }
         
         if(is_mini_account == true){
                  
                  lotsize = lotsize/10.0;
               }
      
      }
      
      */
      
      int rsishift = 0;
      /*
      
      if(patternScanner() == High[1]){
      
         rsishift = 1;
      
      }
      else if(patternScanner() == High[2]){
         rsishift = 2;
      }
      
      else if(patternScanner() == High[3]){
         rsishift = 3;
      }
      else{
      rsishift = 0;
      }
      
      */
      
      int rsival = iRSI(NULL,0,14,PRICE_CLOSE,0);
      
      int prevrsi = iRSI(NULL,0,14,PRICE_CLOSE,2);
      
      int ticket = 0;
      
      double op = Open[2];
      double cl = Close[2];
      
      double lowerband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_LOWER,1);
      double upperband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_UPPER,1);
      
      
      double prev_upperband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_UPPER,2);
      double prev_lowerband = iBands(NULL,0,20,2.5,0,PRICE_CLOSE,MODE_LOWER,2);
      
      if(AccountBalance() < challange_profit_target+account_initial_balance || challange_profit_target == 0){
      
      if(upperband < Close[1] && Close[1] > Open[1] && rsival > 70 && upperband > Close[2]){
      
      Print("sold");
      
       ticket = OrderSend(Symbol(),OP_SELL,lotsize,Bid,2,sl,Tp,"traded from EA",9999,NULL,Blue);
       curr_price_trailing_sell = Bid;
       
       currop = Open[0];
      
       }
       
       }
       
       
       
      
      if(ticket > 0){
       //save the ticket into the file pending
       
       Print("ticket from sell side is ",ticket);
         
         //write_into_file(ticket);
       
       
       
       };
       
      // if(ticket != 0){delLine("sell");delLine("sell_sl");}
      
      }


     }
     
     
    
     




//end of sell trade 



  }



//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double patternScanner()
  {


   double FirstCandleHigh = High[1];
   double FirstCandleLow = Low[1];
   double FirstCandleClose = Close[1];
   double FirstCandleOpen = Open[1];

   double SecondCandleHigh = High[2];
   double SecondCandleLow = Low[2];
   double SecondCandleOpen = Open[2];
   double SecondCandleClose = Close[2];

   double ThirdCandleHigh = High[3];
   double ThirdCandleLow = Low[3];
   double ThirdCandleOpen = Open[3];
   double ThirdCandleClose = Close[3];



   double FourthCandleHigh = High[4];
   double FourthCandleLow = Low[4];
   double FourthCandleOpen = Open[4];
   double FourthCandleClose = Close[4];



   double FifthCandleHigh = High[5];
   double FifthCandleLow = Low[5];
   double FifthCandleOpen = Open[5];
   double FifthCandleClose = Close[5];

//end of candle selection


   if(

      FirstCandleClose > FirstCandleOpen &&
      SecondCandleClose < SecondCandleOpen &&
      FirstCandleClose > SecondCandleHigh &&
      MathAbs(FirstCandleHigh - FirstCandleLow) > MathAbs(SecondCandleHigh - SecondCandleLow) &&
      (FirstCandleLow < SecondCandleLow || SecondCandleLow < ThirdCandleLow || ThirdCandleClose < ThirdCandleOpen)


   )
     {

      if(FirstCandleLow < SecondCandleLow)
        {
         return FirstCandleLow;
        }

      else
        {
         return SecondCandleLow;
        }

     }


   else
      if(

         FirstCandleClose < FirstCandleOpen &&
         SecondCandleClose > SecondCandleOpen &&
         FirstCandleClose < SecondCandleLow &&
         MathAbs(FirstCandleHigh - FirstCandleLow) > MathAbs(SecondCandleHigh - SecondCandleLow) &&
         (FirstCandleHigh > SecondCandleHigh || SecondCandleHigh > ThirdCandleHigh || ThirdCandleClose > ThirdCandleOpen)


      )
        {

         if(FirstCandleHigh > SecondCandleHigh)
           {
            return FirstCandleHigh;
           }

         else
           {
            return SecondCandleHigh;
           }

        }



      else
         if(
            MathAbs(FirstCandleHigh-FirstCandleClose) < MathAbs(FirstCandleClose - FirstCandleOpen) &&
            SecondCandleClose > SecondCandleOpen &&
            MathAbs(SecondCandleClose - SecondCandleOpen)*3 < MathAbs(FirstCandleHigh - FirstCandleLow) &&

            (ThirdCandleClose < ThirdCandleOpen || FirstCandleLow < SecondCandleLow || SecondCandleLow < ThirdCandleLow)

         )
           {
           
           if(FirstCandleLow < SecondCandleLow){return FirstCandleLow;}
            
            else if(FirstCandleLow > SecondCandleLow){
            return (SecondCandleLow);}

           } //end of bullish doji

//starting scanning for bearish doji

         else
            if(
               MathAbs(FirstCandleLow-FirstCandleClose) < MathAbs(FirstCandleOpen - FirstCandleClose) &&
               SecondCandleClose < SecondCandleOpen &&
               MathAbs(SecondCandleOpen - SecondCandleClose)*3 < MathAbs(FirstCandleHigh - FirstCandleLow) &&

               (ThirdCandleClose > ThirdCandleOpen || FirstCandleHigh > SecondCandleHigh || SecondCandleHigh > ThirdCandleHigh)

            )
              {
               
               if(FirstCandleHigh > SecondCandleHigh){return FirstCandleHigh;}
               
               else if(SecondCandleHigh > FirstCandleHigh){
               return (SecondCandleHigh);}

              }


            //starting three black/white crow pattern detection
            else
               if(
                  FirstCandleClose > FirstCandleOpen && MathAbs(FirstCandleHigh - FirstCandleClose) < MathAbs(FirstCandleClose - FirstCandleOpen) && FirstCandleHigh>SecondCandleHigh &&
                  SecondCandleClose > SecondCandleOpen && MathAbs(SecondCandleHigh - SecondCandleClose) < MathAbs(SecondCandleClose - SecondCandleOpen) && SecondCandleHigh>ThirdCandleHigh &&
                  ThirdCandleClose > ThirdCandleOpen && MathAbs(ThirdCandleHigh - ThirdCandleClose) < MathAbs(ThirdCandleClose - ThirdCandleOpen) && FourthCandleClose < FourthCandleOpen
               )
                 {

                  return (ThirdCandleLow);
                 }


               else
                  if(
                     FirstCandleClose < FirstCandleOpen && MathAbs(FirstCandleLow - FirstCandleClose) < MathAbs(FirstCandleOpen - FirstCandleClose) && FirstCandleLow<SecondCandleLow &&
                     SecondCandleClose < SecondCandleOpen && MathAbs(SecondCandleLow - SecondCandleClose) < MathAbs(SecondCandleOpen - SecondCandleClose) && SecondCandleLow<ThirdCandleLow &&
                     ThirdCandleClose < ThirdCandleOpen && MathAbs(ThirdCandleLow - ThirdCandleClose) < MathAbs(ThirdCandleOpen - ThirdCandleClose) && FourthCandleClose > FourthCandleOpen
                  )
                    {

                     return (ThirdCandleHigh);
                    }



                  else
                     if(

                        //bullish pinbar

                        FirstCandleOpen < FirstCandleClose && MathAbs(FirstCandleClose - FirstCandleOpen)*3 < MathAbs(FirstCandleOpen - FirstCandleLow) &&
                        MathAbs(FirstCandleHigh - FirstCandleClose) < MathAbs(FirstCandleClose-FirstCandleOpen)*2

                     )
                       {

                        return (FirstCandleLow);


                       }




                     else
                        if(

                           //bullish pinbar

                           FirstCandleOpen > FirstCandleClose && MathAbs(FirstCandleOpen - FirstCandleClose)*3 < MathAbs(FirstCandleHigh - FirstCandleOpen) &&
                           MathAbs(FirstCandleClose - FirstCandleLow) < MathAbs(FirstCandleOpen-FirstCandleClose)*2

                        )
                          {

                           return (FirstCandleHigh);


                          }



   return 0.00;


  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getZonePrice(string level_name)
  {
//level names are the same as line name //  buy,buy_sl and sell ,sell_sl

   if(level_name == "buy")
     {

      return (ObjectGetDouble(0,"buy",OBJPROP_PRICE));

     }


   else
      if(level_name == "sell")
        {

         return (ObjectGetDouble(0,"sell",OBJPROP_PRICE));

        }


      else
         if(level_name == "sell_sl")
           {

            return (ObjectGetDouble(0,"sell_sl",OBJPROP_PRICE));

           }



         else
            if(level_name == "buy_sl")
              {

               return (ObjectGetDouble(0,"buy_sl",OBJPROP_PRICE));

              }


   return 0.00;

  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getLotSize(double pips,double amount)
  {

   //double riskamount = (AccountBalance()*0.01*risk_percentage);
   
   double riskamount = amount;

   double lot = 0.00;

   if(five_digit_broker == true)
     {
      lot = (riskamount/pips)/(MarketInfo(Symbol(),MODE_TICKVALUE)*10);

      return lot;

     }


   else
     {

      lot = (riskamount/pips)/(MarketInfo(Symbol(),MODE_TICKVALUE));

      return lot;

     }

  }



//calculate pip from price difference


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double getPips(double price1,double price2)
  {

   if(MarketInfo(Symbol(),MODE_DIGITS)==5)
     {

      double pipDiff = (MathAbs(price1 - price2)*10000);

      return pipDiff;

     }


   else
      if(MarketInfo(Symbol(),MODE_DIGITS)==3)
        {

         double pipDiff = (MathAbs(price1 - price2)*100);

         return pipDiff;
        }





      else
        {

         return 0.00;


        }



  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool delLine(string name)
  {

   ObjectDelete(0,name);

   return true;

  }
//+------------------------------------------------------------------+

//+-----------------------write-read-file-and return last trade ticket number------------------+


double last_trade_profit(){

  //check if the file exists or not
  
  
  
  if(FileIsExist("last_trade.txt")){
  
         int oop = FileOpen("last_trade.txt",FILE_READ|FILE_TXT);
         
         int ticket_number = FileReadString(oop);
         
         Print("ticket number is ",ticket_number);
         
         
         
         if(ticket_number > 0 ){
         
            //real ticket number found
            
            if(OrderSelect(ticket_number,SELECT_BY_TICKET,MODE_HISTORY)){
            
              FileClose(oop);
              
              Print("order profit is past ",OrderProfit());
      
              return OrderProfit();
   
               }
         
         }
         
         else{
         
         //ticket number is == 0. That means first trade
         FileClose(oop);
         return 0.00;
         
         }
         
         
         
         
  
  }
  
  else{
  
  //file does not exists--so--create new file with value 0 inside it
  
               int op = FileOpen("last_trade.txt",FILE_WRITE|FILE_TXT);
               FileWrite(op,0);
               
               FileClose(op);
               
               return 0.00;
  
  
  
             };
             
 return 0.00;

}



int write_into_file(int ticket){

   int op = FileOpen("last_trade.txt",FILE_WRITE|FILE_TXT);
   FileWrite(op,ticket);
   Print(op);
   FileClose(op);
   
   Print("wrote into the file ",ticket);
   
   return ticket;

}



bool trailing_stop(){

if(OrdersTotal() > 0){

   //check open orders -- and modify according to current price
   
   for(int i = 0 ; i < OrdersTotal() ; i++ ) { 
                // We select the order of index i selecting by position and from the pool of market/pending trades.
                OrderSelect( i, SELECT_BY_POS, MODE_TRADES ); 
                double open_price = OrderOpenPrice();
                
                // If the pair of the order is equal to the pair where the EA is running.
                if (OrderSymbol() == Symbol()){
                
                  //do modification here
                  
                  if(OrderType() == OP_SELL){
                  
                    double curr_price = Bid;
                    
                    if(open_price > curr_price && (curr_price -(trailing_stop_pip*Point*10)) <= curr_price_trailing_sell ){
                    
                    
                        OrderModify(OrderTicket(),0,MathAbs(OrderStopLoss()-(curr_price_trailing_sell-curr_price)),0,0,Red);
                        curr_price_trailing_sell = Bid;
                    
                    
                    }
                  
                  }
                
                } 
                
                
                //for buy trade trailing stop logic here
                
                if(OrderType() == OP_BUY){
                  
                    double curr_price = Ask;
                    
                    if(open_price < curr_price && curr_price >= curr_price_trailing_buy + (trailing_stop_pip*Point*10)){
                    
                    
                        OrderModify(OrderTicket(),0,MathAbs(OrderStopLoss()+(curr_price-curr_price_trailing_buy)),0,0,Green);
                        curr_price_trailing_buy = Ask;
                    
                    
                    }
                  
                  }
                
                } 
                
                
        } 


return true;


}


