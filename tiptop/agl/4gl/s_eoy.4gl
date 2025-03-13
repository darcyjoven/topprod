# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Modify.........: No.MOD-510030 05/01/11 By Kitty 若專案無aag04=1資產科目則不做insert動作,否則會無法拋轉
# Modify.........: No.MOD-520041 05/02/14 By Kitty 如果本期損益金額為負(費用-收入), 則科目借貸別必需反向才是(借->貸, 貸->借), 金額改為正值
# Modify.........: No.FUN-5C0015 060105 BY GILL 新增aed012和ted012的值
# Modify.........: No.MOD-610099 06/01/19 By Smapmin 貸餘科目餘額小於0要多*-1
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-710023 07/01/19 By yjkhero 錯誤訊息匯整 
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980160 09/09/03 By sabrina 當agls103之本期損益(資產)、本期損益(損益)及累計盈虧這三個科目設為「明細科目」時
#                                                    aglp202結轉後，會造成明細科目餘額是正確的，統制科目餘額是錯誤的。
# Modify.........: No.CHI-A40053 10/05/07 By sabrina 做年結時，統制科目下的所有明細科目要一併加總
# Modify.........: No.FUN-AB0068 11/01/06 By Carrier 增加"次年科目变更"功能
# Modify.........: No.MOD-BA0147 11/10/19 By Carrier aaz33的父级科目,当余额在借货时,少乘了-1
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No:FUN-BC0087 12/01/16 By Lori 取tag_file時須加入tagacti(有效否欄位)做為條件過濾資料
# Modify.........: No:MOD-C20150 12/02/16 By Dido 抓取 aed012 效能改善 
# Modify.........: No:CHI-C30014 12/03/10 By belle 年結時將(agli115)所列IFRS權益BS科目應結轉到次年(0期) 
# Modify.........: No:MOD-C40210 12/05/15 By Polly 增加update 段條件餘額調整
# Modify.........: No:CHI-C80020 12/08/07 By belle 年結時將(agli115)所列IFRS權益BS科目應結轉到次年(0期)累計盈虧
# Modify.........: No:MOD-C80266 12/09/03 By Polly 調整年結程式在update tah_file段的條件
# Modify.........: No:CHI-D10004 13/01/04 By Polly 當aaz83 = Y時，需增加寫入tah_file
# Modify.........: No.MOD-D10019 13/01/08 By Belle 年結時會將屬於"帳戶"類型的資產類科目餘額結轉至次年期初，但因客戶可能將agli115中的結轉BS科目設為"帳戶"類型
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
DEFINE    g_profit   LIKE aah_file.aah04,
          l_aah05   LIKE aah_file.aah05,
          g_y_sum LIKE aah_file.aah04, 
          l_aah01   LIKE aah_file.aah01,
          l_master  LIKE aah_file.aah01,
          next_yy   LIKE aaa_file.aaa04,        # This Year Ex:1990
          l_aag04   LIKE aag_file.aag04,
#FUN-BC0027 --begin--
#          g_aaz31   LIKE aaz_file.aaz31,
#          g_aaz32   LIKE aaz_file.aaz32,
#          g_aaz33   LIKE aaz_file.aaz33,
           g_aaa14   LIKE aaa_file.aaa14,
           g_aaa15   LIKE aaa_file.aaa15,
           g_aaa16   LIKE aaa_file.aaa16,
           g_aaa     RECORD LIKE aaa_file.*,
#FUN-BC0027 --end--
         #g_aay     RECORD LIKE aay_file.*, 
          l_aed05   LIKE aed_file.aed05,
          l_aed06   LIKE aed_file.aed06,
          l_aed01   LIKE aed_file.aed01,
          l_aed011  LIKE aed_file.aed011,
          l_aed02   LIKE aed_file.aed02,
          l_str     LIKE type_file.chr21,        #No.FUN-680098 VARCHAR(21)
          l_cnt     LIKE type_file.num5          #No.FUN-680098 smallint
  DEFINE  pp_aaa00   LIKE aaa_file.aaa01,
          last_yy   LIKE aaa_file.aaa04                 # Last Year Ex:1989
  DEFINE  g_chg     LIKE type_file.chr1          #No.FUN-AB0068                 
#No.FUN-AB0068  --Begin                                                         
#FUNCTION s_eoy(p_aaa00,p_aaa04)                                 #年结          
FUNCTION s_eoy(p_aaa00,p_aaa04,p_chg)                            #年结          
#No.FUN-AB0068  --End  
  DEFINE  p_aaa00   LIKE aaa_file.aaa01,
          p_aaa04   LIKE aaa_file.aaa04                 # Last Year Ex:1989
  DEFINE  p_chg     LIKE type_file.chr1            #No.FUN-AB0068
  DEFINE  p_row,p_col LIKE type_file.num5          #No.FUN-680098 smallint
     WHENEVER ERROR CONTINUE
     SET LOCK  MODE  TO WAIT
     LET pp_aaa00 = p_aaa00
     LET last_yy  = p_aaa04
     LET next_yy  = last_yy + 1
     LET g_chg    = p_chg        #科目次年变更   #No.FUN-AB0068
     DISPLAY 'next:',next_yy AT 4,1
     LET p_row = 18 LET p_col = 26
     OPEN WINDOW eoy_g_w AT p_row,p_col 
               WITH 5 rows, 30 COLUMNS 
     CALL cl_getmsg('agl-036',g_lang) RETURNING l_str
     DISPLAY l_str at 3,6 

    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = pp_aaa00   #FUN-BC0027     
     WHILE TRUE
        #No.FUN-AB0068  --Begin                                                 
        #CALL s_eoy_del_next_year()                                             
        CALL s_eoy_del_next_year_1()                                            
        #No.FUN-AB0068  --End 
        IF g_success = 'N' THEN EXIT WHILE END IF
        CALL s_eoy_mv_next_year()
        IF g_success = 'N' THEN EXIT WHILE END IF
      # IF g_aaz.aaz79 = 1 THEN
           CALL s_eoy_aay_close()
      # END IF
{--modi by kitty 99-04-28
        IF g_aaz.aaz79 MATCHES "[23]" THEN
           CALL s_eoy_aax_close()
        END IF
---}
        IF g_success = 'N' THEN EXIT WHILE END IF
        EXIT WHILE
     END WHILE
     CLOSE WINDOW eoy_g_w
END FUNCTION

#No.FUN-AB0068  --Begin
#FUNCTION s_eoy_del_next_year()
#    #將次年度期別為零的所有會計科目的資料刪除
#        MESSAGE "delete next year's aah!"
#{ckp#1} DELETE FROM aah_file 
#            WHERE  aah00 = pp_aaa00 AND aah02 = next_yy AND aah03 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#1)',SQLCA.sqlcode,1) # No.FUN-660123
##           CALL cl_err3("del","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#1)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#              CALL s_errmsg('aah00,aah02,aah03',g_showmsg,'(s_eoy:ckp#1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("del","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#1)",1) 
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#        MESSAGE "delete next year's aed!"
#{ckp#2} DELETE FROM aed_file 
#            WHERE  aed00 = pp_aaa00 AND aed03 = next_yy AND aed04 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#2)',SQLCA.sqlcode,1) # No.FUN-660123
##           CALL cl_err3("del","aed_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#2)",1)  # No.FUN-660123#NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#              CALL s_errmsg('aed00,aed03,aed04',g_showmsg,'(s_eoy:ckp#2)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("del","aed_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#2)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
### No:
#{ckp#3} DELETE FROM aao_file 
#            WHERE  aao00 = pp_aaa00 AND aao03 = next_yy AND aao04 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3)',SQLCA.sqlcode,1)  # No.FUN-660123
##           CALL cl_err3("del","aao_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#3)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#               CALL s_errmsg('aao00,aao03,aao04',g_showmsg,'(s_eoy:ckp#3)',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err3("del","aao_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#3)",1)  
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#        MESSAGE "delete next year's aef!"
#{ckp#4} DELETE FROM aef_file 
#            WHERE  aef00 = pp_aaa00 AND aef03 = next_yy AND aef04 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#4)',SQLCA.sqlcode,1)  # No.FUN-660123
##           CALL cl_err3("del","aef_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#4)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#              CALL s_errmsg('aef00,aef03,aef04',g_showmsg,'(s_eoy:ckp#4)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("del","aef_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#4)",1)  
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     #add by danny 020301 外幣管理(A002)
#     IF g_aaz.aaz83 = 'Y' THEN
#        MESSAGE "delete next year's aed!"
#        DELETE FROM tah_file 
#            WHERE  tah00 = pp_aaa00 AND tah02 = next_yy AND tah03 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("del","tah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#1)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#              CALL s_errmsg('tah00,tah02,tah03',g_showmsg,'(s_eoy:ckp#1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("del","tah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#1)",1)  
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#        MESSAGE "delete next year's ted!"
#        DELETE FROM ted_file 
#            WHERE  ted00 = pp_aaa00 AND ted03 = next_yy AND ted04 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("del","ted_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#2)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#              CALL s_errmsg('ted00,ted03,ted04',g_showmsg,'(s_eoy:ckp#2)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("del","ted_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#2)",1)  
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#        DELETE FROM tao_file 
#            WHERE  tao00 = pp_aaa00 AND tao03 = next_yy AND tao04 = 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("del","tao_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#3)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0'
#              CALL s_errmsg('tao00,tao03,tao04',g_showmsg,'(s_eoy:ckp#3)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("del","tao_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#3)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     END IF
#END FUNCTION

FUNCTION s_eoy_del_next_year_1()                                                
                                                                                
   CALL s_eoy_del_next_year_aah()                                               
   IF g_success = 'N' THEN RETURN END IF                                        
   CALL s_eoy_del_next_year_aed()                                               
   IF g_success = 'N' THEN RETURN END IF                                        
#  CALL s_eoy_del_next_year_aedd()                                              
#  IF g_success = 'N' THEN RETURN END IF                                        
   CALL s_eoy_del_next_year_aao()                                               
   IF g_success = 'N' THEN RETURN END IF                                        
   CALL s_eoy_del_next_year_aef()                                               
   IF g_success = 'N' THEN RETURN END IF                                        
   CALL s_eoy_del_next_year_aeh()                                               
   IF g_success = 'N' THEN RETURN END IF                                        
   IF g_aaz.aaz83 = 'Y' THEN                                                    
      CALL s_eoy_del_next_year_tah()                                            
      IF g_success = 'N' THEN RETURN END IF     
      CALL s_eoy_del_next_year_ted()                                            
      IF g_success = 'N' THEN RETURN END IF                                     
      CALL s_eoy_del_next_year_tao()                                            
      IF g_success = 'N' THEN RETURN END IF                                     
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION s_eoy_del_next_year_aah()
   DEFINE l_aah00       LIKE aah_file.aah00
   DEFINE l_aah01       LIKE aah_file.aah01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's aah!"
      DELETE FROM aah_file 
       WHERE aah00 = pp_aaa00 AND aah02 = next_yy AND aah03 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('aah00,aah02',g_showmsg,'delete aah',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_aah_cs CURSOR FOR
       SELECT UNIQUE aah00,aah01 FROM aah_file
        WHERE aah00 = pp_aaa00 AND aah02 = last_yy
      FOREACH s_eoy_del_aah_cs INTO l_aah00,l_aah01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('aah00,aah02',g_showmsg,'foreach s_eoy_del_aah_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_aah_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_aah00,l_aah01) RETURNING l_aag00,l_aag01
         DELETE FROM aah_file 
          WHERE aah00 = l_aag00 AND aah01 = l_aag01
            AND aah02 = next_yy AND aah03 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'del aah_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

FUNCTION s_eoy_del_next_year_aed()
   DEFINE l_aed00       LIKE aed_file.aed00
   DEFINE l_aed01       LIKE aed_file.aed01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's aed!"
      DELETE FROM aed_file 
       WHERE aed00 = pp_aaa00 AND aed03 = next_yy AND aed04 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('aed00,aed03',g_showmsg,'delete aed',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_aed_cs CURSOR FOR
       SELECT UNIQUE aed00,aed01 FROM aed_file
        WHERE aed00 = pp_aaa00 AND aed03 = last_yy 
      FOREACH s_eoy_del_aed_cs INTO l_aed00,l_aed01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('aed00,aed03',g_showmsg,'foreach s_eoy_del_aed_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_aed_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_aed00,l_aed01) RETURNING l_aag00,l_aag01
         DELETE FROM aed_file 
          WHERE aed00 = l_aag00 AND aed01 = l_aag01
            AND aed03 = next_yy AND aed04 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('aed00,aed01,aed03,aed04',g_showmsg,'del aed_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

#FUNCTION s_eoy_del_next_year_aedd()
#   DEFINE l_aedd00      LIKE aedd_file.aedd00
#   DEFINE l_aedd01      LIKE aedd_file.aedd01
#   DEFINE l_aag00       LIKE aag_file.aag00
#   DEFINE l_aag01       LIKE aag_file.aag01
#
#   IF g_chg = 'N' THEN
#      MESSAGE "delete next year's aedd!"
#      DELETE FROM aedd_file 
#       WHERE aedd00 = pp_aaa00 AND aedd03 = next_yy AND aedd04 = 0 
#      IF SQLCA.sqlcode THEN
#         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
#         IF g_bgerr THEN
#            CALL s_errmsg('aedd00,aedd03',g_showmsg,'delete aedd',SQLCA.sqlcode,1)
#         ELSE
#            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
#         END IF
#         LET g_success='N' RETURN      
#      END IF  
#   ELSE
#      DECLARE s_eoy_del_aedd_cs CURSOR FOR
#       SELECT UNIQUE aedd00,aedd01 FROM aedd_file
#        WHERE aedd00 = pp_aaa00 AND aedd03 = last_yy 
#      FOREACH s_eoy_del_aedd_cs INTO l_aedd00,l_aedd01
#         IF SQLCA.sqlcode THEN
#            IF g_bgerr THEN
#               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
#               CALL s_errmsg('aedd00,aedd03',g_showmsg,'foreach s_eoy_del_aedd_cs',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err('foreach s_eoy_del_aedd_cs',SQLCA.sqlcode,1)
#            END IF
#            LET g_success='N' RETURN
#         END IF
#         CALL s_tag(last_yy,l_aedd00,l_aedd01) RETURNING l_aag00,l_aag01
#         DELETE FROM aedd_file 
#          WHERE aedd00 = l_aag00 AND aedd01 = l_aag01
#            AND aedd03 = next_yy AND aedd04 = 0
#         IF SQLCA.sqlcode THEN
#            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
#            IF g_bgerr THEN
#               CALL s_errmsg('aedd00,aedd01,aedd03,aedd04',g_showmsg,'del aedd_file',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
#            END IF
#            LET g_success='N' RETURN
#         END IF
#      END FOREACH
#   END IF
#    
#END FUNCTION

FUNCTION s_eoy_del_next_year_aao()
   DEFINE l_aao00       LIKE aao_file.aao00
   DEFINE l_aao01       LIKE aao_file.aao01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's aao!"
      DELETE FROM aao_file 
       WHERE aao00 = pp_aaa00 AND aao03 = next_yy AND aao04 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('aao00,aao03',g_showmsg,'delete aao',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_aao_cs CURSOR FOR
       SELECT UNIQUE aao00,aao01 FROM aao_file
        WHERE aao00 = pp_aaa00 AND aao03 = last_yy 
      FOREACH s_eoy_del_aao_cs INTO l_aao00,l_aao01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('aao00,aao03',g_showmsg,'foreach s_eoy_del_aao_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_aao_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_aao00,l_aao01) RETURNING l_aag00,l_aag01
         DELETE FROM aao_file 
          WHERE aao00 = l_aag00 AND aao01 = l_aag01
            AND aao03 = next_yy AND aao04 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('aao00,aao01,aao03,aao04',g_showmsg,'del aao_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

FUNCTION s_eoy_del_next_year_aef()
   DEFINE l_aef00       LIKE aef_file.aef00
   DEFINE l_aef01       LIKE aef_file.aef01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's aef!"
      DELETE FROM aef_file 
       WHERE aef00 = pp_aaa00 AND aef03 = next_yy AND aef04 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('aef00,aef03',g_showmsg,'delete aef',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_aef_cs CURSOR FOR
       SELECT UNIQUE aef00,aef01 FROM aef_file
        WHERE aef00 = pp_aaa00 AND aef03 = last_yy 
      FOREACH s_eoy_del_aef_cs INTO l_aef00,l_aef01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('aef00,aef03',g_showmsg,'foreach s_eoy_del_aef_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_aef_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_aef00,l_aef01) RETURNING l_aag00,l_aag01
         DELETE FROM aef_file 
          WHERE aef00 = l_aag00 AND aef01 = l_aag01
            AND aef03 = next_yy AND aef04 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('aef00,aef01,aef03,aef04',g_showmsg,'del aef_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

FUNCTION s_eoy_del_next_year_aeh()
   DEFINE l_aeh00       LIKE aeh_file.aeh00
   DEFINE l_aeh01       LIKE aeh_file.aeh01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's aeh!"
      DELETE FROM aeh_file 
       WHERE aeh00 = pp_aaa00 AND aeh09 = next_yy AND aeh10 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('aeh00,aeh09',g_showmsg,'delete aeh',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_aeh_cs CURSOR FOR
       SELECT UNIQUE aeh00,aeh01 FROM aeh_file
        WHERE aeh00 = pp_aaa00 AND aeh09 = last_yy 
      FOREACH s_eoy_del_aeh_cs INTO l_aeh00,l_aeh01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('aeh00,aeh09',g_showmsg,'foreach s_eoy_del_aeh_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_aeh_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_aeh00,l_aeh01) RETURNING l_aag00,l_aag01
         DELETE FROM aeh_file 
          WHERE aeh00 = l_aag00 AND aeh01 = l_aag01
            AND aeh09 = next_yy AND aeh10 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('aeh00,aeh01,aeh09,aeh10',g_showmsg,'del aeh_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

FUNCTION s_eoy_del_next_year_tah()
   DEFINE l_tah00       LIKE tah_file.tah00
   DEFINE l_tah01       LIKE tah_file.tah01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's tah!"
      DELETE FROM tah_file 
       WHERE tah00 = pp_aaa00 AND tah02 = next_yy AND tah03 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('tah00,tah02',g_showmsg,'delete tah',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_tah_cs CURSOR FOR
       SELECT UNIQUE tah00,tah01 FROM tah_file
        WHERE tah00 = pp_aaa00 AND tah02 = last_yy 
      FOREACH s_eoy_del_tah_cs INTO l_tah00,l_tah01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('tah00,tah02',g_showmsg,'foreach s_eoy_del_tah_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_tah_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_tah00,l_tah01) RETURNING l_aag00,l_aag01
         DELETE FROM tah_file 
          WHERE tah00 = l_aag00 AND tah01 = l_aag01
            AND tah02 = next_yy AND tah03 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('tah00,tah01,tah02,tah03',g_showmsg,'del tah_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

FUNCTION s_eoy_del_next_year_ted()
   DEFINE l_ted00       LIKE ted_file.ted00
   DEFINE l_ted01       LIKE ted_file.ted01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's ted!"
      DELETE FROM ted_file 
       WHERE ted00 = pp_aaa00 AND ted03 = next_yy AND ted04 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('ted00,ted03',g_showmsg,'delete ted',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_ted_cs CURSOR FOR
       SELECT UNIQUE ted00,ted01 FROM ted_file
        WHERE ted00 = pp_aaa00 AND ted03 = last_yy 
      FOREACH s_eoy_del_ted_cs INTO l_ted00,l_ted01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('ted00,ted03',g_showmsg,'foreach s_eoy_del_ted_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_ted_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_ted00,l_ted01) RETURNING l_aag00,l_aag01
         DELETE FROM ted_file 
          WHERE ted00 = l_aag00 AND ted01 = l_aag01
            AND ted03 = next_yy AND ted04 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('ted00,ted01,ted03,ted04',g_showmsg,'del ted_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION

FUNCTION s_eoy_del_next_year_tao()
   DEFINE l_tao00       LIKE tao_file.tao00
   DEFINE l_tao01       LIKE tao_file.tao01
   DEFINE l_aag00       LIKE aag_file.aag00
   DEFINE l_aag01       LIKE aag_file.aag01

   IF g_chg = 'N' THEN
      MESSAGE "delete next year's tao!"
      DELETE FROM tao_file 
       WHERE tao00 = pp_aaa00 AND tao03 = next_yy AND tao04 = 0 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
         IF g_bgerr THEN
            CALL s_errmsg('tao00,tao03',g_showmsg,'delete tao',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN      
      END IF  
   ELSE
      DECLARE s_eoy_del_tao_cs CURSOR FOR
       SELECT UNIQUE tao00,tao01 FROM tao_file
        WHERE tao00 = pp_aaa00 AND tao03 = last_yy 
      FOREACH s_eoy_del_tao_cs INTO l_tao00,l_tao01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa00 CLIPPED,"/",next_yy CLIPPED
               CALL s_errmsg('tao00,tao03',g_showmsg,'foreach s_eoy_del_tao_cs',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('foreach s_eoy_del_tao_cs',SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
         CALL s_tag(last_yy,l_tao00,l_tao01) RETURNING l_aag00,l_aag01
         DELETE FROM tao_file 
          WHERE tao00 = l_aag00 AND tao01 = l_aag01
            AND tao03 = next_yy AND tao04 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_aag00 CLIPPED,"/",l_aag01 CLIPPED,'/',next_yy USING "<<<<",'/0'
            IF g_bgerr THEN
               CALL s_errmsg('tao00,tao01,tao03,tao04',g_showmsg,'del tao_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
            END IF
            LET g_success='N' RETURN
         END IF
      END FOREACH
   END IF
    
END FUNCTION
#No.FUN-AB0068  --End  

#No.FUN-AB0068  --Begin                                                         
#按aooi120的设置,做新旧科目转换                                                 
FUNCTION s_eoy_chg_account(p_table,p_key,p_seq)                                 
   DEFINE p_table          LIKE gat_file.gat01    #临时表xx_aah等               
   DEFINE p_key            LIKE gaq_file.gaq01    #临时表xx_aah中的帐套及科目字段名字
   DEFINE p_seq            LIKE type_file.num5    #1.帐套 2.科目编号            
   DEFINE l_sql            STRING                                               
   DEFINE l_key            LIKE gaq_file.gaq01                                  
                                                                                
   IF p_seq = '1' THEN LET l_key = 'tag04' ELSE LET l_key = 'tag05' END IF      
                                                                                
   LET l_sql = "UPDATE ",p_table CLIPPED," SET ",p_key CLIPPED," = ( ",         
               "         SELECT ",l_key CLIPPED," FROM tag_file ",              
               "          WHERE tag01 = ",last_yy,                              
               "            AND tag02 = a1 ",
               "            AND tagacti = 'Y'",        #FUN-BC0087                                   
               "            AND tag03 = a2)"                                    
   PREPARE pre_tag FROM l_sql                                                   
   EXECUTE pre_tag                                                              
   IF SQLCA.sqlcode THEN                                                        
      IF g_bgerr THEN                                                           
        LET g_showmsg=p_table CLIPPED,"/",p_key CLIPPED                         
        CALL s_errmsg('gat01,gaq01',g_showmsg,'change key',SQLCA.sqlcode,1)     
      ELSE            
        CALL cl_err('change key',SQLCA.sqlcode,1)                               
      END IF                                                                    
      LET g_success='N' RETURN                                                  
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION s_eoy_chg_back_account(p_table,p_key1,p_key2)                          
   DEFINE p_table          LIKE gat_file.gat01    #临时表xx_aah等               
   DEFINE p_key1           LIKE gaq_file.gaq01    #临时表xx_aah中的帐套         
   DEFINE p_key2           LIKE gaq_file.gaq01    #临时表xx_aah中的科目字段名字 
   DEFINE l_sql            STRING                                               
                                                                                
   LET l_sql = "UPDATE ",p_table CLIPPED," SET ",p_key1 CLIPPED," = a1, ",      
                                                 p_key2 CLIPPED," = a2  ",      
               " WHERE ",p_key1 CLIPPED," IS NULL OR ",p_key2 CLIPPED," IS NULL"
   PREPARE pre_account_p1 FROM l_sql                                            
   EXECUTE pre_account_p1                                             
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
        LET g_showmsg=p_table CLIPPED,"/",p_key1 CLIPPED,"/",p_key2 CLIPPED
        CALL s_errmsg('gat01,gaq01,gaq01',g_showmsg,'change key back',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('change key back',SQLCA.sqlcode,1)
      END IF
      LET g_success='N' RETURN
   END IF

END FUNCTION

FUNCTION s_eoy_mv_next_year()   # 请注意--->虚帐户不需作结转                    
                                                                                
   CALL s_eoy_mv_next_year_aah()                                                
   IF g_success = 'N' THEN RETURN END IF                                        
                                                                                
   CALL s_eoy_mv_next_year_aed()                                                
   IF g_success = 'N' THEN RETURN END IF                                        
                                                                                
   CALL s_eoy_mv_next_year_aao()                                                
   IF g_success = 'N' THEN RETURN END IF                                        
                                                                                
   CALL s_eoy_mv_next_year_aef()                                                
   IF g_success = 'N' THEN RETURN END IF                                        
                                                                                
   CALL s_eoy_mv_next_year_aeh()                                                
   IF g_success = 'N' THEN RETURN END IF                                        
                                                                                
#  CALL s_eoy_mv_next_year_aedd()                                              
#  IF g_success = 'N' THEN RETURN END IF                                          
                                                                                
   IF g_aaz.aaz83 = 'Y' THEN                                                    
      CALL s_eoy_mv_next_year_tah()                                             
      IF g_success = 'N' THEN RETURN END IF
                                                                                
      CALL s_eoy_mv_next_year_ted()                                             
      IF g_success = 'N' THEN RETURN END IF                                     
                                                                                
      CALL s_eoy_mv_next_year_tao()                                             
      IF g_success = 'N' THEN RETURN END IF                                     
                                                                                
   END IF                                                                       
                                                                                
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION s_eoy_mv_next_year_aah()
 DEFINE l_sql LIKE type_file.chr1000 
#----------------------------------------------------------------------
     MESSAGE "move to next year's aah!"
     #1.將所有的aah_file丟進臨時表

     DROP TABLE xx_aah
     CREATE TEMP TABLE xx_aah(
      a1       LIKE aah_file.aah00,
      a2       LIKE aah_file.aah01,
      aah00    LIKE aah_file.aah00,
      aah01    LIKE aah_file.aah01,
      aah02    LIKE aah_file.aah02,
      aah03    LIKE aah_file.aah03,
      aah04    LIKE aah_file.aah04,
      aah05    LIKE aah_file.aah05,
      aah06    LIKE aah_file.aah06,
      aah07    LIKE aah_file.aah07,
      aahlegal LIKE aah_file.aahlegal);
    
     LET l_sql = " INSERT INTO xx_aah SELECT aah00,aah01,aah_file.*",
                 "   FROM aah_file,aag_file ",
                 "  WHERE aah00 = '",pp_aaa00,"' AND aah02 = ",last_yy,
                 "    AND aah01 = aag01",
                 "    AND aah00 = aag00"   
                #"    AND aag03 = '2' AND aag04 = '1'"	   #MOD-D10019    #不論是結轉或是帳戶科目一律結轉至次年
                ,"    AND aag04 = '1'"                     #MOD-D10019
     PREPARE pre_xx_aah_1 FROM l_sql
     EXECUTE pre_xx_aah_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('aah00,aah02',g_showmsg,'insert aah temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert aah temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN
        CALL s_eoy_chg_account('xx_aah','aah00','1')
        CALL s_eoy_chg_account('xx_aah','aah01','2')
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_aah','aah00','aah01')
     END IF

     #3.科目做匯總
     DROP TABLE x_aah
     LET l_sql = " SELECT aah00,aah01,",next_yy," h2,0 h3,SUM(aah04-aah05) h4,SUM(aah05-aah04) h5,0 h6,0 h7,aahlegal",
                 "   FROM xx_aah ",
                 "  GROUP BY aah00,aah01,aahlegal ",
                 "  INTO TEMP x_aah "
     PREPARE pre_x_aah_1 FROM l_sql
     EXECUTE pre_x_aah_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aah00,aah02',g_showmsg,'insert x_aah',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_aah',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aah SET h4 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_aah_2 FROM l_sql
     EXECUTE pre_x_aah_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aah00,aah02',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aah SET h5 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_aah_3 FROM l_sql
     EXECUTE pre_x_aah_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aah00,aah02',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_aah WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_aah_4 FROM l_sql
#    EXECUTE pre_x_aah_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aah00,aah02',g_showmsg,'delete x_aah',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_aah ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #4.結果插入aah_file
     INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
      SELECT aah00,aah01,h2,h3,h4,h5,h6,h7,aahlegal FROM x_aah
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert aah_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","insert aah_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF
END FUNCTION

FUNCTION s_eoy_mv_next_year_aed()
 DEFINE l_sql         LIKE type_file.chr1000 
 DEFINE l_aed00       LIKE aed_file.aed00
 DEFINE l_aed01       LIKE aed_file.aed01
 DEFINE l_aed011      LIKE aed_file.aed011
 DEFINE l_aed04       LIKE aed_file.aed04     #MOD-C20150
 DEFINE l_aed012      LIKE aed_file.aed012
#----------------------------------------------------------------------
     MESSAGE "move to next year's aed!"
     #1.將所有的aed_file丟進臨時表

     DROP TABLE xx_aed
     CREATE TEMP TABLE xx_aed(
      a1          LIKE aed_file.aed00,
      a2          LIKE aed_file.aed01,
      aed00       LIKE aed_file.aed00,
      aed01       LIKE aed_file.aed01,
      aed011      LIKE aed_file.aed011,
      aed02       LIKE aed_file.aed02,
      aed03       LIKE aed_file.aed03,
      aed04       LIKE aed_file.aed04,
      aed05       LIKE aed_file.aed05,
      aed06       LIKE aed_file.aed06,
      aed07       LIKE aed_file.aed07,
      aed08       LIKE aed_file.aed08,
      aed012      LIKE aed_file.aed012,
      aedlegal    LIKE aed_file.aedlegal);    
     LET l_sql = " INSERT INTO xx_aed SELECT aed00,aed01,aed_file.*",
                 "   FROM aed_file,aag_file ",
                 "  WHERE aed00 = '",pp_aaa00,"' AND aed03 = ",last_yy,
                 "    AND aed01 = aag01",
                 "    AND aed00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_aed_1 FROM l_sql
     EXECUTE pre_xx_aed_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('aed00,aed03',g_showmsg,'insert aed temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert aed temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN
        CALL s_eoy_chg_account('xx_aed','aed00','1')
        CALL s_eoy_chg_account('xx_aed','aed01','2')
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_aed','aed00','aed01')
     END IF

     #No.TQC-B10022  --Begin
     #3.aed012不是key值,但是在使用過程中有人會改設置,會導致 
     #  相同帳套/科目/核算項順序的aed012不同,此段處理是將aed012置為最后一月份的設置
     DECLARE s_eoy_aed012_cs1 CURSOR FOR
     #-MOD-C20150-mark-
     #SELECT UNIQUE aed00,aed01,aed011,aed012 FROM xx_aed a
     # WHERE aed04 = (SELECT MAX(aed04) FROM xx_aed b
     #                 WHERE b.aed00 = a.aed00
     #                   AND b.aed01 = a.aed01
     #                   AND b.aed011= a.aed011)
     #-MOD-C20150-add-
        SELECT aed00,aed01,aed011,MAX(aed04)
          FROM xx_aed
         GROUP BY aed00,aed01,aed011
     #-MOD-C20150-end-
    #FOREACH s_eoy_aed012_cs1 INTO l_aed00,l_aed01,l_aed011,l_aed012   #MOD-C20150 mark
     FOREACH s_eoy_aed012_cs1 INTO l_aed00,l_aed01,l_aed011,l_aed04    #MOD-C20150
       #-MOD-C20150-add-
        LET l_sql = " SELECT aed012 FROM xx_aed ",
                    "  WHERE aed00 = '",l_aed00,"'",
                    "    AND aed01 = '",l_aed01,"'",
                    "    AND aed011 = '",l_aed011,"'",
                    "    AND aed04 = ",l_aed04
        PREPARE s_eoy_aed012_p2 FROM l_sql
        DECLARE s_eoy_aed012_cs2 SCROLL CURSOR FOR s_eoy_aed012_p2
        OPEN s_eoy_aed012_cs2
        FETCH FIRST s_eoy_aed012_cs2 INTO l_aed012
        CLOSE s_eoy_aed012_cs2
       #-MOD-C20150-end-
        UPDATE xx_aed SET aed012 = l_aed012
         WHERE aed00 = l_aed00
           AND aed01 = l_aed01
           AND aed011= l_aed011
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
             LET g_showmsg=l_aed00,'/',l_aed01,'/',l_aed011
             CALL s_errmsg('aed00,aed01,aed011',g_showmsg,'update aed012',SQLCA.sqlcode,1)
           ELSE
             CALL cl_err('update aed012',SQLCA.sqlcode,1)
           END IF
           LET g_success='N' RETURN
        END IF
     END FOREACH
     #No.TQC-B10022  --End  

     #4.科目做匯總
     DROP TABLE x_aed
     LET l_sql = " SELECT aed00,aed01,aed011,aed02,",next_yy," h2,0 h3,SUM(aed05-aed06) h4,SUM(aed06-aed05) h5,0 h6,0 h7,aed012,aedlegal",
                 "   FROM xx_aed ",
                 "  GROUP BY aed00,aed01,aed011,aed02,aed012,aedlegal ",
                 "  INTO TEMP x_aed "
     PREPARE pre_x_aed_1 FROM l_sql
     EXECUTE pre_x_aed_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aed00,aed03',g_showmsg,'insert x_aed',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_aed',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aed SET h4 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_aed_2 FROM l_sql
     EXECUTE pre_x_aed_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aed00,aed03',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aed SET h5 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_aed_3 FROM l_sql
     EXECUTE pre_x_aed_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aed00,aed03',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_aed WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_aed_4 FROM l_sql
#    EXECUTE pre_x_aed_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aed00,aed03',g_showmsg,'delete x_aed',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_aed ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #5.結果插入aed_file
     INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,aed04,aed05,aed06,aed07,aed08,aed012,aedlegal)
      SELECT aed00,aed01,aed011,aed02,h2,h3,h4,h5,h6,h7,aed012,aedlegal FROM x_aed
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert aed_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","insert aed_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF
END FUNCTION

FUNCTION s_eoy_mv_next_year_aao()
 DEFINE l_sql LIKE type_file.chr1000 
#----------------------------------------------------------------------
     MESSAGE "move to next year's aao!"
     #1.將所有的aao_file丟進臨時表

     DROP TABLE xx_aao
     CREATE TEMP TABLE xx_aao(
      a1         LIKE aao_file.aao00,
      a2         LIKE aao_file.aao01,
      aao00      LIKE aao_file.aao00,
      aao01      LIKE aao_file.aao01,
      aao02      LIKE aao_file.aao02,
      aao03      LIKE aao_file.aao03,
      aao04      LIKE aao_file.aao04,
      aao05      LIKE aao_file.aao05,
      aao06      LIKE aao_file.aao06,
      aao07      LIKE aao_file.aao07,
      aao08      LIKE aao_file.aao08,
      aaolegal   LIKE aao_file.aaolegal);
    
     LET l_sql = " INSERT INTO xx_aao SELECT aao00,aao01,aao_file.*",
                 "   FROM aao_file,aag_file ",
                 "  WHERE aao00 = '",pp_aaa00,"' AND aao03 = ",last_yy,
                 "    AND aao01 = aag01",
                 "    AND aao00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_aao_1 FROM l_sql
     EXECUTE pre_xx_aao_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('aao00,aao03',g_showmsg,'insert aao temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert aao temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN
        CALL s_eoy_chg_account('xx_aao','aao00','1')
        CALL s_eoy_chg_account('xx_aao','aao01','2')
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_aao','aao00','aao01')
     END IF

     #3.科目做匯總
     DROP TABLE x_aao
     LET l_sql = " SELECT aao00,aao01,aao02,",next_yy," h2,0 h3,SUM(aao05-aao06) h4,SUM(aao06-aao05) h5,0 h6,0 h7,aaolegal",
                 "   FROM xx_aao ",
                 "  GROUP BY aao00,aao01,aao02,aaolegal ",
                 "  INTO TEMP x_aao "
     PREPARE pre_x_aao_1 FROM l_sql
     EXECUTE pre_x_aao_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aao00,aao03',g_showmsg,'insert x_aao',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_aao',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aao SET h4 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_aao_2 FROM l_sql
     EXECUTE pre_x_aao_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aao00,aao03',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aao SET h5 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_aao_3 FROM l_sql
     EXECUTE pre_x_aao_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aao00,aao03',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_aao WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_aao_4 FROM l_sql
#    EXECUTE pre_x_aao_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aao00,aao03',g_showmsg,'delete x_aao',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_aao ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #4.結果插入aao_file
     INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,aao06,aao07,aao08,aaolegal)
      SELECT aao00,aao01,aao02,h2,h3,h4,h5,h6,h7,aaolegal FROM x_aao
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert aao_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","insert aao_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF
END FUNCTION

FUNCTION s_eoy_mv_next_year_aef()
 DEFINE l_sql LIKE type_file.chr1000 
#----------------------------------------------------------------------
     MESSAGE "move to next year's aef!"
     #1.將所有的aef_file丟進臨時表

     DROP TABLE xx_aef
     CREATE TEMP TABLE xx_aef(
      a1         LIKE aef_file.aef00,
      a2         LIKE aef_file.aef01,
      aef00      LIKE aef_file.aef00,
      aef01      LIKE aef_file.aef01,
      aef02      LIKE aef_file.aef02,
      aef03      LIKE aef_file.aef03,
      aef04      LIKE aef_file.aef04,
      aef05      LIKE aef_file.aef05,
      aef06      LIKE aef_file.aef06,
      aef07      LIKE aef_file.aef07,
      aef08      LIKE aef_file.aef08,
      aeflegal   LIKE aef_file.aeflegal);
    
     LET l_sql = " INSERT INTO xx_aef SELECT aef00,aef01,aef_file.*",
                 "   FROM aef_file,aag_file ",
                 "  WHERE aef00 = '",pp_aaa00,"' AND aef03 = ",last_yy,
                 "    AND aef01 = aag01",
                 "    AND aef00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_aef_1 FROM l_sql
     EXECUTE pre_xx_aef_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('aef00,aef03',g_showmsg,'insert aef temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert aef temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN
        CALL s_eoy_chg_account('xx_aef','aef00','1')
        CALL s_eoy_chg_account('xx_aef','aef01','2')
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_aef','aef00','aef01')
     END IF

     #3.科目做匯總
     DROP TABLE x_aef
     LET l_sql = " SELECT aef00,aef01,aef02,",next_yy," h2,0 h3,SUM(aef05-aef06) h4,SUM(aef06-aef05) h5,0 h6,0 h7,aeflegal",
                 "   FROM xx_aef ",
                 "  GROUP BY aef00,aef01,aef02,aeflegal ",
                 "  INTO TEMP x_aef "
     PREPARE pre_x_aef_1 FROM l_sql
     EXECUTE pre_x_aef_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aef00,aef03',g_showmsg,'insert x_aef',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_aef',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aef SET h4 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_aef_2 FROM l_sql
     EXECUTE pre_x_aef_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aef00,aef03',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aef SET h5 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_aef_3 FROM l_sql
     EXECUTE pre_x_aef_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aef00,aef03',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_aef WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_aef_4 FROM l_sql
#    EXECUTE pre_x_aef_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aef00,aef03',g_showmsg,'delete x_aef',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_aef ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #4.結果插入aef_file
     INSERT INTO aef_file(aef00,aef01,aef02,aef03,aef04,aef05,aef06,aef07,aef08,aeflegal)
      SELECT aef00,aef01,aef02,h2,h3,h4,h5,h6,h7,aeflegal FROM x_aef
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert aef_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","insert aef_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF
END FUNCTION

FUNCTION s_eoy_mv_next_year_aeh()
 DEFINE l_sql LIKE type_file.chr1000 
#----------------------------------------------------------------------
     MESSAGE "move to next year's aeh!"
     #1.將所有的aeh_file丟進臨時表

     DROP TABLE xx_aeh
     CREATE TEMP TABLE xx_aeh(
      a1         LIKE aeh_file.aeh00,
      a2         LIKE aeh_file.aeh01,
      aeh00      LIKE aeh_file.aeh00,
      aeh01      LIKE aeh_file.aeh01,
      aeh02      LIKE aeh_file.aeh02,
      aeh03      LIKE aeh_file.aeh03,
      aeh04      LIKE aeh_file.aeh04,
      aeh05      LIKE aeh_file.aeh05,
      aeh06      LIKE aeh_file.aeh06,
      aeh07      LIKE aeh_file.aeh07,
      aeh08      LIKE aeh_file.aeh08,
      aeh09      LIKE aeh_file.aeh09,
      aeh10      LIKE aeh_file.aeh10,
      aeh11      LIKE aeh_file.aeh11,
      aeh12      LIKE aeh_file.aeh12,
      aeh13      LIKE aeh_file.aeh13,
      aeh14      LIKE aeh_file.aeh14,
      aeh15      LIKE aeh_file.aeh15,
      aeh16      LIKE aeh_file.aeh16,
      aeh17      LIKE aeh_file.aeh17,
      aeh31      LIKE aeh_file.aeh31,
      aeh32      LIKE aeh_file.aeh32,
      aeh33      LIKE aeh_file.aeh33,
      aeh34      LIKE aeh_file.aeh34,
      aeh35      LIKE aeh_file.aeh35,
      aeh36      LIKE aeh_file.aeh36,
      aeh37      LIKE aeh_file.aeh37,
      aehlegal   LIKE aeh_file.aehlegal);
    
     LET l_sql = " INSERT INTO xx_aeh SELECT aeh00,aeh01,aeh_file.*",
                 "   FROM aeh_file,aag_file ",
                 "  WHERE aeh00 = '",pp_aaa00,"' AND aeh09 = ",last_yy,
                 "    AND aeh01 = aag01",
                 "    AND aeh00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_aeh_1 FROM l_sql
     EXECUTE pre_xx_aeh_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('aeh00,aeh09',g_showmsg,'insert aeh temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert aeh temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN
        CALL s_eoy_chg_account('xx_aeh','aeh00','1')
        CALL s_eoy_chg_account('xx_aeh','aeh01','2')
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_aeh','aeh00','aeh01')
     END IF

     #3.科目做匯總
     DROP TABLE x_aeh
     LET l_sql = " SELECT aeh00,aeh01,aeh02,aeh03,aeh04,aeh05,aeh06,aeh07,aeh08,",
                          next_yy," h2,0 h3,SUM(aeh11-aeh12) h4,SUM(aeh12-aeh11) h5,0 h6,0 h7,",
                 "        SUM(aeh15-aeh16) h9,SUM(aeh16-aeh15) h10,aeh17,",
                 "        aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37,aehlegal ",         
                 "   FROM xx_aeh ",
                 "  GROUP BY aeh00,aeh01,aeh02,aeh03,aeh04,aeh05,aeh06,aeh07,aeh08,",
                 "           aeh17,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37,aehlegal ",
                 "  INTO TEMP x_aeh "
     PREPARE pre_x_aeh_1 FROM l_sql
     EXECUTE pre_x_aeh_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aeh00,aeh09',g_showmsg,'insert x_aeh',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_aeh',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aeh SET h4 = 0,h9 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_aeh_2 FROM l_sql
     EXECUTE pre_x_aeh_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aeh00,aeh09',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_aeh SET h5 = 0,h10 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_aeh_3 FROM l_sql
     EXECUTE pre_x_aeh_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('aeh00,aeh09',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_aeh WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_aeh_4 FROM l_sql
#    EXECUTE pre_x_aeh_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aeh00,aeh09',g_showmsg,'delete x_aeh',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_aeh ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #4.結果插入aeh_file
     INSERT INTO aeh_file(aeh00,aeh01,aeh02,aeh03,aeh04,aeh05,aeh06,aeh07,aeh08,
                          aeh09,aeh10,aeh11,aeh12,aeh13,aeh14,aeh15,aeh16,aeh17,
                          aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37,aehlegal)
      SELECT aeh00,aeh01,aeh02,aeh03,aeh04,aeh05,aeh06,aeh07,aeh08,
             h2,h3,h4,h5,h6,h7,h9,h10,aeh17,
             aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37,aehlegal
        FROM x_aeh
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert aeh_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","aeh_file","","",SQLCA.sqlcode,"","insert aeh_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF
END FUNCTION

#FUNCTION s_eoy_mv_next_year_aedd()
#DEFINE l_sql LIKE type_file.chr1000 
##----------------------------------------------------------------------
#    MESSAGE "move to next year's aedd!"
#    #1.將所有的aedd_file丟進臨時表

#    DROP TABLE xx_aedd
#    CREATE TEMP TABLE xx_aedd(
#     a1           LIKE aedd_file.aedd00,
#     a2           LIKE aedd_file.aedd01,
#     aedd00       LIKE aedd_file.aedd00,
#     aedd01       LIKE aedd_file.aedd01,
#     aedd015      LIKE aedd_file.aedd015,
#     aedd016      LIKE aedd_file.aedd016,
#     aedd017      LIKE aedd_file.aedd017,
#     aedd018      LIKE aedd_file.aedd018,
#     aedd03       LIKE aedd_file.aedd03,
#     aedd04       LIKE aedd_file.aedd04,
#     aedd05       LIKE aedd_file.aedd05,
#     aedd06       LIKE aedd_file.aedd06,
#     aedd07       LIKE aedd_file.aedd07,
#     aedd08       LIKE aedd_file.aedd08,       
#     aeddlegal    LIKE aedd_file.aeddlegal);  
#   
#    LET l_sql = " INSERT INTO xx_aedd SELECT aedd00,aedd01,aedd_file.*",
#                "   FROM aedd_file,aag_file ",
#                "  WHERE aedd00 = '",pp_aaa00,"' AND aedd03 = ",last_yy,
#                "    AND aedd01 = aag01",
#                "    AND aedd00 = aag00",  
#                "    AND aag03 = '2' AND aag04 = '1'"
#    PREPARE pre_xx_aedd_1 FROM l_sql
#    EXECUTE pre_xx_aedd_1
#    IF SQLCA.sqlcode THEN
#       IF g_bgerr THEN
#         LET g_showmsg=pp_aaa00,"/",last_yy 
#         CALL s_errmsg('aedd00,aedd03',g_showmsg,'insert aedd temp',SQLCA.sqlcode,1)
#       ELSE
#         CALL cl_err('insert aedd temp',SQLCA.sqlcode,1)
#       END IF
#       LET g_success='N' RETURN
#    END IF

#    #2.將舊科目變成新科目
#    IF g_chg = 'Y' THEN
#       CALL s_eoy_chg_account('xx_aedd','aedd00','1')
#       CALL s_eoy_chg_account('xx_aedd','aedd01','2')
#       #若科目有對應不上的,則以原來的科目呈現 
#       CALL s_eoy_chg_back_account('xx_aedd','aedd00','aedd01')
#    END IF

#    #3.科目做匯總
#    DROP TABLE x_aedd
#    LET l_sql = " SELECT aedd00,aedd01,aedd015,aedd016,aedd017,aedd018,",next_yy," h2,0 h3,SUM(aedd05-aedd06) h4,SUM(aedd06-aedd05) h5,0 h6,0 h7,aeddlegal", 
#                "   FROM xx_aedd ",
#                "  GROUP BY aedd00,aedd01,aedd015,aedd016,aedd017,aedd018,aeddlegal ",  
#                "  INTO TEMP x_aedd "
#    PREPARE pre_x_aedd_1 FROM l_sql
#    EXECUTE pre_x_aedd_1
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aedd00,aedd03',g_showmsg,'insert x_aedd',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('insert x_aedd',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

#    LET l_sql = " UPDATE x_aedd SET h4 = 0 WHERE h4 < 0 AND h5 > 0 "
#    PREPARE pre_x_aedd_2 FROM l_sql
#    EXECUTE pre_x_aedd_2
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aedd00,aedd03',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

#    LET l_sql = " UPDATE x_aedd SET h5 = 0 WHERE h4 > 0 AND h5 < 0 "
#    PREPARE pre_x_aedd_3 FROM l_sql
#    EXECUTE pre_x_aedd_3
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('aedd00,aedd03',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

##    LET l_sql = " DELETE x_aedd WHERE h4 = 0 AND h5 = 0 "
##    PREPARE pre_x_aedd_4 FROM l_sql
##    EXECUTE pre_x_aedd_4
##    IF SQLCA.sqlcode THEN
##        IF g_bgerr THEN
##          LET g_showmsg=pp_aaa00,"/",last_yy 
##          CALL s_errmsg('aedd00,aedd03',g_showmsg,'delete x_aedd',SQLCA.sqlcode,1)
##        ELSE
##          CALL cl_err('delete x_aedd ',SQLCA.sqlcode,1)
##        END IF
##        LET g_success='N' RETURN
##    END IF

#    #4.結果插入aedd_file
#    INSERT INTO aedd_file(aedd00,aedd01,aedd015,aedd016,aedd017,aedd018,aedd03,aedd04,aedd05,aedd06,aedd07,aedd08,aeddlegal)  
#     SELECT aedd00,aedd01,aedd015,aedd016,aedd017,aedd018,h2,h3,h4,h5,h6,h7,aeddlegal FROM x_aedd    
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          CALL s_errmsg(' ',' ','insert aedd_file',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err3("ins","aedd_file","","",SQLCA.sqlcode,"","insert aedd_file",1)   
#        END IF
#        LET g_success='N' RETURN
#    END IF
#END FUNCTION

FUNCTION s_eoy_mv_next_year_tah()
 DEFINE l_sql LIKE type_file.chr1000 
#----------------------------------------------------------------------
     MESSAGE "move to next year's tah!"
     #1.將所有tah_file丟進臨時表
     DROP TABLE xx_tah
     CREATE TEMP TABLE xx_tah(
      a1         LIKE tah_file.tah00,
      a2         LIKE tah_file.tah01,
      tah00      LIKE tah_file.tah00,
      tah01      LIKE tah_file.tah01,
      tah02      LIKE tah_file.tah02,
      tah03      LIKE tah_file.tah03,
      tah04      LIKE tah_file.tah04,
      tah05      LIKE tah_file.tah05,
      tah06      LIKE tah_file.tah06,
      tah07      LIKE tah_file.tah07,
      tah08      LIKE tah_file.tah08,
      tah09      LIKE tah_file.tah09,
      tah10      LIKE tah_file.tah10,
      tahlegal   LIKE tah_file.tahlegal);

     LET l_sql = " INSERT INTO xx_tah SELECT tah00,tah01,tah_file.*",
                 "   FROM tah_file,aag_file ",
                 "  WHERE tah00 = '",pp_aaa00,"' AND tah02 = ",last_yy,
                 "    AND tah01 = aag01",
                 "    AND tah00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_tah_1 FROM l_sql
     EXECUTE pre_xx_tah_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('tah00,tah02',g_showmsg,'insert tah temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert tah temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN                                                        
        CALL s_eoy_chg_account('xx_tah','tah00','1')                            
        CALL s_eoy_chg_account('xx_tah','tah01','2')                            
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_tah','tah00','tah01')
     END IF

     #3.科目做匯總
     DROP TABLE x_tah
     LET l_sql = " SELECT tah00,tah01,",next_yy," h2,0 h3,SUM(tah04-tah05) h4,sum(tah05-tah04) h5,0 h6,0 h7,",
                 "        tah08 h8,SUM(tah09-tah10) h9,SUM(tah10-tah09) h10,tahlegal",
                 "   FROM xx_tah ",
                 "  GROUP BY tah00,tah01,tah08,tahlegal ",
                 "  INTO TEMP x_tah "
     PREPARE pre_x_tah_1 FROM l_sql
     EXECUTE pre_x_tah_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('tah00,tah02',g_showmsg,'insert x_tah',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_tah',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

    #LET l_sql = " UPDATE x_tah SET h4 = 0,h9 = 0 WHERE h4 < 0 AND h5 > 0 "        #MOD-C40210 mark
     LET l_sql = " UPDATE x_tah SET h4 = 0,h9 = 0 ",                               #MOD-C40210 add
                 "  WHERE (h4 < 0 AND h5 > 0) OR (h9 < 0 AND h10 > 0) "            #MOD-C40210 add
     PREPARE pre_x_tah_2 FROM l_sql
     EXECUTE pre_x_tah_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('tah00,tah02',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

    #LET l_sql = " UPDATE x_tah SET h5 = 0,h10 = 0 WHERE h4 > 0 AND h5 < 0 "        #MOD-C40210 mark
     LET l_sql = " UPDATE x_tah SET h5 = 0,h10 = 0 ",                               #MOD-C40210 add
                #"  WHERE (h4 < 0 AND h5 > 0) OR (h9 < 0 AND h10 > 0) "             #MOD-C40210 add #MOD-C80266 mark
                 "  WHERE (h4 > 0 AND h5 < 0) OR (h9 > 0 AND h10 < 0) "             #MOD-C80266 add
     PREPARE pre_x_tah_3 FROM l_sql
     EXECUTE pre_x_tah_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('tah00,tah02',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_tah WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_tah_4 FROM l_sql
#    EXECUTE pre_x_tah_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('tah00,tah02',g_showmsg,'delete x_tah',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_tah ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #4.結果插入tah_file
     INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,tah08,tah09,tah10,tahlegal)
      SELECT tah00,tah01,h2,h3,h4,h5,h6,h7,h8,h9,h10,tahlegal FROM x_tah
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert tah_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","insert tah_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF

END FUNCTION

FUNCTION s_eoy_mv_next_year_ted()
 DEFINE l_sql         LIKE type_file.chr1000 
 DEFINE l_ted00       LIKE ted_file.ted00
 DEFINE l_ted01       LIKE ted_file.ted01
 DEFINE l_ted011      LIKE ted_file.ted011
 DEFINE l_ted012      LIKE ted_file.ted012
#----------------------------------------------------------------------
     MESSAGE "move to next year's ted!"
     #1.將所有ted_file丟進臨時表
     DROP TABLE xx_ted
     CREATE TEMP TABLE xx_ted(
      a1          LIKE ted_file.ted00,
      a2          LIKE ted_file.ted01,
      ted00       LIKE ted_file.ted00,
      ted01       LIKE ted_file.ted01,
      ted011      LIKE ted_file.ted011,
      ted02       LIKE ted_file.ted02,
      ted03       LIKE ted_file.ted03,
      ted04       LIKE ted_file.ted04,
      ted05       LIKE ted_file.ted05,
      ted06       LIKE ted_file.ted06,
      ted07       LIKE ted_file.ted07,
      ted08       LIKE ted_file.ted08,
      ted09       LIKE ted_file.ted09,
      ted10       LIKE ted_file.ted10,
      ted11       LIKE ted_file.ted11,
      ted012      LIKE ted_file.ted012,
      tedlegal    LIKE ted_file.tedlegal);

     LET l_sql = " INSERT INTO xx_ted SELECT ted00,ted01,ted_file.*",
                 "   FROM ted_file,aag_file ",
                 "  WHERE ted00 = '",pp_aaa00,"' AND ted03 = ",last_yy,
                 "    AND ted01 = aag01",
                 "    AND ted00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_ted_1 FROM l_sql
     EXECUTE pre_xx_ted_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('ted00,ted03',g_showmsg,'insert ted temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert ted temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN                                                        
        CALL s_eoy_chg_account('xx_ted','ted00','1')                            
        CALL s_eoy_chg_account('xx_ted','ted01','2')                            
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_ted','ted00','ted01')
     END IF


     #3.ted012不是key值,但是在使用過程中有人會改設置,會導致 
     #  相同帳套/科目/核算項順序的ted012不同,此段處理是將ted012置為最后一月份的設置
     DECLARE s_eoy_ted012_cs1 CURSOR FOR
      SELECT UNIQUE ted00,ted01,ted011,ted012 FROM xx_ted a
       WHERE ted04 = (SELECT MAX(ted04) FROM xx_ted b
                       WHERE b.ted00 = a.ted00
                         AND b.ted01 = a.ted01
                         AND b.ted011= a.ted011)
     FOREACH s_eoy_ted012_cs1 INTO l_ted00,l_ted01,l_ted011,l_ted012
        UPDATE xx_ted SET ted012 = l_ted012
         WHERE ted00 = l_ted00
           AND ted01 = l_ted01
           AND ted011= l_ted011
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
             LET g_showmsg=l_ted00,'/',l_ted01,'/',l_ted011
             CALL s_errmsg('ted00,ted01,ted011',g_showmsg,'update ted012',SQLCA.sqlcode,1)
           ELSE
             CALL cl_err('update ted012',SQLCA.sqlcode,1)
           END IF
           LET g_success='N' RETURN
        END IF
     END FOREACH
     #No.TQC-B10022  --End  

     #4.科目做匯總
     DROP TABLE x_ted
     LET l_sql = " SELECT ted00,ted01,ted011,ted02,",next_yy," h2,0 h3,SUM(ted05-ted06) h4,sum(ted06-ted05) h5,0 h6,0 h7,",
                 "        ted09 h8,SUM(ted10-ted11) h9,SUM(ted11-ted10) h10,ted012,tedlegal",
                 "   FROM xx_ted ",
                 "  GROUP BY ted00,ted01,ted011,ted02,ted09,ted012,tedlegal ",
                 "  INTO TEMP x_ted "
     PREPARE pre_x_ted_1 FROM l_sql
     EXECUTE pre_x_ted_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('ted00,ted03',g_showmsg,'insert x_ted',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_ted',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_ted SET h4 = 0,h9 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_ted_2 FROM l_sql
     EXECUTE pre_x_ted_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('ted00,ted03',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_ted SET h5 = 0,h10 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_ted_3 FROM l_sql
     EXECUTE pre_x_ted_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('ted00,ted03',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_ted WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_ted_4 FROM l_sql
#    EXECUTE pre_x_ted_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('ted00,ted03',g_showmsg,'delete x_ted',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_ted ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #5.結果插入ted_file
     INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,ted06,ted07,ted08,ted09,ted10,ted11,ted012,tedlegal)
      SELECT ted00,ted01,ted011,ted02,h2,h3,h4,h5,h6,h7,h8,h9,h10,ted012,tedlegal FROM x_ted
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert ted_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","insert ted_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF

END FUNCTION

FUNCTION s_eoy_mv_next_year_tao()
 DEFINE l_sql LIKE type_file.chr1000 
#----------------------------------------------------------------------
     MESSAGE "move to next year's tao!"
     #1.將所有tao_file丟進臨時表
     DROP TABLE xx_tao
     CREATE TEMP TABLE xx_tao(
      a1         LIKE tao_file.tao00,
      a2         LIKE tao_file.tao01,
      tao00      LIKE tao_file.tao00,
      tao01      LIKE tao_file.tao01,
      tao02      LIKE tao_file.tao02,
      tao03      LIKE tao_file.tao03,
      tao04      LIKE tao_file.tao04,
      tao05      LIKE tao_file.tao05,
      tao06      LIKE tao_file.tao06,
      tao07      LIKE tao_file.tao07,
      tao08      LIKE tao_file.tao08,
      tao09      LIKE tao_file.tao09,
      tao10      LIKE tao_file.tao10,
      tao11      LIKE tao_file.tao11,
      taolegal   LIKE tao_file.taolegal);

     LET l_sql = " INSERT INTO xx_tao SELECT tao00,tao01,tao_file.*",
                 "   FROM tao_file,aag_file ",
                 "  WHERE tao00 = '",pp_aaa00,"' AND tao03 = ",last_yy,
                 "    AND tao01 = aag01",
                 "    AND tao00 = aag00",  
                 "    AND aag03 = '2' AND aag04 = '1'"
     PREPARE pre_xx_tao_1 FROM l_sql
     EXECUTE pre_xx_tao_1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
          LET g_showmsg=pp_aaa00,"/",last_yy 
          CALL s_errmsg('tao00,tao03',g_showmsg,'insert tao temp',SQLCA.sqlcode,1)
        ELSE
          CALL cl_err('insert tao temp',SQLCA.sqlcode,1)
        END IF
        LET g_success='N' RETURN
     END IF

     #2.將舊科目變成新科目
     IF g_chg = 'Y' THEN                                                        
        CALL s_eoy_chg_account('xx_tao','tao00','1')                            
        CALL s_eoy_chg_account('xx_tao','tao01','2')                            
        #若科目有對應不上的,則以原來的科目呈現 
        CALL s_eoy_chg_back_account('xx_tao','tao00','tao01')
     END IF

     #3.科目做匯總
     DROP TABLE x_tao
     LET l_sql = " SELECT tao00,tao01,tao02,",next_yy," h2,0 h3,SUM(tao05-tao06) h4,sum(tao06-tao05) h5,0 h6,0 h7,",
                 "        tao09 h8,SUM(tao10-tao11) h9,SUM(tao11-tao10) h10,taolegal",
                 "   FROM xx_tao ",
                 "  GROUP BY tao00,tao01,tao02,tao09,taolegal ",
                 "  INTO TEMP x_tao "
     PREPARE pre_x_tao_1 FROM l_sql
     EXECUTE pre_x_tao_1
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('tao00,tao03',g_showmsg,'insert x_tao',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('insert x_tao',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_tao SET h4 = 0,h9 = 0 WHERE h4 < 0 AND h5 > 0 "
     PREPARE pre_x_tao_2 FROM l_sql
     EXECUTE pre_x_tao_2
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('tao00,tao03',g_showmsg,'update h4 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h4 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE x_tao SET h5 = 0,h10 = 0 WHERE h4 > 0 AND h5 < 0 "
     PREPARE pre_x_tao_3 FROM l_sql
     EXECUTE pre_x_tao_3
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           LET g_showmsg=pp_aaa00,"/",last_yy 
           CALL s_errmsg('tao00,tao03',g_showmsg,'update h5 = 0',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('update h5 = 0 ',SQLCA.sqlcode,1)
         END IF
         LET g_success='N' RETURN
     END IF

#    LET l_sql = " DELETE x_tao WHERE h4 = 0 AND h5 = 0 "
#    PREPARE pre_x_tao_4 FROM l_sql
#    EXECUTE pre_x_tao_4
#    IF SQLCA.sqlcode THEN
#        IF g_bgerr THEN
#          LET g_showmsg=pp_aaa00,"/",last_yy 
#          CALL s_errmsg('tao00,tao03',g_showmsg,'delete x_tao',SQLCA.sqlcode,1)
#        ELSE
#          CALL cl_err('delete x_tao ',SQLCA.sqlcode,1)
#        END IF
#        LET g_success='N' RETURN
#    END IF

     #4.結果插入tao_file
     INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,tao06,tao07,tao08,tao09,tao10,tao11,taolegal)
      SELECT tao00,tao01,tao02,h2,h3,h4,h5,h6,h7,h8,h9,h10,taolegal FROM x_tao
     IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','insert tao_file',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","insert tao_file",1)   
         END IF
         LET g_success='N' RETURN
     END IF

END FUNCTION

#No.FUN-AB0068  --End  


#No.FUN-AB0068  --Begin
#FUNCTION s_eoy_mv_next_year()   # 請注意--->虛帳戶不需作結轉
# DEFINE l_sql LIKE type_file.chr1000   #No.FUN-680098   VARCHAR(1000)
##----------------------------------------------------------------------
#     MESSAGE "move to next year's aah!"
#     DROP TABLE x1
#     LET l_sql = 
#   " SELECT aah00,aah01,",next_yy," h2,0 h3,sum(aah04-aah05) h4,0 h5,0 h6,0 h7,aahlegal", #FUN-980003 add aahlegal
#   "          FROM aah_file, aag_file",
#   "         WHERE aah00 = '",pp_aaa00,"' AND aah02 = ",last_yy,
#   "           AND aah01 = aag01",
#   "           AND aah00 = aag00",      #No.FUN-740020 
#   "           AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#   "         GROUP BY aah00,aah01,aahlegal ", #FUN-980003 add aahlegal
#   "         INTO TEMP x1 "
#     PREPARE pre_x1 FROM l_sql
#     EXECUTE pre_x1
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy 
#              CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:ckp#3.1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
#           SELECT * FROM x1 where h4 > 0     #No.MOD-520041 改為>0 原來是!=0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.11)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3)",1)  # No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     #No.MOD-520041 add
#     DROP TABLE x12
#     LET l_sql = 
#   " SELECT aah00,aah01,",next_yy," h2,0 h3,0 h4,sum(aah05-aah04) h5,0 h6,0 h7,aahlegal", #FUN-980003 add aahlegal
#   "          FROM aah_file, aag_file",
#   "         WHERE aah00 = '",pp_aaa00,"' AND aah02 = ",last_yy,
#   "           AND aah00 = aag00",    #No.FUN-740020 
#   "           AND aah01 = aag01",
#   "           AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#   "         GROUP BY aah00,aah01,aahlegal ", #FUN-980003 add aahlegal
#   "         INTO TEMP x12 "
#     PREPARE pre_x12 FROM l_sql
#     EXECUTE pre_x12
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#         IF g_bgerr THEN
#            LET g_showmsg=pp_aaa00,"/",last_yy 
#            CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1)
#         ELSE
#            CALL cl_err('(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1)
#         END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#        INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
#          SELECT * FROM x12 where h5 > 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.1-x12)",1)   #No.FUN-660123#NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.1-x12)",1)    
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#   #No.MOD-520041 end
#  #add by danny 020301 外幣管理(A002)
#  IF g_aaz.aaz83 = 'Y' THEN
#     DROP TABLE x11
#     LET l_sql = " SELECT tah00,tah01,",next_yy," h2,0 h3,SUM(tah04-tah05) h4,",
#                 "        0 h5,0 h6,0 h7,tah08,SUM(tah09-tah10) h9,0 h10,tahlegal", #FUN-980003 add tahlegal
#                 "   FROM tah_file, aag_file",
#                 "  WHERE tah00 = '",pp_aaa00,"' AND tah02 = ",last_yy,
#                 "    AND tah00 = aag00",     #No.FUN-740020 
#                 "    AND tah01 = aag01",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#                 "  GROUP BY tah00,tah01,tah08,tahlegal ", #FUN-980003 add tahlegal
#                 "   INTO TEMP x11 "
#     PREPARE pre_x11 FROM l_sql
#     EXECUTE pre_x11
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1-x11)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#3.1-x11)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.1-x11)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,
#                         tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
#           SELECT * FROM x11 where h4 >0    #No.MOD-520041 原為h4!=0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.11-x11)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x11)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11-x11)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.11-x11)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 
#     DROP TABLE x13
#     LET l_sql = " SELECT tah00,tah01,",next_yy," h2,0 h3,0 h4,",
#                 "        SUM(tah05-tah04) h5,0 h6,0 h7,tah08,SUM(tah09-tah10) h9,0 h10,tahlegal", #FUN-980003 add tahlegal
#                 "   FROM tah_file, aag_file",
#                 "  WHERE tah00 = '",pp_aaa00,"' AND tah02 = ",last_yy,
#                 "    AND tah00 = aag00",     #No.FUN-740020 
#                 "    AND tah01 = aag01",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#                 "  GROUP BY tah00,tah01,tah08,tahlegal ", #FUN-980003 add tahlegal
#                 "   INTO TEMP x13 "
#     PREPARE pre_x13 FROM l_sql
#     EXECUTE pre_x13
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1-x13)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.1-x12)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,
#                         tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
#          SELECT * FROM x13 where h5 >0  
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.11-x13)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x13)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11-x13)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x13)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     #No.MOD-520041 add end
#  END IF
##----------------------------------------------------------------------
#     DROP TABLE x2
#    LET l_sql = 
#  " SELECT aah00,aah01,",next_yy," h2,0 h3,0 h4,sum(aah05-aah04) h5,0 h6,0 h7,aahlegal", #FUN-980003 add aahlegal
#  "           FROM aah_file, aag_file ",
#  "          WHERE aah00 = '",pp_aaa00,"' AND aah02 = ",last_yy,
#  "            AND aah01 = aag01 ",
#  "            AND aah00 = aag00 ",     #No.FUN-740020 
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#  "          GROUP BY aah00,aah01,aahlegal", #FUN-980003 add aahlegal
#  "          INTO TEMP x2 "
#    PREPARE pre_x2 FROM l_sql
#    EXECUTE pre_x2
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)  #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
#           SELECT * FROM x2 where h5 >0    #No.MOD-520041
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.12-x2)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x2)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12-x2)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x2)",1)  
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 add
#     DROP TABLE x22
#    LET l_sql = 
#  " SELECT aah00,aah01,",next_yy," h2,0 h3,sum(aah04-aah05) h4,0 h5,0 h6,0 h7,aahlegal", #FUN-980003 add aahlegal
#  "           FROM aah_file, aag_file ",
#  "          WHERE aah00 = '",pp_aaa00,"' AND aah02 = ",last_yy,
#  "            AND aah00 = aag00 ",     #No.FUN-740020 
#  "            AND aah01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#  "          GROUP BY aah00,aah01,aahlegal", #FUN-980003 add aahlegal
#  "          INTO TEMP x22 "
#    PREPARE pre_x22 FROM l_sql
#    EXECUTE pre_x22
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2-x22)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:ckp#3.2-x22)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2-x22)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
#          SELECT * FROM x22 where h4>0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.12-x22)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x22)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12-x22)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x22)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#  #add by danny 020301 外幣管理(A002)
#  IF g_aaz.aaz83 = 'Y' THEN
#     DROP TABLE x21
#     LET l_sql = " SELECT tah00,tah01,",next_yy," h2,0 h3,0 h4,",
#                 "        SUM(tah05-tah04) h5,0 h6,0 h7,tah08,0 h9,",
#                 "        SUM(tah10-tah09) h10,tahlegal ", #FUN-980003 add tahlegal
#                 "   FROM tah_file, aag_file",
#                 "  WHERE tah00 = '",pp_aaa00,"' AND tah02 = ",last_yy,
#                 "    AND tah00 = aag00",    #No.FUN-740020 
#                 "    AND tah01 = aag01",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#                 "  GROUP BY tah00,tah01,tah08,tahlegal", #FUN-980003 add tahlegal
#                 "   INTO TEMP x21 "
#     PREPARE pre_x21 FROM l_sql
#     EXECUTE pre_x21
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2-x21)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#         IF g_bgerr THEN
#             LET   g_showmsg=pp_aaa00,"/",last_yy
#             CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#3.2-x21)',SQLCA.sqlcode,1)
#         ELSE
#             CALL cl_err('(s_eoy:ckp#3.2-x21)',SQLCA.sqlcode,1) 
#         END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,
#                         tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
#           SELECT * FROM x21 where h5 > 0          #No.MOD-520041
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.12-x21)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x21)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12-x21)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x21)",1) 
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 add
#     DROP TABLE x23
#     LET l_sql = " SELECT tah00,tah01,",next_yy," h2,0 h3,SUM(tah04-tah05) h4,",
#                 "        0 h5,0 h6,0 h7,tah08,SUM(tah09-tah10) h9,",
#                 "        0 h10,tahlegal ", #FUN-980003 add tahlegal
#                 "   FROM tah_file, aag_file",
#                 "  WHERE tah00 = '",pp_aaa00,"' AND tah02 = ",last_yy,
#                 "    AND tah00 = aag00",     #No.FUN-740020 
#                 "    AND tah01 = aag01",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#                 "  GROUP BY tah00,tah01,tah08,tahlegal", #FUN-980003 add tahlegal
#                 "   INTO TEMP x23 "
#     PREPARE pre_x23 FROM l_sql
#     EXECUTE pre_x23
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2-x23)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#3.2-x23)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2-x23)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,
#                         tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
#          SELECT * FROM x23 where h4 >  0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.12-x23)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x23)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12-x23)',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err3("ins","tah_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x23)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 end
#  END IF
##----------------------------------------------------------------------
#    MESSAGE "move to next year's aed!"
#     DROP TABLE x3
#    LET l_sql = 
#  " SELECT aed00,aed01 d1,aed011 d11,aed02 d2,",next_yy ," d3,",
#  "        0 d4,sum(aed05-aed06) d5,0 d6, ",
#  "        aed012,aedlegal ", #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#  "           FROM aed_file, aag_file ",
#  "          WHERE aed00 = '",pp_aaa00,"' AND aed03 = ",last_yy,
#  "            AND aed00 = aag00 ",     #No.FUN-740020 
#  "            AND aed01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#  "          GROUP BY aed00,aed01,aed011,aed02,",
#  "                   aed012,aedlegal", #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#  "          INTO TEMP x3 "
#   PREPARE pre_x3 FROM l_sql
#   EXECUTE pre_x3
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.3)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy  
#              CALL s_errmsg('aed00,aed03',g_showmsg,'(s_eoy:ckp#3.3)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.3)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,aed04,aed05,aed06,
#                         aed012,aedlegal) #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#           SELECT * FROM x3 where d5 >  0       #No.MOD-520041
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.31)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.31)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31)",1)  
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 add
#     DROP TABLE x32
#    LET l_sql = 
#  " SELECT aed00,aed01 d1,aed011 d11,aed02 d2,",next_yy ," d3,",
#  "        0 d4,0 d5,sum(aed06-aed05) d6, ",
#  "        aed012,aedlegal ",         #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#  "           FROM aed_file, aag_file ",
#  "          WHERE aed00 = '",pp_aaa00,"' AND aed03 = ",last_yy,
#  "            AND aed00 = aag00 ",    #No.FUN-740020 
#  "            AND aed01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#  "          GROUP BY aed00,aed01,aed011,aed02,",
#  "                   aed012,aedlegal ",  #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#  "          INTO TEMP x32"
#   PREPARE pre_x32 FROM l_sql
#   EXECUTE pre_x32
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.3-x32)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy 
#              CALL s_errmsg('aed00,aed03',g_showmsg,'(s_eoy:ckp#3.3-x32)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.3-x32)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,aed04,aed05,aed06,
#                         aed012,aedlegal) #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#          SELECT * FROM x32 where d6 > 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.31-x32)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31-x32)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.31-x32)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31-x32)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 end
#  #add by danny 020301 外幣管理(A002)
#  IF g_aaz.aaz83 = 'Y' THEN
#     DROP TABLE x31
#     LET l_sql = " SELECT ted00,ted01,ted011,ted02,",next_yy ," d3,",
#                 "        0 d4,SUM(ted05-ted06) d5,0 d6,ted09,",
#                 "        SUM(ted10-ted11) d10,0 d11, ",
#                 "        ted012,tedlegal",  #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   FROM ted_file, aag_file ",
#                 "  WHERE ted00 = '",pp_aaa00,"' AND ted03 = ",last_yy,
#                 "    AND ted00 = aag00 ",   #No.FUN-740020 
#                 "    AND ted01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#                 "  GROUP BY ted00,ted01,ted011,ted02,ted09, ",
#                 "           ted012,tedlegal ", #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   INTO TEMP x31 "
#     PREPARE pre_x31 FROM l_sql
#     EXECUTE pre_x31
#       IF SQLCA.sqlcode THEN
##         CALL cl_err('(s_eoy:ckp#3.3)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#          IF g_bgerr THEN
#            LET g_showmsg=pp_aaa00,"/",last_yy
#            CALL s_errmsg('ted00,ted03',g_showmsg,'(s_eoy:ckp#3.3)',SQLCA.sqlcode,1)
#          ELSE
#            CALL cl_err('(s_eoy:ckp#3.3)',SQLCA.sqlcode,1)
#          END IF
##NO.FUN-710023--END
#          LET g_success='N' RETURN
#       END IF
#     INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,ted06,
#                          ted09,ted10,ted11,
#                          ted012,tedlegal) #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#          SELECT * FROM x31 where d5 > 0       #No:BUB-520041
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.31)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.31',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31)",1) 
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 add
#     DROP TABLE x33
#     LET l_sql = " SELECT ted00,ted01,ted011,ted02,",next_yy ," d3,",
#                 "        0 d4,0 d5,SUM(ted06-ted05) d6,ted09,",
#                 "        SUM(ted10-ted11) d10,0 d11, ",
#                 "        ted012,tedlegal ", #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   FROM ted_file, aag_file ",
#                 "  WHERE ted00 = '",pp_aaa00,"' AND ted03 = ",last_yy,
#                 "    AND ted00 = aag00 ",    #No.FUN-740020 
#                 "    AND ted01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#                 "  GROUP BY ted00,ted01,ted011,ted02,ted09, ",
#                 "           ted012,tedlegal ",   #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   INTO TEMP x33 "
#     PREPARE pre_x33 FROM l_sql
#     EXECUTE pre_x33
#       IF SQLCA.sqlcode THEN
##         CALL cl_err('(s_eoy:ckp#3.3-x33)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#          IF g_bgerr THEN
#            LET g_showmsg=pp_aaa00,"/",last_yy
#            CALL s_errmsg('ted00,ted03',g_showmsg,'(s_eoy:ckp#3.3-x33)',SQLCA.sqlcode,1)
#          ELSE
#            CALL cl_err('(s_eoy:ckp#3.3-x33)',SQLCA.sqlcode,1)
#          END IF
##NO.FUN-710023--END
#          LET g_success='N' RETURN
#       END IF
#     INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,ted06,
#                          ted09,ted10,ted11,
#                          ted012,tedlegal)   #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#          SELECT * FROM x33 where d6 > 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.31-x33)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31-x33)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.31-x33',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.31-x33)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#  END IF
##----------------------------------------------------------------------
#     DROP TABLE x4
#    LET l_sql = 
#" SELECT aed00,aed01,aed011,aed02,",next_yy," d3,0 d4,0 d5,sum(aed06-aed05) d6,",
#"        aed012,aedlegal ",   #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#"             FROM aed_file, aag_file ",
#"            WHERE aed00 = '",pp_aaa00,"' AND aed03 = ",last_yy,
#"              AND aed00 = aag00 ",    #No.FUN-740020 
#"              AND aed01 = aag01 ",
#"              AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#"            GROUP BY aed00,aed01,aed011,aed02, ",
#"                     aed012,aedlegal ",   #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#"            INTO TEMP x4 "
#    PREPARE pre_x4 FROM l_sql
#    EXECUTE pre_x4
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.4)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               LET g_showmsg=pp_aaa00,"/",last_yy
#               CALL s_errmsg('aed00,aed03',g_showmsg,'(s_eoy:ckp#3.4)',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err('(s_eoy:ckp#3.4)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,aed04,aed05,aed06,
#                         aed012,aedlegal)    ##FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#           SELECT * FROM x4 where d6 >  0     #No.MOD-520041
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.41)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.41',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41)",1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041
#     DROP TABLE x42
#    LET l_sql = 
#" SELECT aed00,aed01,aed011,aed02,",next_yy," d3,0 d4,sum(aed05-aed06) d5,0 d6,",
#"        aed012,aedlegal ",   #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#"             FROM aed_file, aag_file ",
#"            WHERE aed00 = '",pp_aaa00,"' AND aed03 = ",last_yy,
#"              AND aed00 = aag00 ",      #No.FUN-740020 
#"              AND aed01 = aag01 ",
#"              AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#"            GROUP BY aed00,aed01,aed011,aed02, ",
#"                     aed012,aedlegal ", #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#"            INTO TEMP x42 "
#    PREPARE pre_x42 FROM l_sql
#    EXECUTE pre_x42
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.4-x42)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aed00,aed03',g_showmsg,'(s_eoy:ckp#3.4-x42)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.4-x42)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#    INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,aed04,aed05,aed06,
#                         aed012,aedlegal)   #FUN-5C0015 BY GILL #FUN-980003 add aedlegal
#          SELECT * FROM x42 where d5 >  0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.41-x42)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41-x42)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.41-x42',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aed_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41-x42)",1)   
#            END IF      
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 end
#  #add by danny 020301 外幣管理(A002)
#  IF g_aaz.aaz83 = 'Y' THEN
#     DROP TABLE x41
#     LET l_sql = " SELECT ted00,ted01,ted011,ted02,",next_yy," d3,0 d4,0 d5,",
#                 "        SUM(ted06-ted05) d6,ted09,0 d10,",
#                 "        SUM(ted11-ted10) d11,",
#                 "        ted012,tedlegal ",   #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   FROM ted_file, aag_file ",
#                 "  WHERE ted00 = '",pp_aaa00,"' AND ted03 = ",last_yy,
#                 "    AND ted00 = aag00 ",     #No.FUN-740020 
#                 "    AND ted01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#                 "  GROUP BY ted00,ted01,ted011,ted02,ted09, ",
#                 "           ted012,tedlegal ", #FUN-980003 add tedlegal
#                 "   INTO TEMP x41 "
#     PREPARE pre_x41 FROM l_sql
#     EXECUTE pre_x41
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.4)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('ted00,ted03',g_showmsg,'(s_eoy:ckp#3.4)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.4)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,ted06,
#                          ted09,ted10,ted11,
#                          ted012,tedlegal)    #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#           SELECT * FROM x41 where d6 > 0        #No.MOD-520041
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.41)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.41',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#      #No.MOD-520041 add 
#     DROP TABLE x43
#     LET l_sql = " SELECT ted00,ted01,ted011,ted02,",next_yy," d3,0 d4,SUM(ted05-ted06) d5,",
#                 "        0 d6,ted09,0 d10,",
#                 "        SUM(ted11-ted10) d11,",
#                 "        ted012,tedlegal ",   #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   FROM ted_file, aag_file ",
#                 "  WHERE ted00 = '",pp_aaa00,"' AND ted03 = ",last_yy,
#                 "    AND ted00 = aag00 ",    #No.FUN-740020 
#                 "    AND ted01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#                 "  GROUP BY ted00,ted01,ted011,ted02,ted09, ",
#                 "           ted012,tedlegal ",  #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#                 "   INTO TEMP x43 "
#     PREPARE pre_x43 FROM l_sql
#     EXECUTE pre_x43
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.4-x43)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('ted00,ted03',g_showmsg,'(s_eoy:ckp#3.4-x43)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.4-x43)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,ted06,
#                          ted09,ted10,ted11,
#                          ted012,tedlegal)  #FUN-5C0015 BY GILL #FUN-980003 add tedlegal
#          SELECT * FROM x43 where d5 > 0
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.41-x43)',SQLCA.sqlcode,1)   #No.FUN-660123
##           CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41-x43)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.41-x43',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err3("ins","ted_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.41-x43)",1)   
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        END IF
#     #No.MOD-520041 end
#  END IF
##-------------------- no.3565 01/09/20 ------------------------
#    MESSAGE "move to next year's aef!"
#    DROP TABLE x7
#    LET l_sql = 
#  " SELECT aef00,aef01 f1,aef02 f2,",next_yy," f3, ",
#  "        0 f4,sum(aef05-aef06) f5,0 f6,aeflegal ", #FUN-980003 add aeflegal
#  "           FROM aef_file, aag_file ",
#  "          WHERE aef00 = '",pp_aaa00 ,"' AND aef03 = ",last_yy,
#  "            AND aef00 = aag00 ",     #No.FUN-740020 
#  "            AND aef01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#  "          GROUP BY aef00,aef01,aef02,aeflegal ", #FUN-980003 add aeflegal
#  "          INTO TEMP x7 "
#    PREPARE pre_x7 FROM l_sql
#    EXECUTE pre_x7
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#7.1)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aef00,aef03',g_showmsg,'(s_eoy:ckp#7.1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#7.1)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#             #No.MOD-510030 modi
#            INSERT INTO aef_file(aef00,aef01,aef02,aef03,aef04,aef05,aef06,aeflegal) #FUN-980003 add aeflegal
#               SELECT * FROM x7 where f5 > 0    #No.MOD-520041
#            IF SQLCA.sqlcode THEN
##              CALL cl_err('(s_eoy:ckp#7.2)',SQLCA.sqlcode,1)   #No.FUN-660123
##              CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#7.2)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#               IF g_bgerr THEN
#                 CALL s_errmsg(' ',' ','(s_eoy:ckp#7.2',SQLCA.sqlcode,1)
#               ELSE
#                 CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#7.2)",1)  
#               END IF
##NO.FUN-710023--END
#               LET g_success='N' RETURN
#            END IF
#        END IF
#     #No.MOD-520041
#    DROP TABLE x71
#    LET l_sql = 
#  " SELECT aef00,aef01 f1,aef02 f2,",next_yy," f3, ",
#  "        0 f4,0 f5,sum(aef06-aef05) f6,aeflegal ", #FUN-980003 add aeflegal
#  "           FROM aef_file, aag_file ",
#  "          WHERE aef00 = '",pp_aaa00 ,"' AND aef03 = ",last_yy,
#  "            AND aef00 = aag00 ",     #No.FUN-740020 
#  "            AND aef01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#  "          GROUP BY aef00,aef01,aef02,aeflegal ", #FUN-980003 add aeflegal
#  "          INTO TEMP x71"
#    PREPARE pre_x71 FROM l_sql
#    EXECUTE pre_x71
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#7.1-x71)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aef00,aef03',g_showmsg,'(s_eoy:ckp#7.1-x71)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#7.1-x71)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#            INSERT INTO aef_file(aef00,aef01,aef02,aef03,aef04,aef05,aef06,aeflegal) #FUN-980003 add aeflegal
#              SELECT * FROM x71 where f6 > 0
#            IF SQLCA.sqlcode THEN
##              CALL cl_err('(s_eoy:ckp#7.2-x71)',SQLCA.sqlcode,1)   #No.FUN-660123
##              CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#7.2-x71)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#               IF g_bgerr THEN
#                CALL s_errmsg(' ',' ','(s_eoy:ckp#7.2-x71',SQLCA.sqlcode,1)
#               ELSE
#                CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#7.2-x71)",1)  
#               END IF
##NO.FUN-710023--END
#               LET g_success='N' RETURN
#            END IF
#        END IF
#     #No.MOD-520041 end 
#     DROP TABLE x8
#    LET l_sql =
#  " SELECT aef00,aef01,aef02,",next_yy," f3,0 f4,0 f5,sum(aef06-aef05) f6,aeflegal", #FUN-980003 add aeflegal
#  "           FROM aef_file, aag_file ",
#  "          WHERE aef00 = '",pp_aaa00,"' AND aef03 = ",last_yy,
#  "            AND aef00 = aag00 ",     #No.FUN-740020 
#  "            AND aef01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#  "          GROUP BY aef00,aef01,aef02,aeflegal ", #FUN-980003 add aeflegal
#  "          INTO TEMP x8 "
#    PREPARE pre_x8 FROM l_sql
#    EXECUTE pre_x8
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#8.1)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aef00,aef03',g_showmsg,'(s_eoy:ckp#8.1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#8.1)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#            INSERT INTO aef_file(aef00,aef01,aef02,aef03,aef04,aef05,aef06,aeflegal) #FUN-980003 add aeflegal
#               SELECT * FROM x8 where f6 > 0            #No.MOD-520041
#             #No.MOD-510030 modi
#            IF SQLCA.sqlcode THEN
##              CALL cl_err('(s_eoy:ckp#8.2)',SQLCA.sqlcode,1)   #No.FUN-660123
##              CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#8.2)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#               IF g_bgerr THEN
#                 CALL s_errmsg(' ',' ','(s_eoy:ckp#8.2',SQLCA.sqlcode,1)
#               ELSE
#                 CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#8.2)",1)   
#               END IF
##NO.FUN-710023--END
#               LET g_success='N' RETURN
#            END IF 
#        END IF
#      #No.MOD-520041
#     DROP TABLE x81
#    LET l_sql =
#  " SELECT aef00,aef01,aef02,",next_yy," f3,0 f4,sum(aef05-aef06) f5,0 f6,aeflegal", #FUN-980003 add aeflegal
#  "           FROM aef_file, aag_file ",
#  "          WHERE aef00 = '",pp_aaa00,"' AND aef03 = ",last_yy,
#  "            AND aef00 = aag00 ",    #No.FUN-740020 
#  "            AND aef01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#  "          GROUP BY aef00,aef01,aef02,aeflegal ", #FUN-980003 add aeflegal
#  "          INTO TEMP x81 "
#    PREPARE pre_x81 FROM l_sql
#    EXECUTE pre_x81
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#8.1-x81)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               LET g_showmsg=pp_aaa00,"/",last_yy
#               CALL s_errmsg('aef00,aef03',g_showmsg,'(s_eoy:ckp#8.1-x81)',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err('(s_eoy:ckp#8.1-x81)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#            INSERT INTO aef_file(aef00,aef01,aef02,aef03,aef04,aef05,aef06,aeflegal) #FUN-980003 add aeflegal
#              SELECT * FROM x81 where f5 > 0
#            IF SQLCA.sqlcode THEN
##              CALL cl_err('(s_eoy:ckp#8.2-x81)',SQLCA.sqlcode,1)   #No.FUN-660123
##              CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#8.2-x81)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#               IF g_bgerr THEN
#                  CALL s_errmsg(' ',' ','(s_eoy:ckp#8.2-x81',SQLCA.sqlcode,1)
#               ELSE
#                  CALL cl_err3("ins","aef_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#8.2-x81)",1)  
#               END IF
##NO.FUN-710023--END
#               LET g_success='N' RETURN
#            END IF 
#        END IF
###-------------- end no.3563 01/09/20 -----------------------------
### No:2767  modify 1998/11/13 -------------------------------------
#     MESSAGE "move to next year's aao!"
#     DROP TABLE x5
#     LET l_sql = 
#   " SELECT aao00,aao01,aao02, ",
#            next_yy," h2,0 h3,sum(aao05-aao06) h4,0 h5,0 h6,0 h7,aaolegal ", #FUN-980003 add aaolegal
#   "          FROM aao_file, aag_file ",
#   "         WHERE aao00 = '",pp_aaa00,"' AND aao03 =", last_yy,
#   "           AND aao00 = aag00 ",     #No.FUN-740020 
#   "           AND aao01 = aag01 ",
#   "           AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#   "         GROUP BY aao00,aao01,aao02,aaolegal ", #FUN-980003 add aaolegal
#   "         INTO TEMP x5 "
#      PREPARE pre_x5 FROM l_sql
#      EXECUTE pre_x5
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aao00,aao03',g_showmsg,'(s_eoy:ckp#3.1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE   
#         #No.MOD-510030 
#          INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,aao06,aao07,aao08,aaolegal) #FUN-980003 add aaolegal
#             SELECT * FROM x5 where h4 > 0          #No.MOD-520041
#          IF SQLCA.sqlcode THEN
##            CALL cl_err('(s_eoy:ckp#3.11)',SQLCA.sqlcode,1)   #No.FUN-660123
##            CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#             IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11',SQLCA.sqlcode,1)
#             ELSE
#               CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11)",1)   
#             END IF
##NO.FUN-710023--END
#             LET g_success='N' RETURN
#          END IF
#        END IF
#      #No.MOD-520041 add
#     DROP TABLE x52
#     LET l_sql = 
#   " SELECT aao00,aao01,aao02, ",
#            next_yy," h2,0 h3,0 h4,sum(aao06-aao05) h5,0 h6,0 h7,aaolegal ", #FUN-980003 add aaolegal
#   "          FROM aao_file, aag_file ",
#   "         WHERE aao00 = '",pp_aaa00,"' AND aao03 =", last_yy,
#   "           AND aao00 = aag00 ",    #No.FUN-740020 
#   "           AND aao01 = aag01 ",
#   "           AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#   "         GROUP BY aao00,aao01,aao02,aaolegal ", #FUN-980003 add aaolegal
#   "         INTO TEMP x52"
#      PREPARE pre_x52 FROM l_sql
#      EXECUTE pre_x52
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1-x52)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#               LET g_showmsg=pp_aaa00,"/",last_yy
#               CALL s_errmsg('aao00,aao03',g_showmsg,'(s_eoy:ckp#3.1-x52)',SQLCA.sqlcode,1)
#            ELSE
#               CALL cl_err('(s_eoy:ckp#3.1-x52)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE   
#          INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,aao06,aao07,aao08,aaolegal) #FUN-980003 add aaolegal
#            SELECT * FROM x52 where h5 > 0
#          IF SQLCA.sqlcode THEN
##            CALL cl_err('(s_eoy:ckp#3.11-x52)',SQLCA.sqlcode,1)   #No.FUN-660123
##            CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x52)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#             IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11-x52',SQLCA.sqlcode,1)
#             ELSE
#               CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x52)",1)   
#             END IF
##NO.FUN-710023--END
#             LET g_success='N' RETURN
#          END IF
#        END IF
#       #No.MOD-520041 end
#  #add by danny 020301 外幣管理(A002)
#  IF g_aaz.aaz83 = 'Y' THEN
#     DROP TABLE x51
#     LET l_sql = " SELECT tao00,tao01,tao02,",next_yy," h2,0 h3,",
#                 "        SUM(tao05-tao06) h4,0 h5,0 h6,0 h7,tao09, ",
#                 "        SUM(tao10-tao11) h8,0 h9,taolegal ", #FUN-980003 add taolegal
#                 "   FROM tao_file, aag_file ",
#                 "  WHERE tao00 = '",pp_aaa00,"' AND tao03 =", last_yy,
#                 "    AND tao00 = aag00 ",    #No.FUN-740020 
#                 "    AND tao01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#                 "  GROUP BY tao00,tao01,tao02,tao09,taolegal ", #FUN-980003 add taolegal
#                 "   INTO TEMP x51 "
#      PREPARE pre_x51 FROM l_sql
#      EXECUTE pre_x51
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tao00,tao03',g_showmsg,'(s_eoy:ckp#3.1)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#         #No.MOD-510030
#        ELSE  
#          INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,tao06,tao07,tao08,
#                         tao09,tao10,tao11,taolegal) #FUN-980003 add taolegal
#           SELECT * FROM x51 where h4 > 0    #No.MOD-520041
#          IF SQLCA.sqlcode THEN
##             CALL cl_err('(s_eoy:ckp#3.11)',SQLCA.sqlcode,1)   #No.FUN-660123
##             CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11)",1)   #No.FUN-660123  #NO.FUN-710023
##NO.FUN-710023--BEGIN
#              IF g_bgerr THEN
#                CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11',SQLCA.sqlcode,1)
#              ELSE
#                CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11)",1)  
#              END IF
##NO.FUN-710023
#              LET g_success='N' RETURN
#          END IF
#        END IF
#      #No.MOD-520041 add
#     DROP TABLE x53
#     LET l_sql = " SELECT tao00,tao01,tao02,",next_yy," h2,0 h3,",
#                 "        0 h4,SUM(tao06-tao05) h5,0 h6,0 h7,tao09, ",
#                 "        0 h8,SUM(tao11-tao10) h9,taolegal ", #FUN-980003 add taolegal
#                 "   FROM tao_file, aag_file ",
#                 "  WHERE tao00 = '",pp_aaa00,"' AND tao03 =", last_yy,
#                 "    AND tao00 = aag00 ",     #No.FUN-740020 
#                 "    AND tao01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
#                 "  GROUP BY tao00,tao01,tao02,tao09,taolegal ", #FUN-980003 add taolegal
#                 "   INTO TEMP x53 "
#      PREPARE pre_x53 FROM l_sql
#      EXECUTE pre_x53
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.1-x53)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tao00,tao03',g_showmsg,'(s_eoy:ckp#3.1-x53)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.1-x53)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE  
#          INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,tao06,tao07,tao08,
#                         tao09,tao10,tao11,taolegal) #FUN-980003 add taolegal
#          SELECT * FROM x53 where h5 > 0 
#          IF SQLCA.sqlcode THEN
##             CALL cl_err('(s_eoy:ckp#3.11-x53)',SQLCA.sqlcode,1)   #No.FUN-660123
##             CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x53)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#              IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.11-x53)',SQLCA.sqlcode,1)
#              ELSE
#               CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11-x53)",1)   
#              END IF
##NO.FUN-710023--END
#              LET g_success='N' RETURN
#          END IF
#        END IF
#        #No.MOD-520041 end
#  END IF
##----------------------------------------------------------------------
#     DROP TABLE x6
#    LET l_sql = 
#  " SELECT aao00,aao01,aao02,",
#           next_yy," h2,0 h3,0 h4,sum(aao06-aao05) h5,0 h6,0 h7,aaolegal ", #FUN-980003 add aaolegal
#  "           FROM aao_file, aag_file ",
#  "          WHERE aao00 = '",pp_aaa00,"' AND aao03 = ",last_yy,
#  "            AND aao00 = aag00 ",    #No.FUN-740020 
#  "            AND aao01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#  "          GROUP BY aao00,aao01,aao02,aaolegal ", #FUN-980003 add aaolegal
#  "          INTO TEMP x6 "
#    PREPARE pre_x6 FROM l_sql
#    EXECUTE pre_x6
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aao00,aao03',g_showmsg,'(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#         INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,aao06,aao07,aao08,aaolegal) #FUN-980003 add aaolegal
#           SELECT * FROM x6 where h5 > 0              #No.MOD-520041
#         IF SQLCA.sqlcode THEN
##            CALL cl_err('(s_eoy:ckp#3.12)',SQLCA.sqlcode,1)   #No.FUN-660123
##            CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12)",1) 
#            END IF
##NO.FUN-710023--END
#             LET g_success='N' RETURN
#         END IF
#        END IF
#      #No.MOD-520041 add 
#     DROP TABLE x62
#    LET l_sql = 
#  " SELECT aao00,aao01,aao02,",
#           next_yy," h2,0 h3,sum(aao05-aao06) h4,0 h5,0 h6,0 h7,aaolegal ", #FUN-980003 add aaolegal
#  "           FROM aao_file, aag_file ",
#  "          WHERE aao00 = '",pp_aaa00,"' AND aao03 = ",last_yy,
#  "            AND aao00 = aag00 ",    #No.FUN-740020 
#  "            AND aao01 = aag01 ",
#  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#  "          GROUP BY aao00,aao01,aao02,aaolegal ", #FUN-980003 add aaolegal
#  "          INTO TEMP x62"
#    PREPARE pre_x62 FROM l_sql
#    EXECUTE pre_x62
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2-x62)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('aao00,aao03',g_showmsg,'(s_eoy:ckp#3.2-x62)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2-x62)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#         INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,aao06,aao07,aao08,aaolegal) #FUN-980003 add aaolegal
#          SELECT * FROM x62 where h4 > 0
#         IF SQLCA.sqlcode THEN
##            CALL cl_err('(s_eoy:ckp#3.12-x62)',SQLCA.sqlcode,1)   #No.FUN-660123
##            CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x62)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#             IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12-x62)',SQLCA.sqlcode,1)
#             ELSE
#               CALL cl_err3("ins","aao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x62)",1)   
#             END IF
##NO.FUN-710023--END
#             LET g_success='N' RETURN
#         END IF
#        END IF
#     #No.MOD-520041 end
#  #add by danny 020301 外幣管理(A002)
#  IF g_aaz.aaz83 = 'Y' THEN
#     DROP TABLE x61
#     LET l_sql = " SELECT tao00,tao01,tao02,",next_yy," h2,0 h3,0 h4,",
#                 "        SUM(tao06-tao05) h5,0 h6,0 h7,tao09,0 h8, ",
#                 "        SUM(tao11-tao10) h9,taolegal ", #FUN-980003 add taolegal
#                 "   FROM tao_file, aag_file ",
#                 "  WHERE tao00 = '",pp_aaa00,"' AND tao03 = ",last_yy,
#                 "    AND tao00 = aag00 ",      #No.FUN-740020 
#                 "    AND tao01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#                 "  GROUP BY tao00,tao01,tao02,tao09,taolegal ", #FUN-980003 add taolegal
#                 "   INTO TEMP x61 "
#     PREPARE pre_x61 FROM l_sql
#     EXECUTE pre_x61
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tao00,tao03',g_showmsg,'(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#          INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,tao06,tao07,tao08,
#                          tao09,tao10,tao11,taolegal) #FUN-980003 add taolegal
#           SELECT * FROM x61 where h5 > 0               #No.MOD-520041
#          IF SQLCA.sqlcode THEN
##             CALL cl_err('(s_eoy:ckp#3.12)',SQLCA.sqlcode,1)   #No.FUN-660123
##             CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#             IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12)',SQLCA.sqlcode,1)
#             ELSE
#               CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12)",1)   
#             END IF
##NO.FUN-710023--END
#              LET g_success='N' RETURN
#          END IF
#      END IF
#      #No.MOD-520041 add
#     DROP TABLE x63
#     LET l_sql = " SELECT tao00,tao01,tao02,",next_yy," h2,0 h3,SUM(tao05-tao06) h4,",
#                 "        0 h5,0 h6,0 h7,tao09,SUM(tao10-tao11) h8, ",
#                 "        0 h9 ,taolegal", #FUN-980003 add taolegal
#                 "   FROM tao_file, aag_file ",
#                 "  WHERE tao00 = '",pp_aaa00,"' AND tao03 = ",last_yy,
#                 "    AND tao00 = aag00 ",    #No.FUN-740020 
#                 "    AND tao01 = aag01 ",
#                 "    AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
#                 "  GROUP BY tao00,tao01,tao02,tao09,taolegal ", #FUN-980003 add taolegal
#                 "   INTO TEMP x63 "
#     PREPARE pre_x63 FROM l_sql
#     EXECUTE pre_x63
#        IF SQLCA.sqlcode THEN
##           CALL cl_err('(s_eoy:ckp#3.2-x63)',SQLCA.sqlcode,1) #NO.FUN-710023
##NO.FUN-710023--BEGIN
#            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa00,"/",last_yy
#              CALL s_errmsg('tao00,tao03',g_showmsg,'(s_eoy:ckp#3.2-x63)',SQLCA.sqlcode,1)
#            ELSE
#              CALL cl_err('(s_eoy:ckp#3.2-x63)',SQLCA.sqlcode,1)
#            END IF
##NO.FUN-710023--END
#            LET g_success='N' RETURN
#        ELSE
#          INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,tao06,tao07,tao08,
#                          tao09,tao10,tao11,taolegal) #FUN-980003 add taolegal
#          SELECT * FROM x63 where h4 > 0
#          IF SQLCA.sqlcode THEN
##            CALL cl_err('(s_eoy:ckp#3.12-x63)',SQLCA.sqlcode,1)   #No.FUN-660123
##            CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x63)",1)   #No.FUN-660123 #NO.FUN-710023
##NO.FUN-710023--BEGIN
#             IF g_bgerr THEN
#               CALL s_errmsg(' ',' ','(s_eoy:ckp#3.12-x63)',SQLCA.sqlcode,1)
#             ELSE
#               CALL cl_err3("ins","tao_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12-x63)",1)   
#             END IF
##NO.FUN-710023--END
#             LET g_success='N' RETURN
#          END IF
#      END IF
#       #No.MOD-520041 end
#  END IF
##----------------------------------------------------------------------
#END FUNCTION
#No.FUN-AB0068  --End  

FUNCTION s_eoy_aay_close()
  #No.FUN-AB0068  --Begin
   DEFINE l_aag00    LIKE aag_file.aag00
   DEFINE l_aag01    LIKE aag_file.aag01
   DEFINE l_aag00_1  LIKE aag_file.aag00
   DEFINE l_aag01_1  LIKE aag_file.aag01
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_sql      STRING               #CHI-C30014
   DEFINE l_tat04    LIKE tat_file.tat04  #CHI-C30014
   DEFINE l_aah04    LIKE aah_file.aah04  #CHI-C30014
   #MOD-D10019--Begin--
   DEFINE l_aag03        LIKE aag_file.aag03
   DEFINE l_aaa15_master LIKE aaa_file.aaa15
   DEFINE l_aaa15_d      LIKE aah_file.aah04
   DEFINE l_aaa15_tah_d  LIKE aah_file.aah04
   DEFINE l_aaa15_tah_d1 LIKE aah_file.aah04
   DEFINE l_cnt_aaa15    LIKE type_file.num5
   DEFINE l_cnt_aaa16    LIKE type_file.num5
   #MOD-D10019---End---
  #No.FUN-AB0068  --End  
  {---modi by kitty 99-04-28
     DECLARE eoy_cs1 CURSOR FOR 
             SELECT aay_file.* FROM aay_file
     FOREACH eoy_cs1 INTO g_aay.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('(s_eoy:ckp#4.1)',SQLCA.sqlcode,1)  
            LET g_success='N' RETURN
        END IF
  ---}
  #LET g_aaz31 = g_aay.aay02 CLIPPED,g_aaz.aaz31 CLIPPED #本期損益
  #LET g_aaz31 = g_aaz.aaz31 CLIPPED                     #本期損益          #FUN-BC0027
  #LET g_aaz32 = g_aay.aay02 CLIPPED,g_aaz.aaz32 CLIPPED #本期資產
  #LET g_aaz32 = g_aaz.aaz32 CLIPPED                     #本期資產          #FUN-BC0027
  #LET g_aaz33 = g_aay.aay02 CLIPPED,g_aaz.aaz33 CLIPPED #前年損益調整科目
  #LET g_aaz33 = g_aaz.aaz33 CLIPPED                     #前年損益調整科目  #FUN-BC0027
   LET g_aaa14 = g_aaa.aaa14 CLIPPED                     #本期損益          #FUN-BC0027
   LET g_aaa15 = g_aaa.aaa15 CLIPPED                     #本期資產          #FUN-BC0027
   LET g_aaa16 = g_aaa.aaa16 CLIPPED                     #前年損益調整科目  #FUN-BC0027
   LET l_aah01 = 0
  #直接將本期損益的期初餘額給零(因為將其餘額轉入前年損益調整科目中)
  #MESSAGE "del aah:",g_aaz31  #FUN-BC0027
   MESSAGE "del aah:",g_aaa14  #FUN-BC0027
  #SELECT aag08 INTO l_master FROM aag_file WHERE aag00=pp_aaa00 AND aag01=g_aaz33      #MOD-980160 add   #抓統制帳戶 #FUN-BC0027
   SELECT aag08 INTO l_master FROM aag_file WHERE aag00=pp_aaa00 AND aag01=g_aaa16      #FUN-BC0027
  #No.FUN-AB0068  --Begin
   IF g_chg = 'N' THEN
  #No.FUN-AB0068  --End  
  {ckp#7}
      DELETE FROM aah_file                                                    # 3218
       WHERE aah00 = pp_aaa00 AND aah02 = next_yy AND aah03 = 0
        #AND (aah01 = g_aaz31 OR aah01 = g_aaz32  OR aah01 = g_aaz33 )                   #MOD-980160 mark
        #AND (aah01 = g_aaz31 OR aah01 = g_aaz32  OR aah01 = g_aaz33 OR aah01=l_master)  #MOD-980160 add   要連統制帳戶的一起刪 #FUN-BC0027
         AND (aah01 = g_aaa14 OR aah01 = g_aaa15  OR aah01 = g_aaa16 OR aah01=l_master)  #FUN-BC0027
      IF SQLCA.sqlcode THEN
        #NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=pp_aaa00,"/",next_yy 
            CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:ckp#4.2)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#4.2)",1)
         END IF
        #NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
     #-CHI-D10004-add-
      IF g_aaz.aaz83 = 'Y' THEN
         DELETE FROM tah_file
            WHERE tah00 = pp_aaa00
              AND tah02 = next_yy
              AND tah03 = 0
              AND tah08 = g_aaa.aaa03
              AND (tah01 = g_aaa14
                   OR tah01 = g_aaa15
                   OR tah01 = g_aaa16
                   OR tah01 = l_master)
         IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
               LET g_showmsg=pp_aaa00,"/",next_yy
               CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#21)',SQLCA.sqlcode,1)
             ELSE
               CALL cl_err3("del","tah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#21)",1)
             END IF
             LET g_success='N'
             RETURN
         END IF
      END IF
     #-CHI-D10004-end-
  #No.FUN-AB0068  --Begin
   ELSE
     #CALL s_eoy_del_aaz_acount(pp_aaa00,g_aaz31)  #FUN-BC0027
      CALL s_eoy_del_aaz_acount(pp_aaa00,g_aaa14)  #FUN-BC0027
      IF g_success = 'N' THEN RETURN END IF 
     #CALL s_eoy_del_aaz_acount(pp_aaa00,g_aaz32)  #FUN-BC0027
      CALL s_eoy_del_aaz_acount(pp_aaa00,g_aaa15)  #FUN-BC0027
      IF g_success = 'N' THEN RETURN END IF 
     #CALL s_eoy_del_aaz_acount(pp_aaa00,g_aaz33)  #FUN-BC0027
      CALL s_eoy_del_aaz_acount(pp_aaa00,g_aaa16)  #FUN-BC0027
      IF g_success = 'N' THEN RETURN END IF 
      CALL s_eoy_del_aaz_acount(pp_aaa00,l_master)
      IF g_success = 'N' THEN RETURN END IF 
   END IF
  #No.FUN-AB0068  --End  
  #將去年度的損益類科目3218結轉到次年度的3220
  #modify 92/08/13 需再將前一年度的3220 也就是上上年的結轉加入本年度中
  #MESSAGE "sum aah:",g_aaz33  #FUN-BC0027
   MESSAGE "sum aah:",g_aaa16  #FUN-BC0027
   SELECT SUM(aah05-aah04) INTO g_profit FROM aah_file   # 3218
    WHERE aah00 = pp_aaa00 
     #AND aah01 = g_aaz32  #FUN-BC0027
      AND aah01 = g_aaa15  #FUN-BC0027
      AND aah02 = last_yy
   IF g_profit IS NULL THEN LET g_profit = 0 END IF
   SELECT SUM(aah05-aah04) INTO g_y_sum FROM aah_file # 3220
   #WHERE aah00 = pp_aaa00 AND aah01 = g_aaz33 AND aah02 = last_yy #FUN-BC0027
    WHERE aah00 = pp_aaa00 AND aah01 = g_aaa16 AND aah02 = last_yy #FUN-BC0027
   IF g_y_sum IS NULL THEN LET g_y_sum = 0 END IF
   LET g_profit = g_profit + g_y_sum
  #轉入前年損益科目中
  #No.FUN-AB0068  --Begin 
   IF g_chg = 'Y' THEN
     #CALL s_tag(last_yy,pp_aaa00,g_aaz33) RETURNING l_aag00,l_aag01 #FUN-BC0027
      CALL s_tag(last_yy,pp_aaa00,g_aaa16) RETURNING l_aag00,l_aag01 #FUN-BC0027
   ELSE
      LET l_aag00 = pp_aaa00
     #LET l_aag01 = g_aaz33  #FUN-BC0027
      LET l_aag01 = g_aaa16  #FUN-BC0027
   END IF
  #MESSAGE "ins aah:",g_aaz33
   MESSAGE "ins aah:",l_aag01
  #No.FUN-AB0068  --End   
   IF g_profit > 0 THEN                 #No.MOD-520041 增加判斷>0 or <0放在借方或貸方
  #No.FUN-AB0068  --Begin 
      INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 aahlegal
                   #VALUES(pp_aaa00,g_aaz33,next_yy,0,0,g_profit,0,0,g_legal) #FUN-980003 add g_legal
                    VALUES(l_aag00,l_aag01,next_yy,0,0,g_profit,0,0,g_legal)
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN 
           #LET g_showmsg=pp_aaa00,"/",g_aaz33 
            LET g_showmsg=l_aag00,'/',l_aag01 
            CALL s_errmsg('aah00,aah01',g_showmsg,'(s_eoy:ckp#4.3)',SQLCA.sqlcode,1)
         ELSE
           #CALL cl_err3("ins","aah_file",pp_aaa00,g_aaz33,SQLCA.sqlcode,"","s_eoy:ckp#4.3)",1)  
            CALL cl_err3("ins","aah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","s_eoy:ckp#4.3)",1)  
         END IF
         LET g_success='N' RETURN
      END IF
  #No.FUN-AB0068  --End   
   ELSE
  #No.FUN-AB0068  --Begin 
      INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
                   #VALUES(pp_aaa00,g_aaz33,next_yy,0,g_profit,0,0,0)   #MOD-610099
                   #VALUES(pp_aaa00,g_aaz33,next_yy,0,g_profit*-1,0,0,0,g_legal)   #MOD-610099 #FUN-980003 add g_legal
                    VALUES(l_aag00,l_aag01,next_yy,0,g_profit*-1,0,0,0,g_legal)
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           #LET g_showmsg=pp_aaa00,"/",next_yy 
            LET g_showmsg=l_aag00,"/",next_yy 
            CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:ckp#4.3-2)',SQLCA.sqlcode,1)
         ELSE
           #CALL cl_err3("ins","aah_file",pp_aaa00,g_aaz33,SQLCA.sqlcode,"","(s_eoy:ckp#4.3-2)",1)   
            CALL cl_err3("ins","aah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","(s_eoy:ckp#4.3-2)",1)   
         END IF
         LET g_success='N' RETURN
      END IF
        #No.FUN-AB0068  --End
   END IF
  #-CHI-D10004-add-
   IF g_aaz.aaz83 = 'Y' THEN
      LET g_profit = 0
      SELECT SUM(tah05-tah04) INTO g_profit 
        FROM tah_file 
       WHERE tah00 = pp_aaa00 
         AND tah01 = g_aaa15   
         AND tah02 = last_yy
         AND tah08 = g_aaa.aaa03 
      IF cl_null(g_profit) THEN LET g_profit = 0 END IF
      LET g_y_sum = 0
      SELECT SUM(tah05-tah04) INTO g_y_sum 
        FROM tah_file 
       WHERE tah00 = pp_aaa00 
         AND tah01 = g_aaa16   
         AND tah02 = last_yy
         AND tah08 = g_aaa.aaa03 
      IF cl_null(g_y_sum) THEN LET g_y_sum = 0 END IF
      LET g_profit = g_profit + g_y_sum
      #轉入前年損益科目中
      IF g_chg = 'Y' THEN
          CALL s_tag(last_yy,pp_aaa00,g_aaa16) RETURNING l_aag00,l_aag01 
      ELSE
         LET l_aag00 = pp_aaa00
         LET l_aag01 = g_aaa16 
      END IF
      IF g_profit > 0 THEN   
         INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                              tah05,tah06,tah07,tah08,tah09,
                              tah10,tahlegal) 
                       VALUES(l_aag00,l_aag01,next_yy,0,0,
                              g_profit,0,0,g_aaa.aaa03,0,
                              g_profit,g_legal)
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN 
               LET g_showmsg=l_aag00,'/',l_aag01 
               CALL s_errmsg('tah00,tah01',g_showmsg,'(s_eoy:ckp#22)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("ins","tah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","s_eoy:ckp#22)",1)  
            END IF
            LET g_success='N' 
            RETURN
         END IF
      ELSE
         INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                              tah05,tah06,tah07,tah08,tah09,
                              tah10,tahlegal) 
                       VALUES(l_aag00,l_aag01,next_yy,0,g_profit*-1,
                              0,0,0,g_aaa.aaa03,g_profit*-1,
                              0,g_legal)
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg=l_aag00,"/",next_yy 
              CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#23)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("ins","tah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","(s_eoy:ckp#23)",1)   
            END IF
            LET g_success='N' 
            RETURN
         END IF
      END IF
   END IF
  #-CHI-D10004-end-
  #END FOREACH
  #MOD-980160---add---start---
  #SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz33 AND aag00 = pp_aaa00 #FUN-BC0027
   SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa16 AND aag00 = pp_aaa00 #FUN-BC0027
  #No.FUN-AB0068  --Begin
   LET l_flag = 'Y'
   IF l_master IS NULL THEN RETURN END IF
  #IF l_master = g_aaz33 THEN LET l_flag = 'N' END IF #FUN-BC0027
   IF l_master = g_aaa16 THEN LET l_flag = 'N' END IF #FUN-BC0027
   IF g_chg = 'Y' THEN
      CALL s_tag(last_yy,pp_aaa00,l_master) RETURNING l_aag00_1,l_aag01_1
   ELSE
      LET l_aag00_1 = pp_aaa00
      LET l_aag01_1 = l_master
   END IF
   IF l_aag00 = l_aag00_1 AND l_aag01 = l_aag01_1 THEN
      LET l_flag = 'N'
   END IF
  #IF l_master IS NOT NULL AND l_master != g_aaz33 THEN
   IF l_flag = 'Y' THEN
  #No.FUN-AB0068  --End  
      MESSAGE "ins aah:",l_master
     #CHI-A40053---add---start--
      LET g_profit = 0                                          #CHI-D10004 add
      SELECT SUM(aah05 - aah04) INTO g_profit FROM aah_file,aag_file
      #WHERE aah00 = pp_aaa00 AND aah02 = next_yy     #No.FUN-AB0068
       WHERE aah00 = l_aag00_1 AND aah02 = next_yy    #No.FUN-AB0068
        #AND aah03 = 0 AND aag08 = l_master           #No.FUN-AB0068
         AND aah03 = 0 AND aag08 = l_aag01_1          #No.FUN-AB0068
         AND aah00 = aag00 AND aah01 = aag01 AND aag07 = '2'  
      IF cl_null(g_profit) THEN LET g_profit = 0 END IF #CHI-D10004
     #CHI-A40053---add---end---
      IF g_profit > 0 THEN
         INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)    #No.FUN-AB0068
                      #VALUES(pp_aaa00,l_master,next_yy,0,0,g_profit,0,0)                         #No.FUN-AB0068
                       VALUES(l_aag00_1,l_aag01_1,next_yy,0,0,g_profit,0,0,g_legal)               #No.FUN-AB0068
         IF SQLCA.sqlcode THEN
           #CALL cl_err3("ins","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#12)",1)   #No.FUN-AB0068  
            CALL cl_err3("ins","aah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#12)",1)  #No.FUN-AB0068  
            LET g_success='N' RETURN
         END IF
      ELSE
         INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)    #No.FUN-AB0068
                      #VALUES(pp_aaa00,l_master,next_yy,0,g_profit,0,0,0)                          #No.FUN-AB0068
                      #VALUES(l_aag00_1,l_aag01_1,next_yy,0,g_profit,0,0,0,g_legal)                #No.FUN-AB0068  #No.MOD-BA0147
                       VALUES(l_aag00_1,l_aag01_1,next_yy,0,g_profit*-1,0,0,0,g_legal)             #No.FUN-AB0068  #No.MOD-BA0147
         IF SQLCA.sqlcode THEN
           #CALL cl_err3("ins","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#12-1)",1)   #No.FUN-AB0068
            CALL cl_err3("ins","aah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#12-1)",1)  #No.FUN-AB0068
            LET g_success='N' RETURN
         END IF
      END IF
     #-CHI-D10004-add-
      IF g_aaz.aaz83 = 'Y' THEN
         LET g_profit = 0  
         SELECT SUM(tah05 - tah04) INTO g_profit 
           FROM tah_file,aag_file
          WHERE tah00 = l_aag00_1 
            AND tah02 = next_yy   
            AND tah03 = 0 
            AND tah08 = g_aaa.aaa03 
            AND tah00 = aag00 
            AND tah01 = aag01 
            AND aag08 = l_aag01_1       
            AND aag07 = '2'  
         IF cl_null(g_profit) THEN LET g_profit = 0 END IF 
         IF g_profit > 0 THEN
            INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                 tah05,tah06,tah07,tah08,tah09,
                                 tah10,tahlegal) 
                          VALUES(l_aag00_1,l_aag01_1,next_yy,0,0,
                                 g_profit,0,0,g_aaa.aaa03,0,
                                 g_profit,g_legal)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#24)",1) 
               LET g_success='N' 
               RETURN
            END IF
         ELSE
            INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                 tah05,tah06,tah07,tah08,tah09,
                                 tah10,tahlegal) 
                          VALUES(l_aag00_1,l_aag01_1,next_yy,0,g_profit*-1,
                                 0,0,0,g_aaa.aaa03,g_profit*-1,
                                 0,g_legal) 
            IF SQLCA.sqlcode THEN
              #CALL cl_err3("ins","tah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#25)",1)
               CALL cl_err3("ins","tah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#25)",1)
               LET g_success='N' 
               RETURN
            END IF
         END IF
      END IF
     #-CHI-D10004-end-
   END IF
  #MOD-980160---add---end---
  #MOD-D10019--Begin--
  #因ckp#7的程式段中只有把aaa14,aaa15,aaa16及aaa16的上層統制金額清空,但如果aaa15本身設為明細時其上層統制隔年的金額並不會被清為0
  #所以要取出aaa15的科目期末餘額(l_aaa15_d)後，將aaa15的上層統制科目次年初期扣除l_aaa15_d
  #如果統制的下層只有本期損益BS,需做期初的金額回扣
  #如果統制的下層除了本期損益BS，還含了累績盈虧 ,二個科目同時存在就不扣
  #直接以期未的金額結轉至次年期初
   SELECT aag08 INTO l_aaa15_master 
     FROM aag_file WHERE aag00 = pp_aaa00 
     AND aag01 = g_aaa15
     AND aag07 = '2'
   IF NOT cl_null(l_aaa15_master) THEN
      LET l_cnt_aaa15 = 0
      SELECT COUNT(*) INTO l_cnt_aaa15
        FROM aag_file
       WHERE aag08 = l_aaa15_master
         AND aag01 = g_aaa15
         AND aag07 = '2'
      IF cl_null(l_cnt_aaa15) THEN LET l_cnt_aaa15 = 0 END IF

      LET l_cnt_aaa16 = 0
      SELECT COUNT(*) INTO l_cnt_aaa16
        FROM aag_file
       WHERE aag08 = l_aaa15_master
         AND aag01 = g_aaa16
         AND aag07 = '2'
      IF cl_null(l_cnt_aaa16) THEN LET l_cnt_aaa16 = 0 END IF
      LET l_cnt = l_cnt_aaa15+l_cnt_aaa16
      IF l_cnt = 1 THEN 
         SELECT SUM(aah05-aah04) INTO l_aaa15_d FROM aah_file
          WHERE aah00 = pp_aaa00 
            AND aah01 = g_aaa15
            AND aah02 = last_yy
         IF cl_null(l_aaa15_d) THEN
             LET l_aaa15_d = 0 	
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM aah_file
          WHERE aah00 = l_aag00 AND aah01 = l_aaa15_master
            AND aah02 = next_yy AND aah03 = '0'
         IF l_cnt > 0 THEN
            IF l_aaa15_d > 0 THEN                 #增加判斷>0 or <0放在借方或貸方
               UPDATE aah_file SET aah05=aah05-l_aaa15_d
                WHERE aah00 = l_aag00 AND aah01 = l_aaa15_master
                  AND aah02 = next_yy AND aah03 = '0'
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=l_aag00,"/",l_aaa15_master,"/",next_yy
                     CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eoy:t#2.1)',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("upd","aah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:t#2.1)",1)
                  END IF
                  LET g_success='N' RETURN
               END IF
            ELSE
               UPDATE aah_file SET aah04=aah04-l_aaa15_d*-1
                WHERE aah00 = l_aag00 AND aah01 = l_aaa15_master
                  AND aah02 = next_yy AND aah03 = '0'
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=l_aag00,"/",l_aaa15_master,"/",next_yy
                     CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eoy:t#2.1)',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("upd","aah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:t#2.1)",1)
                  END IF
                  LET g_success='N' RETURN
               END IF
            END IF
         END IF
         IF g_aaz.aaz83 = 'Y' THEN
            SELECT SUM(tah05-tah04) INTO l_aaa15_tah_d
              FROM tah_file 
             WHERE tah00 = pp_aaa00
               AND tah01 = g_aaa15
               AND tah02 = last_yy
               AND tah08 = g_aaa.aaa03
            IF cl_null(l_aaa15_tah_d) THEN LET l_aaa15_tah_d = 0 END IF
            SELECT SUM(tah10-tah09) INTO l_aaa15_tah_d1
              FROM tah_file 
             WHERE tah00 = pp_aaa00
               AND tah01 = g_aaa15
               AND tah02 = last_yy
               AND tah08 = g_aaa.aaa03
            IF cl_null(l_aaa15_tah_d1) THEN LET l_aaa15_tah_d1 = 0 END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM tah_file
             WHERE tah00 = l_aag00 
               AND tah01 = l_aaa15_master
               AND tah02 = next_yy 
               AND tah03 = 0
               AND tah08 = g_aaa.aaa03 
            IF l_cnt > 0 THEN
               IF l_aaa15_tah_d > 0 THEN                 #增加判斷>0 or <0放在借方或貸方
                  UPDATE tah_file SET tah05=tah05-l_aaa15_tah_d
                   WHERE tah00 = l_aag00 
                     AND tah01 = l_aaa15_master
                     AND tah02 = next_yy 
                     AND tah03 = 0
                     AND tah08 = g_aaa.aaa03 
                  IF STATUS THEN
                     IF g_bgerr THEN
                        LET g_showmsg=l_aag00,"/",l_aaa15_master,"/",next_yy
                        CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#25)',SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#25)",1)
                     END IF
                     LET g_success='N' RETURN
                  END IF
               ELSE
                  UPDATE tah_file SET tah04=tah04-l_aaa15_tah_d*-1
                   WHERE tah00 = l_aag00
                     AND tah01 = l_aaa15_master
                     AND tah02 = next_yy 
                     AND tah03 = 0
                     AND tah08 = g_aaa.aaa03 
                  IF STATUS THEN
                     IF g_bgerr THEN
                        LET g_showmsg=l_aag00,"/",l_aaa15_master,"/",next_yy
                        CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#27)',SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#27)",1)
                     END IF
                     LET g_success='N' 
                     RETURN
                  END IF
               END IF
               IF l_aaa15_tah_d1 > 0 THEN                 #增加判斷>0 or <0放在借方或貸方
                  UPDATE tah_file SET tah10=tah10-l_aaa15_tah_d1
                   WHERE tah00 = l_aag00 
                     AND tah01 = l_aaa15_master
                     AND tah02 = next_yy 
                     AND tah03 = 0
                     AND tah08 = g_aaa.aaa03 
                  IF STATUS THEN
                     IF g_bgerr THEN
                        LET g_showmsg=l_aag00,"/",l_aaa15_master,"/",next_yy
                        CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#25)',SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#25)",1)
                     END IF
                     LET g_success='N' RETURN
                  END IF
               ELSE
                  UPDATE tah_file SET tah04=tah09-l_aaa15_tah_d1*-1
                   WHERE tah00 = l_aag00
                     AND tah01 = l_aaa15_master
                     AND tah02 = next_yy 
                     AND tah03 = 0
                     AND tah08 = g_aaa.aaa03 
                  IF STATUS THEN
                     IF g_bgerr THEN
                        LET g_showmsg=l_aag00,"/",l_aaa15_master,"/",next_yy
                        CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#27)',SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#27)",1)
                     END IF
                     LET g_success='N' 
                     RETURN
                  END IF
               END IF
            END IF
         END IF
      END IF
   END IF
  #MOD-D10019---End---
 ##MOD-D10019--Begin Mark--
 ##CHI-C30014--Begin--
 ##使用參數:帳別,tat03,tat04,結轉年度,次年年度
 # LET l_tat04 = " "
 # LET l_sql = "SELECT DISTINCT tat04 FROM tat_file "
 #            ," WHERE tat01 = '",pp_aaa00,"' AND tat02 = '",last_yy,"'"
 # DECLARE s_eoy_tat04_cs1 CURSOR FROM l_sql
 # FOREACH s_eoy_tat04_cs1 INTO l_tat04
 #    LET g_profit = 0
 #    LET l_sql = "SELECT SUM(aah05-aah04) FROM aah_file "
 #               ," WHERE aah00 = '",pp_aaa00,"' AND aah02 = '",last_yy,"'"
 #               ,"   AND aah01 = '",l_tat04,"'"             #CHI-C80020
 #              #CHI-C80020--Begin--
 #              #,"   AND aah01 IN ("
 #              #,"       SELECT tat03 FROM tat_file"
 #              #,"        WHERE tat01 = '",pp_aaa00,"' AND tat02 = '",last_yy,"'"
 #              #,"          AND tat04 = '",l_tat04,"') "
 #              #CHI-C80020---End---
 #    PREPARE s_eoy_tat04_p2 FROM l_sql
 #    DECLARE s_eoy_tat04_cs2 SCROLL CURSOR FOR s_eoy_tat04_p2
 #    OPEN s_eoy_tat04_cs2
 #    FETCH FIRST s_eoy_tat04_cs2 INTO g_profit
 #    IF g_profit IS NULL THEN LET g_profit = 0 END IF
 #    IF g_profit = 0 THEN CONTINUE FOREACH END IF
 #    IF g_chg = 'Y' THEN
 #       CALL s_tag(last_yy,pp_aaa00,l_tat04) RETURNING l_aag00,l_aag01
 #    ELSE
 #       LET l_aag00 = pp_aaa00
 #       LET l_aag01 = l_tat04 
 #    END IF
 #   #CHI-C80020--Begin--
 #   #LET l_sql = "SELECT SUM(aah05-aah04) FROM aah_file "
 #   #           ," WHERE aah00 = '",pp_aaa00,"' AND aah02 = '",next_yy,"'"
 #   #           ,"   AND aah01 = '",l_tat04,"'"
 #   #PREPARE s_eoy_tat04_p3 FROM l_sql
 #   #DECLARE s_eoy_tat04_cs3 SCROLL CURSOR FOR s_eoy_tat04_p3
 #   #OPEN s_eoy_tat04_cs3
 #   #FETCH FIRST s_eoy_tat04_cs3 INTO l_aah04
 #   #IF l_aah04 IS NULL THEN LET l_aah04 = 0 END IF
 #   #LET g_profit = g_profit + l_aah04
 #   #CHI-C80020---End---
 #    IF g_profit > 0 THEN                 #增加判斷>0 or <0放在借方或貸方
 #       {s_eoy:t#2.1}
 #       UPDATE aah_file SET aah05=aah05+g_profit
 #        WHERE aah00 = l_aag00 AND aah01 = l_tat04
 #          AND aah02 = next_yy AND aah03 = '0'
 #       IF STATUS THEN
 #          IF g_bgerr THEN
 #             LET g_showmsg=l_aag00,"/",l_tat04,"/",next_yy
 #             CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eoy:t#2.1)',SQLCA.sqlcode,1)
 #          ELSE
 #             CALL cl_err3("upd","aah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:t#2.1)",1)
 #          END IF
 #          LET g_success='N' RETURN
 #       END IF
 #       IF SQLCA.SQLERRD[3] = 0 THEN
 #          INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
 #                        VALUES(l_aag00,l_aag01,next_yy,0,0,g_profit,0,0,g_legal)
 #          IF SQLCA.sqlcode THEN
 #             IF g_bgerr THEN
 #               LET g_showmsg=l_aag00,'/',l_aag01
 #               CALL s_errmsg('aah00,aah01',g_showmsg,'(s_eoy:t#2.1)',SQLCA.sqlcode,1)
 #             ELSE
 #               CALL cl_err3("ins","aah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","s_eoy:t#2.1)",1)
 #             END IF
 #             LET g_success='N' RETURN
 #          END IF
 #       END IF
 #    ELSE
 #       {s_eoy:t#2.2}
 #       UPDATE aah_file SET aah04=aah04+g_profit*-1
 #        WHERE aah00 = l_aag00 AND aah01 = l_tat04
 #          AND aah02 = next_yy AND aah03 = '0'
 #       IF STATUS THEN
 #          IF g_bgerr THEN
 #             LET g_showmsg=l_aag00,"/",l_tat04,"/",next_yy
 #             CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eoy:t#2.1)',SQLCA.sqlcode,1)
 #          ELSE
 #             CALL cl_err3("upd","aah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:t#2.1)",1)
 #          END IF
 #          LET g_success='N' RETURN
 #       END IF
 #       IF SQLCA.SQLERRD[3] = 0 THEN
 #          INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
 #                        VALUES(l_aag00,l_aag01,next_yy,0,g_profit*-1,0,0,0,g_legal)
 #          IF SQLCA.sqlcode THEN
 #             IF g_bgerr THEN
 #               LET g_showmsg=l_aag00,"/",next_yy
 #               CALL s_errmsg('aah00,aah02',g_showmsg,'(s_eoy:t#2.2)',SQLCA.sqlcode,1)
 #             ELSE
 #               CALL cl_err3("ins","aah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","(s_eoy:t#2.2)",1)
 #             END IF
 #             LET g_success='N' RETURN
 #          END IF
 #       END IF
 #    END IF
 #   #-CHI-D10004-add-
 #    IF g_aaz.aaz83 = 'Y' THEN
 #       LET g_profit = 0
 #       LET l_sql = "SELECT SUM(tah05-tah04) ",
 #                   "  FROM tah_file ",
 #                   " WHERE tah00 = '",pp_aaa00,"'",
 #                   "   AND tah01 = '",l_tat04,"'",  
 #                   "   AND tah02 = '",last_yy,"'",
 #                   "   AND tah08 = '",g_aaa.aaa03,"'"  
 #       PREPARE s_eoy_tah_tat04_p2 FROM l_sql
 #       DECLARE s_eoy_tah_tat04_cs2 SCROLL CURSOR FOR s_eoy_tah_tat04_p2
 #       OPEN s_eoy_tah_tat04_cs2
 #       FETCH FIRST s_eoy_tah_tat04_cs2 INTO g_profit
 #       IF cl_null(g_profit) THEN LET g_profit = 0 END IF
 #       IF g_profit = 0 THEN CONTINUE FOREACH END IF
 #       IF g_chg = 'Y' THEN
 #          CALL s_tag(last_yy,pp_aaa00,l_tat04) RETURNING l_aag00,l_aag01
 #       ELSE
 #          LET l_aag00 = pp_aaa00
 #          LET l_aag01 = l_tat04 
 #       END IF
 #       IF g_profit > 0 THEN                 #增加判斷>0 or <0放在借方或貸方
 #          UPDATE tah_file 
 #             SET tah05 = tah05 + g_profit,
 #                 tah10 = tah10 + g_profit 
 #           WHERE tah00 = l_aag00 
 #             AND tah01 = l_tat04
 #             AND tah02 = next_yy 
 #             AND tah03 = 0
 #             AND tah08 = g_aaa.aaa03 
 #          IF STATUS THEN
 #             IF g_bgerr THEN
 #                LET g_showmsg=l_aag00,"/",l_tat04,"/",next_yy
 #                CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#25)',SQLCA.sqlcode,1)
 #             ELSE
 #                CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#25)",1)
 #             END IF
 #             LET g_success='N' RETURN
 #          END IF
 #          IF SQLCA.SQLERRD[3] = 0 THEN
 #             INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
 #                                  tah05,tah06,tah07,tah08,tah09,
 #                                  tah10,tahlegal)
 #                           VALUES(l_aag00,l_aag01,next_yy,0,0,
 #                                  g_profit,0,0,g_aaa.aaa03,0,
 #                                  g_profit,g_legal)
 #             IF SQLCA.sqlcode THEN
 #                IF g_bgerr THEN
 #                  LET g_showmsg=l_aag00,'/',l_aag01
 #                  CALL s_errmsg('tah00,tah01',g_showmsg,'(s_eoy:ckp#26)',SQLCA.sqlcode,1)
 #                ELSE
 #                  CALL cl_err3("ins","tah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","s_eoy:ckp#26)",1)
 #                END IF
 #                LET g_success='N' 
 #                RETURN
 #             END IF
 #          END IF
 #       ELSE
 #          UPDATE tah_file 
 #             SET tah04 = tah04 + g_profit * -1,
 #                 tah09 = tah09 + g_profit * -1 
 #           WHERE tah00 = l_aag00 
 #             AND tah01 = l_tat04
 #             AND tah02 = next_yy 
 #             AND tah03 = 0
 #             AND tah08 = g_aaa.aaa03 
 #          IF STATUS THEN
 #             IF g_bgerr THEN
 #                LET g_showmsg=l_aag00,"/",l_tat04,"/",next_yy
 #                CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#27)',SQLCA.sqlcode,1)
 #             ELSE
 #                CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#27)",1)
 #             END IF
 #             LET g_success='N' 
 #             RETURN
 #          END IF
 #          IF SQLCA.SQLERRD[3] = 0 THEN
 #             INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
 #                                  tah05,tah06,tah07,tah08,tah09,
 #                                  tah10,tahlegal)
 #                           VALUES(l_aag00,l_aag01,next_yy,0,g_profit*-1,
 #                                  0,0,0,g_aaa.aaa03,g_profit*-1,
 #                                  0,g_legal)
 #             IF SQLCA.sqlcode THEN
 #                IF g_bgerr THEN
 #                  LET g_showmsg=l_aag00,"/",next_yy
 #                  CALL s_errmsg('tah00,tah02',g_showmsg,'(s_eoy:ckp#28)',SQLCA.sqlcode,1)
 #                ELSE
 #                  CALL cl_err3("ins","tah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","(s_eoy:ckp#28)",1)
 #                END IF
 #                LET g_success='N' 
 #                RETURN
 #             END IF
 #          END IF
 #       END IF
 #    END IF
 #   #-CHI-D10004-end-
 #   #統制科目金額計算
 #    SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = l_tat04 AND aag00 = pp_aaa00
 #    LET l_flag = 'Y'
 #    IF l_master IS NULL THEN RETURN END IF
 #    IF l_master = l_tat04 THEN LET l_flag = 'N' END IF
 #    IF g_chg = 'Y' THEN
 #       CALL s_tag(last_yy,pp_aaa00,l_master) RETURNING l_aag00_1,l_aag01_1
 #    ELSE
 #       LET l_aag00_1 = pp_aaa00
 #       LET l_aag01_1 = l_master
 #    END IF
 #    IF l_aag00 = l_aag00_1 AND l_aag01 = l_aag01_1 THEN
 #       LET l_flag = 'N'
 #    END IF
 #    IF l_flag = 'Y' THEN
 #       LET l_aah04 = 0
 #       MESSAGE "ins aah:",l_master
 #       SELECT SUM(aah05 - aah04) INTO g_profit FROM aah_file,aag_file
 #       WHERE aah00 = l_aag00_1 AND aah02 = next_yy
 #         AND aah03 = 0 AND aag08 = l_aag01_1
 #         AND aah00 = aag00 AND aah01 = aag01 AND aag07 = '2' 
 #       IF g_profit IS NULL THEN LET g_profit = 0 END IF
 
 #       LET l_sql = "SELECT SUM(aah05-aah04) FROM aah_file,aag_file "
 #                  ," WHERE aah00 = '",l_aag00_1,"' AND aah02 = '",next_yy,"'"
 #                  ,"   AND aah03 = 0 AND aag08 = '",l_aag00_1,"'"
 #                  ,"   AND aah00 = aag00 AND aah01 = aag01 AND aag07 = '2'"
 #       PREPARE s_eoy_tat04_p4 FROM l_sql
 #       DECLARE s_eoy_tat04_cs4 SCROLL CURSOR FOR s_eoy_tat04_p4
 #       OPEN s_eoy_tat04_cs4
 #       FETCH FIRST s_eoy_tat04_cs4 INTO l_aah04
 #       IF l_aah04 IS NULL THEN LET l_aah04 = 0 END IF
 #       LET g_profit = g_profit + l_aah04

 #       IF g_profit > 0 THEN 
 #          {s_eoy:t#3.1}
 #          UPDATE aah_file SET aah05=aah05+g_profit
 #           WHERE aah00 = l_aag00_1 AND aah01 =  l_aag01_1
 #             AND aah02 = next_yy AND aah03 = '0'
 #          IF STATUS THEN
 #             IF g_bgerr THEN
 #                LET g_showmsg=l_aag00_1,"/", l_aag01_1,"/",next_yy
 #                CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eoy:t#3.1)',SQLCA.sqlcode,1)
 #             ELSE
 #                CALL cl_err3("upd","aah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:t#3.1)",1)
 #             END IF
 #             LET g_success='N' RETURN
 #          END IF
 #          IF SQLCA.SQLERRD[3] = 0 THEN
 #             INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
 #                           VALUES(l_aag00_1,l_aag01_1,next_yy,0,0,g_profit,0,0,g_legal)
 #             IF SQLCA.sqlcode THEN
 #                CALL cl_err3("ins","aah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:t#3.1)",1)
 #                LET g_success='N' RETURN
 #             END IF
 #          END IF
 #       ELSE
 #          {s_eoy:t#3.2}
 #          UPDATE aah_file SET aah04=aah04+g_profit*-1
 #           WHERE aah00 = l_aag00_1 AND aah01 =  l_aag01_1
 #             AND aah02 = next_yy AND aah03 = '0'
 #          IF STATUS THEN
 #             IF g_bgerr THEN
 #                LET g_showmsg=l_aag00_1,"/", l_aag01_1,"/",next_yy
 #                CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eoy:t#3.2)',SQLCA.sqlcode,1)
 #             ELSE
 #                CALL cl_err3("upd","aah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:t#3.2)",1)
 #             END IF
 #             LET g_success='N' RETURN
 #          END IF
 #          IF SQLCA.SQLERRD[3] = 0 THEN
 #             INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
 #                           VALUES(l_aag00_1,l_aag01_1,next_yy,0,g_profit*-1,0,0,0,g_legal)
 #             IF SQLCA.sqlcode THEN
 #                CALL cl_err3("ins","aah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:t#3.2)",1)
 #                LET g_success='N' RETURN
 #             END IF
 #          END IF
 #       END IF
 #      #-CHI-D10004-add-
 #       IF g_aaz.aaz83 = 'Y' THEN
 #          LET l_aah04 = 0
 #          LET g_profit = 0
 #          SELECT SUM(tah05 - tah04) INTO g_profit 
 #            FROM tah_file,aag_file
 #           WHERE tah00 = l_aag00_1 
 #             AND tah02 = next_yy
 #             AND tah03 = 0 
 #             AND tah00 = aag00 
 #             AND tah01 = aag01 
 #             AND tah08 = g_aaa.aaa03 
 #             AND aag08 = l_aag01_1
 #             AND aag07 = '2' 
 #          IF cl_null(g_profit) THEN LET g_profit = 0 END IF
 #         
 #          LET l_sql = "SELECT SUM(tah05-tah04) ",
 #                      "  FROM tah_file,aag_file ",
 #                      " WHERE tah00 = '",l_aag00_1,"'",
 #                      "   AND tah02 = '",next_yy,"'",
 #                      "   AND tah03 = 0 ",
 #                      "   AND tah08 = '",g_aaa.aaa03,"'",
 #                      "   AND tah00 = aag00 ",
 #                      "   AND tah01 = aag01 ",
 #                      "   AND aag08 = '",l_aag00_1,"'",
 #                      "   AND aag07 = '2'"
 #          PREPARE s_eoy_tah_tat04_p4 FROM l_sql
 #          DECLARE s_eoy_tah_tat04_cs4 SCROLL CURSOR FOR s_eoy_tah_tat04_p4
 #          OPEN s_eoy_tah_tat04_cs4
 #          FETCH FIRST s_eoy_tah_tat04_cs4 INTO l_aah04
 #          IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
 #          LET g_profit = g_profit + l_aah04
 #         
 #          IF g_profit > 0 THEN 
 #             UPDATE tah_file 
 #                SET tah05 = tah05 + g_profit,
 #                    tah10 = tah10 + g_profit 
 #              WHERE tah00 = l_aag00_1 
 #                AND tah01 = l_aag01_1
 #                AND tah02 = next_yy 
 #                AND tah03 = 0
 #                AND tah08 = g_aaa.aaa03 
 #             IF STATUS THEN
 #                IF g_bgerr THEN
 #                   LET g_showmsg=l_aag00_1,"/", l_aag01_1,"/",next_yy
 #                   CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#29)',SQLCA.sqlcode,1)
 #                ELSE
 #                   CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#29)",1)
 #                END IF
 #                LET g_success='N' RETURN
 #             END IF
 #             IF SQLCA.SQLERRD[3] = 0 THEN
 #                INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
 #                                     tah05,tah06,tah07,tah08,tah09,
 #                                     tah10,tahlegal)
 #                              VALUES(l_aag00_1,l_aag01_1,next_yy,0,0,
 #                                     g_profit,0,0,g_aaa.aaa03,
 #                                     g_profit,g_legal)
 #                IF SQLCA.sqlcode THEN
 #                   CALL cl_err3("ins","tah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#30)",1)
 #                   LET g_success='N' 
 #                   RETURN
 #                END IF
 #             END IF
 #          ELSE
 #             UPDATE tah_file 
 #                SET tah04 = tah04 + g_profit * -1,
 #                    tah09 = tah09 + g_profit * -1 
 #              WHERE tah00 = l_aag00_1 
 #                AND tah01 = l_aag01_1
 #                AND tah02 = next_yy 
 #                AND tah03 = 0
 #                AND tah08 = g_aaa.aaa03 
 #             IF STATUS THEN
 #                IF g_bgerr THEN
 #                   LET g_showmsg=l_aag00_1,"/", l_aag01_1,"/",next_yy
 #                   CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eoy:ckp#31)',SQLCA.sqlcode,1)
 #                ELSE
 #                   CALL cl_err3("upd","tah_file",l_aag00,l_tat04,STATUS,"","(s_eoy:ckp#31)",1)
 #                END IF
 #                LET g_success='N' 
 #                RETURN
 #             END IF
 #             IF SQLCA.SQLERRD[3] = 0 THEN
 #                INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
 #                                     tah05,tah06,tah07,tah08,tah09,
 #                                     tah10,tahlegal)
 #                              VALUES(l_aag00_1,l_aag01_1,next_yy,0,g_profit*-1,
 #                                     0,0,0,g_aaa.aaa03,g_profit*-1,
 #                                     0,g_legal)
 #                IF SQLCA.sqlcode THEN
 #                   CALL cl_err3("ins","tah_file",l_aag00_1,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#32)",1)
 #                   LET g_success='N' 
 #                   RETURN
 #                END IF
 #             END IF
 #          END IF
 #       END IF
 #      #-CHI-D10004-end-
 #    END IF
 # END FOREACH
 ##CHI-C30014---End---
 ##MOD-D10019---End Mark---
END FUNCTION
FUNCTION s_eoy_aax_close()
   DEFINE l_y,l_m     LIKE type_file.num5         #No.FUN-680098   smallint
     IF g_aaz.aaz79 = '2'
        THEN LET l_y = 0       LET l_m = 0
        ELSE LET l_y = last_yy
             IF g_aza.aza02 = '1'
                THEN LET l_m = 12
                ELSE LET l_m = 13
             END IF
     END IF
#        MESSAGE "del aah"
#{ckp#8}DELETE FROM aah_file                                                    # 3220 detail
#           WHERE aah00 = pp_aaa00 AND aah02 = next_yy AND aah03=0 AND aah01 IN
#                 (SELECT aaw05 FROM aaw_file WHERE aaw01=l_y AND aaw02=l_m)
#{ckp#8}DELETE FROM aah_file                                                    # 3220 master
#           WHERE aah00 = pp_aaa00 AND aah02 = next_yy AND aah03=0 AND aah01 IN
#                 (SELECT aag08 FROM aaw_file,aag_file
#                         WHERE aaw01=l_y AND aaw02=l_m and aaw05=aag01)
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('(s_eoy:ckp#7)',SQLCA.sqlcode,1)
#            LET g_success='N' RETURN
#        END IF
     DECLARE eoy_cs2 CURSOR FOR 
        SELECT aaw03,aaw04,aaw05 FROM aaw_file WHERE aaw01=l_y AND aaw02=l_m
#     FOREACH eoy_cs2 INTO g_aaz31,g_aaz32,g_aaz33  #FUN-BC0027
      FOREACH eoy_cs2 INTO g_aaa14,g_aaa15,g_aaa16  #FUN-BC0027
        #將去年度的本期損益3219累加到次年度的累計盈虧3220
        #modify 92/08/13 需再將前一年度的3220 也就是上上年的結轉加入本年度中
#       MESSAGE "sum aah:",g_aaz32  #FUN-BC0027
        MESSAGE "sum aah:",g_aaa15  #FUN-BC0027
        SELECT SUM(aah05-aah04) INTO g_profit FROM aah_file   # 3219
#              WHERE aah00 = pp_aaa00 AND aah01 = g_aaz32 AND aah02 = last_yy #FUN-BC0027
               WHERE aah00 = pp_aaa00 AND aah01 = g_aaa15 AND aah02 = last_yy #FUN-BC0027
        IF g_profit IS NULL THEN LET g_profit = 0 END IF
        #轉入前年損益科目中
#-----------------------------------------------------------------------------
#       MESSAGE "ins aah:",g_aaz33  #FUN-BC0027
        MESSAGE "ins aah:",g_aaa16  #FUN-BC0027
         IF g_profit > 0 THEN          #No.MOD-520041 add >0 or <0的判斷
          INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
#               VALUES(pp_aaa00,g_aaz33,next_yy,0,0,g_profit,0,0,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa00,g_aaa16,next_yy,0,0,g_profit,0,0,g_legal)  #FUN-BC0027
         #IF SQLCA.sqlcode = -239 THEN #TQC-790102
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
             UPDATE aah_file SET aah05 = aah05 + g_profit
#               WHERE aah00 = pp_aaa00 AND aah01 = g_aaz33  #FUN-BC0027
                WHERE aah00 = pp_aaa00 AND aah01 = g_aaa16  #FUN-BC0027
                  AND aah02 = next_yy AND aah03 = 0
          END IF
          IF SQLCA.sqlcode THEN
#            CALL cl_err('(s_eoy:ckp#11)',SQLCA.sqlcode,1)  # NO.FUN-660123
             CALL cl_err3("ins","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#11)",1)   # NO.FUN-660123
             LET g_success='N' RETURN
          END IF
        ELSE
          INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
#               VALUES(pp_aaa00,g_aaz33,next_yy,0,g_profit,0,0,0,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa00,g_aaa16,next_yy,0,g_profit,0,0,0,g_legal) #FUN-BC0027
         #IF SQLCA.sqlcode = -239 THEN #TQC-790102
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
             UPDATE aah_file SET aah04 = aah04 + g_profit
#               WHERE aah00 = pp_aaa00 AND aah01 = g_aaz33  #FUN-BC0027
                WHERE aah00 = pp_aaa00 AND aah01 = g_aaa16  #FUN-BC0027
                  AND aah02 = next_yy AND aah03 = 0
          END IF
          IF SQLCA.sqlcode THEN
#            CALL cl_err('(s_eoy:ckp#11)-1',SQLCA.sqlcode,1) # NO.FUN-660123
             CALL cl_err3("ins","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#11)-1",1)   # NO.FUN-660123 
             LET g_success='N' RETURN
          END IF
        END IF
#-----------------------------------------------------------------------------
#       SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz33  #FUN-BC0027
        SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa16  #FUN-BC0027
#       IF l_master IS NOT NULL AND l_master != g_aaz33 THEN  #FUN-BC0027
        IF l_master IS NOT NULL AND l_master != g_aaa16 THEN  #FUN-BC0027
           MESSAGE "ins aah:",l_master
            IF g_profit > 0 THEN                   #No.MOD-520041
             INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
                   VALUES(pp_aaa00,l_master,next_yy,0,0,g_profit,0,0,g_legal)
            #IF SQLCA.sqlcode = -239 THEN             #TQC-790102
             IF cl_sql_dup_value(SQLCA.SQLCODE)  THEN #TQC-790102
                UPDATE aah_file SET aah05 = aah05 + g_profit
                   WHERE aah00 = pp_aaa00 AND aah01 = l_master
                     AND aah02 = next_yy AND aah03 = 0
             END IF
             IF SQLCA.sqlcode THEN
#               CALL cl_err('(s_eoy:ckp#12)',SQLCA.sqlcode,1) # NO.FUN-660123
                CALL cl_err3("ins","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#12)",1)   # NO.FUN-660123
                LET g_success='N' RETURN
             END IF
           ELSE             
             INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal) #FUN-980003 add aahlegal
                   VALUES(pp_aaa00,l_master,next_yy,0,g_profit,0,0,0,g_legal) #FUN-980003 add g_legal
            #IF SQLCA.sqlcode = -239 THEN #TQC-790102
             IF cl_sql_dup_value(SQLCA.SQLCODE)  THEN #TQC-790102
                UPDATE aah_file SET aah04 = aah04 + g_profit
                   WHERE aah00 = pp_aaa00 AND aah01 = l_master
                     AND aah02 = next_yy AND aah03 = 0
             END IF
             IF SQLCA.sqlcode THEN
#               CALL cl_err('(s_eoy:ckp#12-1)',SQLCA.sqlcode,1) # NO.FUN-660123
                CALL cl_err3("ins","aah_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#12-1)",1)  # NO.FUN-660123
                LET g_success='N' RETURN
             END IF
           END IF
        END IF
#-----------------------------------------------------------------------------
    END FOREACH
END FUNCTION

#No.FUN-AB0068  --Begin
FUNCTION s_eoy_del_aaz_acount(p_aag00,p_aag01)
   DEFINE p_aag00      LIKE aag_file.aag00
   DEFINE p_aag01      LIKE aag_file.aag01
   DEFINE l_aag00      LIKE aag_file.aag00
   DEFINE l_aag01      LIKE aag_file.aag01

   CALL s_tag(last_yy,p_aag00,p_aag01) RETURNING l_aag00,l_aag01
   DELETE FROM aah_file 
    WHERE aah00 = l_aag00 AND aah02 = next_yy AND aah03 = 0
      AND aah01 = l_aag01
   IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
         LET g_showmsg=l_aag00,'/',l_aag01,'/',next_yy,'/0'
         CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'s_eoy_del_aaz_account:delete aah',SQLCA.sqlcode,1)
       ELSE
         CALL cl_err3("del","aah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","s_eoy_del_aaz_account:delete aah",1)
       END IF
       LET g_success='N' RETURN
   END IF
  #-CHI-D10004-add-
   IF g_aaz.aaz83 = 'Y' THEN
      DELETE FROM tah_file 
       WHERE tah00 = l_aag00 
         AND tah01 = l_aag01
         AND tah02 = next_yy 
         AND tah03 = 0
         AND tah08 = g_aaa.aaa03 
      IF SQLCA.sqlcode THEN
          IF g_bgerr THEN
            LET g_showmsg=l_aag00,'/',l_aag01,'/',next_yy,'/0'
            CALL s_errmsg('tah00,tah01,tah02,tah03',g_showmsg,'s_eoy_del_aaz_account:delete tah',SQLCA.sqlcode,1)
          ELSE
            CALL cl_err3("del","tah_file",l_aag00,l_aag01,SQLCA.sqlcode,"","s_eoy_del_aaz_account:delete tah",1)
          END IF
          LET g_success='N' 
          RETURN
      END IF
   END IF
  #-CHI-D10004-end-
END FUNCTION
#No.FUN-AB0068  --End  
