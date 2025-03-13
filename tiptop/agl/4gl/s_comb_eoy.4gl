# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
# Modify.........: No.MOD-770124 07/07/27 By Smapmin 新增時多新增axh12
# Modify.........: No.TQC-850001 08/05/05 By Carrier TQC-840012 追單
# Modify.........: No.MOD-930076 09/03/06 By lilingyu 合并后科目余額年結,產生累積盈虧科目,不應
# .................                           直接給執行當站之本幣幣別g_aza.aza17   
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
DEFINE    g_profit  LIKE axh_file.axh08,
          l_axh09   LIKE axh_file.axh09,
          g_y_sum   LIKE axh_file.axh08, 
          l_axh05   LIKE axh_file.axh05,
          l_master  LIKE axh_file.axh05,
          next_yy   LIKE aaa_file.aaa04,        # This Year Ex:1990
          l_aag04   LIKE aag_file.aag04,
#FUN-BC0027 --begin--
#         g_aaz31   LIKE aaz_file.aaz31,
#         g_aaz32   LIKE aaz_file.aaz32,
#         g_aaz33   LIKE aaz_file.aaz33,
          g_aaa14   LIKE aaa_file.aaa14,
          g_aaa15   LIKE aaa_file.aaa15,
          g_aaa16   LIKE aaa_file.aaa16,
          g_aaa     RECORD LIKE aaa_file.* ,
#FUN-BC0027 --end--          
          l_aed05   LIKE aed_file.aed05,
          l_aed06   LIKE aed_file.aed06,
          l_aed01   LIKE aed_file.aed01,
          l_aed011  LIKE aed_file.aed011,
          l_aed02   LIKE aed_file.aed02,
          l_str     LIKE type_file.chr21,        #No.FUN-680098 VARCHAR(21)
          l_cnt     LIKE type_file.num5          #No.FUN-680098 smallint
  DEFINE  pp_aaa00  LIKE aaa_file.aaa01,
          last_yy   LIKE aaa_file.aaa04                 # Last Year Ex:1989

FUNCTION s_comb_eoy(p_aaa00,p_aaa04)                                 #年結
  DEFINE  p_aaa00   LIKE aaa_file.aaa01,
          p_aaa04   LIKE aaa_file.aaa04                 # Last Year Ex:1989
  DEFINE  p_row,p_col LIKE type_file.num5          #No.FUN-680098 smallint
     WHENEVER ERROR CONTINUE
     SET LOCK  MODE  TO WAIT
     LET pp_aaa00 = p_aaa00
     LET last_yy  = p_aaa04
     LET next_yy  = last_yy + 1
     DISPLAY 'next:',next_yy AT 4,1
     IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
          LET p_row = 18 LET p_col = 40
     ELSE LET p_row = 18 LET p_col = 26
     END IF
     OPEN WINDOW eoy_g_w AT p_row,p_col 
               WITH 5 rows, 30 COLUMNS 
     CALL cl_getmsg('agl-036',g_lang) RETURNING l_str
     DISPLAY l_str at 3,6 
    
     SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = pp_aaa00   #FUN-BC0027
    
     WHILE TRUE
        CALL s_eoy_del_next_year()
        IF g_success = 'N' THEN EXIT WHILE END IF
        CALL s_eoy_mv_next_year()
        IF g_success = 'N' THEN EXIT WHILE END IF
        CALL s_eoy_aay_close()
        IF g_success = 'N' THEN EXIT WHILE END IF
        EXIT WHILE
     END WHILE
     CLOSE WINDOW eoy_g_w
END FUNCTION
FUNCTION s_eoy_del_next_year()
    #將次年度期別為零的所有會計科目的資料刪除
        MESSAGE "delete next year's axh!"
{ckp#1} DELETE FROM axh_file 
            WHERE  axh00 = pp_aaa00 AND axh06 = next_yy AND axh07 = 0
        IF SQLCA.sqlcode THEN
#          CALL cl_err('(s_eoy:ckp#1)',SQLCA.sqlcode,1) # NO.FUN-660123
           CALL cl_err3("del","axh_file",pp_aaa00,next_yy,SQLCA.sqlcode,"","(s_eoy:ckp#1)",1)  # NO.FUN-660123 
           LET g_success='N' RETURN
        END IF
        MESSAGE "delete next year's aed!"
END FUNCTION
FUNCTION s_eoy_mv_next_year()   # 請注意--->虛帳戶不需作結轉
  DEFINE l_sql LIKE type_file.chr1000      #No.FUN-680098   VARCHAR(500)
#----------------------------------------------------------------------
     MESSAGE "move to next year's axh!"
     DROP TABLE x1
     LET l_sql = 
   " SELECT axh00,axh01,axh02,axh03,axh04,axh041,axh05,",next_yy," h2,",
   #"        0 h3,sum(axh08-axh09) h4,0 h5,0 h6,0 h7",   #MOD-770124
   "        0 h3,sum(axh08-axh09) h4,0 h5,0 h6,0 h7,axh12,axh13,axhlegal",   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
   "          FROM axh_file, aag_file ",
   "         WHERE axh00 = '",pp_aaa00,"' AND axh06 =",last_yy,
   "           AND axh05 = aag01 ",
   "           AND axh00 = aag00 ",      #No.FUN-740020
   "           AND aag03 = '2' AND aag04 = '1' AND aag06 = '1' ",
   #" GROUP BY axh00,axh01,axh02,axh03,axh04,axh041,axh05 ",   #MOD-770124
   " GROUP BY axh00,axh01,axh02,axh03,axh04,axh041,axh05,axh12,axh13,axhlegal ",   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
   "         INTO TEMP x1 "
     PREPARE pre_x1 FROM l_sql
     EXECUTE pre_x1
        IF SQLCA.sqlcode THEN
           CALL cl_err('(s_eoy:ckp#3.1)',SQLCA.sqlcode,1) 
            LET g_success='N' RETURN
        END IF
    INSERT INTO axh_file(axh00,axh01,axh02,axh03,axh04,axh041,axh05,
                         #axh06,axh07,axh08,axh09,axh10,axh11)   #MOD-770124
                         axh06,axh07,axh08,axh09,axh10,axh11,axh12,axh13,axhlegal)   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
          SELECT * FROM x1 where h4 != 0
        IF SQLCA.sqlcode THEN
#           CALL cl_err('(s_eoy:ckp#3.11)',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("ins","axh_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.11)",1)   #No.FUN-660123  
            LET g_success='N' RETURN
        END IF
#----------------------------------------------------------------------
     DROP TABLE x2
    LET l_sql = 
  " SELECT axh00,axh01,axh02,axh03,axh04,axh041,axh05,",next_yy," h2,",
  #"        0 h3,0 h4,sum(axh09-axh08) h5,0 h6,0 h7 ",   #MOD-770124
  "        0 h3,0 h4,sum(axh09-axh08) h5,0 h6,0 h7,axh12,axh13,axhlegal ",   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
  "           FROM axh_file, aag_file ",
  "          WHERE axh00 = '",pp_aaa00,"' AND axh06 = ",last_yy,
  "            AND axh05 = aag01 ",
   "           AND axh00 = aag00 ",      #No.FUN-740020
  "            AND aag03 = '2' AND aag04 = '1' AND aag06 = '2' ",
  #"   GROUP BY axh00,axh01,axh02,axh03,axh04,axh041,axh05 ",   #MOD-770124
  "   GROUP BY axh00,axh01,axh02,axh03,axh04,axh041,axh05,axh12,axh13,axhlegal ",   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
  "          INTO TEMP x2 "
    PREPARE pre_x2 FROM l_sql
    EXECUTE pre_x2
        IF SQLCA.sqlcode THEN
          CALL cl_err('(s_eoy:ckp#3.2)',SQLCA.sqlcode,1)  
            LET g_success='N' RETURN
        END IF
    INSERT INTO axh_file(axh00,axh01,axh02,axh03,axh04,axh041,axh05,
                         #axh06,axh07,axh08,axh09,axh10,axh11)   #MOD-770124
                         axh06,axh07,axh08,axh09,axh10,axh11,axh12,axh13,axhlegal)   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
          SELECT * FROM x2 where h5 != 0
        IF SQLCA.sqlcode THEN
#           CALL cl_err('(s_eoy:ckp#3.12)',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("ins","axh_file","","",SQLCA.sqlcode,"","(s_eoy:ckp#3.12)",1)   #No.FUN-660123  
            LET g_success='N' RETURN
        END IF
#----------------------------------------------------------------------
END FUNCTION
FUNCTION s_eoy_aay_close()
DEFINE  l_sql       LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(600)
        g_axh00     LIKE axh_file.axh00,
        g_axh01     LIKE axh_file.axh01,
        g_axh02     LIKE axh_file.axh02,
        g_axh03     LIKE axh_file.axh03,
        g_axh04     LIKE axh_file.axh04,
        g_axh041    LIKE axh_file.axh041
DEFINE  g_axh13     LIKE axh_file.axh13   #No.TQC-850001
DEFINE  g_axh12     LIKE axh_file.axh12   #MOD-930076

#FUN-BC0027 --begin--
#        LET g_aaz31 = g_aaz.aaz31 CLIPPED #本期損益
#        LET g_aaz32 = g_aaz.aaz32 CLIPPED #本期資產
#        LET g_aaz33 = g_aaz.aaz33 CLIPPED #前年損益調整科目

        LET g_aaa14 = g_aaa.aaa14 CLIPPED #本期損益
        LET g_aaa15 = g_aaa.aaa15 CLIPPED #本期資產
        LET g_aaa16 = g_aaa.aaa16 CLIPPED #前年損益調整科目
#FUN-BC0027 --end--

        LET l_axh05 = 0
  LET l_sql=" SELECT axh00,axh01,axh02,axh03,axh04,axh041,axh13,axh12 ",  #No.TQC-850001 #MOD-930076 add axh12
            " FROM axh_file ",
            " WHERE axh06 = last_yy ",                                                   #MOD-930076 add  
            " GROUP BY axh00,axh01,axh02,axh03,axh04,axh041,axh13,axh12 "  #No.TQC-850001  #MOD-930076 add axh12
  PREPARE p004_axh_p FROM l_sql
  IF STATUS THEN CALL cl_err('prepare:1',STATUS,1)         
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM 
  END IF
  DECLARE p004_axh_c CURSOR FOR p004_axh_p
  FOREACH p004_axh_c INTO g_axh00,g_axh01,g_axh02,g_axh03,g_axh04,g_axh041,g_axh13,g_axh12   #No.TQC-850001  #MOD-930076 add g_axh12
#NO.FUN-710023--BEGIN                                                           
     IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
     END IF                                                     
#NO.FUN-710023--END 
  IF SQLCA.SQLCODE THEN
#    CALL cl_err('for_axh_c:',STATUS,1) LET g_success = 'N' RETURN #NO.FUN-710023
#NO.FUN-710023--BEGIN
     IF g_bgerr THEN
         CALL s_errmsg(' ',' ','for_axh_c:',STATUS,1) LET g_success = 'N' EXIT FOREACH
     ELSE
         CALL cl_err('for_axh_c:',STATUS,1) LET g_success = 'N' RETURN
     END IF
#NO.FUN-710023--END 
  END IF
        #直接將本期損益的期初餘額給零(因為將其餘額轉入前年損益調整科目中)
#       MESSAGE "del axh:",g_aaz31  #FUN-BC0027
        MESSAGE "del axh:",g_aaa14  #FUN-BC0027
{ckp#7} DELETE FROM axh_file
           WHERE axh00 = pp_aaa00 AND axh06 = next_yy AND axh07 = 0
#            AND (axh05 = g_aaz31 OR axh05 = g_aaz32  OR axh05 = g_aaz33 ) #FUN-BC0027
             AND (axh05 = g_aaa14 OR axh05 = g_aaa15  OR axh05 = g_aaa16 ) #FUN-BC0027
             AND axh01=g_axh01 AND axh02=g_axh02 AND axh03=g_axh03
             AND axh04=g_axh04 AND axh041=g_axh041
             AND axh13=g_axh13   #No.TQC-850001
             AND axh12=g_axh12   #MOD-930076 add
        IF SQLCA.sqlcode THEN
#          CALL cl_err('(s_eoy:ckp#4.2)',SQLCA.sqlcode,1) # NO.FUN-660123
#          CALL cl_err3("del","axh_file",g_axh01,g_axh02,SQLCA.sqlcode,"","(s_eoy:ckp#4.2)",1)  # NO.FUN-660123    #NO.FUN-710023
#NO.FUN-710023--BEGIN
           IF g_bgerr THEN
              LET g_showmsg=pp_aaa00,"/",next_yy,"/",'0',"/",g_axh01,"/",g_axh02,
                       "/",g_axh03,"/",g_axh04,"/",g_axh041,"/",g_axh13  #No.TQC-850001
              CALL s_errmsg('axh00,axh06,axh07,axh01,axh02,axh04,axh041,axh13',g_showmsg,'(s_eoy:ckp#4.2)',SQLCA.sqlcode,1)  #No.TQC-850001
           ELSE
              CALL cl_err3("del","axh_file",g_axh01,g_axh02,SQLCA.sqlcode,"","(s_eoy:ckp#4.2)",1) 
           END IF
#            LET g_success='N' RETURN
             LET g_success='N' CONTINUE FOREACH
#NO.FUN-710023--END  
        END IF
        #將去年度的損益類科目3218結轉到次年度的3220
        #modify 92/08/13 需再將前一年度的3220 也就是上上年的結轉加入本年度中
#        MESSAGE "sum axh:",g_aaz33 #FUN-BC0027
         MESSAGE "sum axh:",g_aaa16 #FUN-BC0027
        SELECT SUM(axh09-axh08) INTO g_profit FROM axh_file   # 3218
               WHERE axh00 = pp_aaa00 
#                AND axh05 = g_aaz32  #FUN-BC0027
                 AND axh05 = g_aaa15  #FUN-BC0027
                 AND axh06 = last_yy
                 AND axh01=g_axh01 AND axh02=g_axh02 AND axh03=g_axh03
                 AND axh04=g_axh04 AND axh041=g_axh041
                 AND axh13=g_axh13   #No.TQC-850001
                 AND axh12=g_axh12   #MOD-930076
        IF g_profit IS NULL THEN LET g_profit = 0 END IF
        SELECT SUM(axh09-axh08) INTO g_y_sum FROM axh_file # 3220
               WHERE axh00 = pp_aaa00 
#                AND axh05 = g_aaz33   #FUN-BC0027
                 AND axh05 = g_aaa16   #FUN-BC0027
                 AND axh06 = last_yy
                 AND axh01=g_axh01 AND axh02=g_axh02 AND axh03=g_axh03
                 AND axh04=g_axh04 AND axh041=g_axh041
                 AND axh13=g_axh13   #No.TQC-850001
                 AND axh12=g_axh12   #MOD-930076
        IF g_y_sum IS NULL THEN LET g_y_sum = 0 END IF
        LET g_profit = g_profit + g_y_sum
        #轉入前年損益科目中
#       MESSAGE "ins axh:",g_aaz33 #FUN-BC0027
        MESSAGE "ins axh:",g_aaa16 #FUN-BC0027
        INSERT INTO axh_file(axh00,axh01,axh02,axh03,axh04,axh041,axh05,
                             #axh06,axh07,axh08,axh09,axh10,axh11)   #MOD-770124
                             axh06,axh07,axh08,axh09,axh10,axh11,axh12,axh13,axhlegal)   #MOD-770124  #No.TQC-850001 #FUN-980003 add axhlegal
              VALUES(pp_aaa00,g_axh01,g_axh02,g_axh03,g_axh04,g_axh041,
                     #g_aaz33,next_yy,0,0,g_profit,0,0)   #MOD-770124
#                    g_aaz33,next_yy,0,0,g_profit,0,0,g_aza.aza17,g_axh13)   #MOD-770124  #No.TQC-850001 #MOD-938876 mark
#                   g_aaz33,next_yy,0,0,g_profit,0,0,g_axh12,g_axh13,g_legal)       #MOD-930076 #FUN-980003 add g_legal  #FUN-BC0027
                    g_aaa16,next_yy,0,0,g_profit,0,0,g_axh12,g_axh13,g_legal)        #FUN-BC0027
        IF SQLCA.sqlcode THEN
#          CALL cl_err('(s_eoy:ckp#4.3)',SQLCA.sqlcode,1)   #No.FUN-660123
#          CALL cl_err3("ins","axh_file",pp_aaa00,g_axh01,SQLCA.sqlcode,"","(s_eoy:ckp#4.3)",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
           IF g_bgerr THEN
             LET  g_showmsg= pp_aaa00,"/",g_axh01,"/",g_axh02,"/",g_axh03,"/",
#                            g_axh04,"/",g_axh041,"/",g_aaz33,"/",next_yy,"/",'0' #FUN-BC0027
                             g_axh04,"/",g_axh041,"/",g_aaa16,"/",next_yy,"/",'0' #FUN-BC0027
             CALL s_errmsg('axh00,axh01,axh02,axh03,axh04,axh041,axh05,axh06,axh07',g_showmsg,'(s_eoy:ckp#4.3)',SQLCA.sqlcode,1)   
           ELSE
             CALL cl_err3("ins","axh_file",pp_aaa00,g_axh01,SQLCA.sqlcode,"","(s_eoy:ckp#4.3)",1)   
           END IF
#          LET g_success='N' RETURN                 
           LET g_success='N' CONTINUE FOREACH
#NO.FUN-710023--END           
        END IF
  END FOREACH          
#NO.FUN-710023--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
    LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
END FUNCTION
