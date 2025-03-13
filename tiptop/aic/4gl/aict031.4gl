# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aict031.4gl
# Descriptions...: ICD出通單庫存制定維護作業
# Date & Author..: FUN-7B0015 07/12/10 By lilingyu 
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830124 08/03/24 By lilingyu 改正CONSTRUCT畫面字段錯誤
# Modify.........: No.CHI-940041 09/06/05 By jan 修改程序BUG
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980004 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AB0061 10/11/16 By shenyang 出貨單加基礎單價字段ogb37 
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga55,ogb50欄位無預設值修正
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:TQC-B80094 11/08/09 By jason UPDATE ogbi_file 少一個ogbi03=g_cnt
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0085 11/12/14 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C30237 12/03/20 By bart 1.預設帶訂單號碼並確定(帶出單身資料)
#                                                 2."是否要執行料件庫存指定"詢問視窗拿掉
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30289 12/04/03 By bart 將ogbiicd02、ogbiicd04欄位隱藏
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdout 回傳值
# Modify.........: No:MOD-C60068 12/06/12 By ck2yuan 該行訊息與aic-306無關,故拿掉
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52             

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_icy01     LIKE icy_file.icy01,         #出通單號
    g_icy02     LIKE icy_file.icy02,         #出通單項次
    g_icy        DYNAMIC ARRAY OF RECORD 
        icy03   LIKE icy_file.icy03,         #icy_file序號
        icy04   LIKE icy_file.icy04,         #勾選否
        icy05   LIKE icy_file.icy05,         #料件編號
        icy06   LIKE icy_file.icy06,         #倉庫
        icy07   LIKE icy_file.icy07,         #儲位
        icy08   LIKE icy_file.icy08,         #批號
        icy09   LIKE icy_file.icy09,         #Tape Reel
        icy10   LIKE icy_file.icy10,         #庫存量
        icy11   LIKE icy_file.icy11,   
        icy12   LIKE icy_file.icy12,         #出庫數量 
        icy13   LIKE icy_file.icy13,         #新出通單項次
        icy14   LIKE icy_file.icy14 
                    END RECORD,
    g_icy_t      RECORD
        icy03   LIKE icy_file.icy03,   
        icy04   LIKE icy_file.icy04,   
        icy05   LIKE icy_file.icy05,   
        icy06   LIKE icy_file.icy06,   
        icy07   LIKE icy_file.icy07,   
        icy08   LIKE icy_file.icy08,   
        icy09   LIKE icy_file.icy09,   
        icy10   LIKE icy_file.icy10,   
        icy11   LIKE icy_file.icy11,   
        icy12   LIKE icy_file.icy12,     
        icy13   LIKE icy_file.icy13,   
        icy14   LIKE icy_file.icy14 
                    END RECORD,
    g_icy_o      RECORD
        icy03   LIKE icy_file.icy03,   
        icy04   LIKE icy_file.icy04,   
        icy05   LIKE icy_file.icy05,   
        icy06   LIKE icy_file.icy06,   
        icy07   LIKE icy_file.icy07,   
        icy08   LIKE icy_file.icy08,   
        icy09   LIKE icy_file.icy09,   
        icy10   LIKE icy_file.icy10,   
        icy11   LIKE icy_file.icy11,   
        icy12   LIKE icy_file.icy12,     
        icy13   LIKE icy_file.icy13,   
        icy14   LIKE icy_file.icy14 
                    END RECORD
DEFINE g_argv1               LIKE icy_file.icy01       #單據編號
DEFINE g_argv2               LIKE ogb_file.ogb31       #FUN-C30237
DEFINE g_wc,g_sql            STRING
DEFINE g_rec_b               LIKE type_file.num5       #單身筆數
DEFINE l_ac                  LIKE type_file.num5       #目前處理的ARRAY CNT
DEFINE g_forupd_sql          STRING
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_msg1                LIKE type_file.chr1000
DEFINE g_msg2                LIKE type_file.chr1000
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask              LIKE type_file.num5
DEFINE g_process             LIKE type_file.chr1
DEFINE g_seq                 LIKE ogb_file.ogb03
DEFINE g_ima906              LIKE ima_file.ima906
DEFINE g_aa                  LIKE idd_file.idd16
DEFINE g_oga213              LIKE oga_file.oga213       #含稅否
DEFINE g_oga211              LIKE oga_file.oga211       #稅率
DEFINE l_spare_part          LIKE type_file.chr1
DEFINE l_spare_part_ogb09    LIKE ogb_file.ogb09
DEFINE l_spare_part_ogb091   LIKE ogb_file.ogb091
DEFINE l_spare_part_ogb092   LIKE ogb_file.ogb092
DEFINE  l_spare_qty          LIKE ogbi_file.ogbiicd02
DEFINE  l_spare_qtysum       LIKE ogbi_file.ogbiicd02
DEFINE g_ogb31               LIKE ogb_file.ogb31   #FUN-C30237 

MAIN                                                                            
   OPTIONS                               
       INPUT NO WRAP
   DEFER INTERRUPT                                                              
 
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
 
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("AIC")) THEN                                                
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
   #NO.FUN-7B0015  --Begin--
   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
   #NO.FUN-7B0015  --End--

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #計算使用時間(進入時間)
 
   LET g_argv1 = ARG_VAL(1) 
   LET g_argv2 = ARG_VAL(2)    #FUN-C30237
   LET g_icy01 = g_argv1 
   LET g_ogb31 = g_argv2       #FUN-C30237

  IF NOT cl_null(g_icy01) THEN

      CALL t031_q1()
      
      #IF cl_confirm('aic-303') THEN  #FUN-C30237 mark
         LET g_seq = 0
         SELECT MAX(ogb03)+1 INTO g_seq
           FROM ogb_file
          WHERE ogb01 = g_icy01
         IF SQLCA.SQLCODE OR cl_null(g_seq) THEN
            LET g_seq = 1
         END IF
 
         #取得該出通單的稅率資訊
         SELECT oga213,oga211 INTO g_oga213,g_oga211
            FROM oga_file
           WHERE oga01 = g_icy01
         IF cl_null(g_oga211) THEN 
            LET g_oga211 = 0
         END IF
 
         CALL t031_g_b()
         CLOSE WINDOW t031_w
         IF g_success = 'Y' THEN
 
            OPEN WINDOW t031_w WITH FORM "aic/42f/aict031"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
            CALL cl_ui_init()
            CALL cl_set_comp_visible("ogbiicd02,icy09",FALSE)           #FUN-C30235 #FUN-C30289
            CALL cl_set_comp_visible("icy03,icy13,icy14",FALSE)
 
            CALL t031_q()
            CALL t031_menu()
            CALL t031_ins_ogb_chk()
            CLOSE WINDOW t031_w
         END IF
      #END IF  #FUN-C30237  mark
   END IF 
 
   DELETE FROM icy_file WHERE 1=1;
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #計算使用時間(退出時間) 
END MAIN             
 
FUNCTION t031_q1()
 DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
 OPEN WINDOW t031_w WITH FORM "aic/42f/aict031"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 CALL cl_ui_init()
 CALL cl_set_comp_visible("ogbiicd02,icy09",FALSE)           #FUN-C30235  #FUN-C30289
 CLEAR FORM
 LET g_wc = NULL
 LET g_action_choice = ""
 
 WHILE TRUE
   CONSTRUCT BY NAME g_wc ON ogb31
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         DISPLAY g_ogb31 TO ogb31    #FUN-C30237
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t031_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
 END WHILE
END FUNCTION
 
FUNCTION t031_g_b()
  DEFINE l_icy      RECORD LIKE icy_file.*
  DEFINE l_ogb03_t    LIKE ogb_file.ogb03
  DEFINE l_ogb05      LIKE ogb_file.ogb05
  DEFINE l_ogb09      LIKE ogb_file.ogb09
  DEFINE l_ogb091     LIKE ogb_file.ogb091
  DEFINE l_ogb092     LIKE ogb_file.ogb092
  DEFINE l_ogb12      LIKE ogb_file.ogb12
# DEFINE l_ta_ogb020  LIKE ogb_file.ta_ogb020
  DEFINE l_ogbiicd02  LIKE ogbi_file.ogbiicd02
  DEFINE l_str        STRING
  DEFINE l_str1       STRING
  DEFINE l_img09      LIKE img_file.img09
  DEFINE l_qty        LIKE img_file.img10
  DEFINE l_flag       LIKE type_file.num5
  DEFINE l_fac        LIKE type_file.NUM26_10
  DEFINE l_qty1       LIKE img_file.img10
  DEFINE l_qty2       LIKE img_file.img10
  #DEFINE l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
  #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 
  DELETE FROM icy_file WHERE 1=1;
  LET g_success = 'Y'
 
# LET g_sql = "SELECT ogb01,ogb03,'','N',img01,img02,img03,img04,", #FUN-830124
  LET g_sql = "SELECT ogb01 aa1,ogb03 aa2,'','N',img01,img02,img03,img04,", #FUN-830124
             # "       ta_img010,img10,0,0,ogb03,'N',ogb05,img09 ",
               "       ogbiicd04,img10,0,0,ogb03,'N',",
               "'",g_plant,"','",g_legal,"',", #FUN-980004
               " ogb05,img09 ",
              "  FROM ogb_file,img_file,ogbi_file ",
              " WHERE ogb04 = img01 ",
              "   AND ogb01=ogbi01 ",
              "   AND ogb03=ogbi03 ",
              "   AND ogb01 = '",g_icy01 CLIPPED,"'",   #CHI-940041 拿掉mark符號
              "   AND img10 > 0 ",               #庫存量#CHI-940041 拿掉mark符號
              "   AND ",g_wc CLIPPED,                   #CHI-940041 拿掉mark符號
           #  " ORDER BY ogb01,ogb03 "
              " ORDER BY aa1,aa2 "                  #NO.FUN-830124
  PREPARE t031_g_b_pre FROM g_sql
 
  DECLARE t031_g_b_cs CURSOR FOR t031_g_b_pre
 
  FOREACH t031_g_b_cs INTO l_icy.*,l_ogb05,l_img09
    IF STATUS THEN
       CALL cl_err('t031_g_b_cs:',STATUS,1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF
 
    #已做過庫存指定的項次,詢問是否確定執行
    IF cl_null(l_ogb03_t) OR l_ogb03_t != l_icy.icy02 THEN
       LET l_ogb03_t = l_icy.icy02
       LET g_process = 'Y'
       LET l_ogb09 = NULL LET l_ogb091 = NULL LET l_ogb092 = NULL
       SELECT ogb09,ogb091,ogb092
         INTO l_ogb09,l_ogb091,l_ogb092
         FROM ogb_file
        WHERE ogb01 = l_icy.icy01
          AND ogb03 = l_icy.icy02
       LET l_str = NULL
       LET l_str = l_ogb09 CLIPPED,l_ogb091 CLIPPED,l_ogb092 CLIPPED
       IF NOT cl_null(l_str) THEN
          CALL cl_getmsg('aic-304',g_lang) RETURNING g_msg1
          CALL cl_getmsg('aic-305',g_lang) RETURNING g_msg2
          LET g_msg = g_msg1 CLIPPED,' ',l_icy.icy02 CLIPPED,' ',
                      g_msg2 CLIPPED
         #IF NOT (cl_confirm2("aic-306",g_msg)) THEN    #MOD-C60068 mark
          IF NOT (cl_confirm2("",g_msg)) THEN           #MOD-C60068 add
             LET g_process = 'N'
             CONTINUE FOREACH
          END IF
       END IF
    ELSE
       IF g_process = 'N' THEN
          CONTINUE FOREACH
       END IF
    END IF  
 
    #將庫存資料轉換為單位數量
    IF NOT cl_null(l_ogb05) AND NOT cl_null(l_img09) THEN
       CALL s_umfchk(l_icy.icy05,l_img09,l_ogb05)
            RETURNING l_flag,l_fac
       IF l_flag = 1 THEN
          CALL cl_err(l_icy.icy05,'aic-052',0)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
    ELSE
       CALL cl_err(l_icy.icy05,'aic-052',0)
       LET g_success = 'N'
       EXIT FOREACH
    END IF
    LET l_icy.icy10 = l_icy.icy10 * l_fac
 
    #賦予單身KEY值,序號做累加
    SELECT MAX(icy03)+1 INTO l_icy.icy03
      FROM icy_file
     WHERE icy01 = l_icy.icy01
       AND icy02 = l_icy.icy02
    IF SQLCA.SQLCODE OR cl_null(l_icy.icy03) THEN
       LET l_icy.icy03 = 1
    END IF
 
    #計算每筆資料+倉+儲+批的待出貨量
    #1.加總所有出貨未過賬的出貨量
    LET l_qty1 = 0
    SELECT SUM(ogb12*ogb05_fac) INTO l_qty1
      FROM oga_file,ogb_file
     WHERE oga01 = ogb01
       AND ogapost != 'Y'
       AND oga09 != '1'
       AND ((oga01 != l_icy.icy01) OR
            (oga01 = l_icy.icy01 AND ogb03 != l_icy.icy02))
       AND ogb04 = l_icy.icy05
       AND ogb09 = l_icy.icy06
       AND ogb091 = l_icy.icy07
       AND ogb092 = l_icy.icy08
    LET l_qty1 = s_digqty(l_qty1,l_ogb05)      #FUN-910088--add--
    IF SQLCA.SQLCODE OR cl_null(l_qty1) THEN
       LET l_qty1 = 0
    END IF
 
    # 2.加總所有出通單未轉出貨單的出貨量
    LET l_qty2 = 0
    SELECT SUM(ogb12*ogb05_fac) INTO l_qty2
      FROM oga_file,ogb_file
     WHERE oga01 = ogb01
       AND ogapost != 'Y'
       AND oga09 = '1'
       AND oga011 IS NULL
       AND ((oga01 != l_icy.icy01) OR
            (oga01 = l_icy.icy01 AND ogb03 != l_icy.icy02))
       AND ogb04 = l_icy.icy05
       AND ogb09 = l_icy.icy06
       AND ogb091 = l_icy.icy07
       AND ogb092 = l_icy.icy08
    LET l_qty2 = s_digqty(l_qty2,l_ogb05)      #FUN-910088--add--
    IF SQLCA.SQLCODE OR cl_null(l_qty2) THEN
       LET l_qty2 = 0
    END IF
    LET l_icy.icy11 = l_qty1 + l_qty2 
 
    IF cl_null(l_icy.icy10) THEN
       LET l_icy.icy10 = 0
    END IF
 
    #將料+倉+儲+批與原項次相同的資料,def已勾選
    LET l_ogb09 = NULL LET l_ogb091 = NULL LET l_ogb092 = NULL
#   LET l_ogb12 = NULL LET l_ta_ogb020 = NULL
    LET l_ogb12 = NULL LET l_ogbiicd02 = NULL
#   SELECT ogb09,ogb091,ogb092,ogb12,ta_ogb020
    SELECT ogb09,ogb091,ogb092,ogb12,ogbiicd02
#     INTO l_ogb09,l_ogb091,l_ogb092,l_ogb12,l_ta_ogb020
      INTO l_ogb09,l_ogb091,l_ogb092,l_ogb12,l_ogbiicd02
#     FROM ogb_file
      FROM ogb_file,ogbi_file
     WHERE ogb01 = l_icy.icy01
       AND ogb03 = l_icy.icy02
       AND ogb01 = ogbi01     #FUN-830124
       AND ogb03 = ogbi03     #FUN-830124
    IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
 #  IF cl_null(l_ta_ogb020) THEN LET l_ta_ogb020 = 0 END IF
    IF cl_null(l_ogbiicd02) THEN LET l_ogbiicd02 = 0 END IF
 
    LET l_str = l_ogb09 CLIPPED,",",l_ogb091 CLIPPED,",",l_ogb092 CLIPPED
    LET l_str1 = l_icy.icy06 CLIPPED,",",
                 l_icy.icy07 CLIPPED,",",
                 l_icy.icy08 CLIPPED
    IF l_str = l_str1 THEN
       IF l_icy.icy10 - l_icy.icy11 > 0 THEN
          LET l_icy.icy04 = 'Y'
          LET l_icy.icy13 = g_seq
     
          UPDATE idb_file SET idb08 = l_icy.icy13
             WHERE idb07 = l_icy.icy01
               AND idb08 = l_icy.icy02
       
          LET g_seq = g_seq + 1
     
          #FUN-BA0051 --START mark--
          #LET l_imaicd04 = ''
          #LET l_imaicd08 = ''
          #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08 
          #   FROM ima_file,imaicd_file
          #  WHERE ima01 = l_icy.icy05
          #   AND  ima01 =imaicd00
          #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 = 'Y' THEN 
          #FUN-BA0051 --END mark--
          IF s_icdbin(l_icy.icy05) THEN   #FUN-BA0051
#            LET l_ta_ogb020 = 0 
             LET l_ogbiicd02 = 0 
          END IF
       
#         IF l_icy.icy10-l_icy.icy11 > l_ogb12+l_ta_ogb020 THEN 
          IF l_icy.icy10-l_icy.icy11 > l_ogb12+l_ogbiicd02 THEN 
#            LET l_icy.icy12 = l_ogb12 + l_ta_ogb020 
             LET l_icy.icy12 = l_ogb12 + l_ogbiicd02
          ELSE
             LET l_icy.icy12 = l_icy.icy10 - l_icy.icy11
          END IF
          LET l_icy.icy11 = l_icy.icy11 + l_icy.icy12
       END IF
    END IF
   
    LET l_icy.icylegal = g_legal #FUN-980004
    LET l_icy.icyplant = g_plant #FUN-980004
    INSERT INTO icy_file VALUES(l_icy.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err('ins icy_file:',SQLCA.SQLCODE,1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF
  END FOREACH
  
  IF g_success = 'Y' THEN
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM icy_file
     IF g_cnt = 0 THEN
        CALL cl_err('','aic-053',1)
        LET g_success = 'N'
     END IF
  END IF
END FUNCTION
 
FUNCTION t031_curs()
 
   LET g_wc = " 1=1"
   LET g_sql= "SELECT UNIQUE icy01,icy02 ",
              "  FROM icy_file ",
              " WHERE ",g_wc CLIPPED,
              " GROUP BY icy01,icy02 ",
              " ORDER BY icy01,icy02 "
 
   PREPARE t031_prepare FROM g_sql      
 
   DECLARE t031_curs                    
      SCROLL CURSOR WITH HOLD FOR t031_prepare
 
END FUNCTION
 
FUNCTION t031_count()                                                           
DEFINE l_icy   DYNAMIC ARRAY of RECORD                           
                  icy01  LIKE icy_file.icy01,                     
                  icy02  LIKE icy_file.icy02
                  END RECORD                                                   
DEFINE li_cnt     LIKE type_file.num10                                                    
DEFINE li_rec_b    LIKE type_file.num10                                                     
                                                                                
   LET g_sql= "SELECT icy01,icy02 ",
              "  FROM icy_file ",
              " WHERE ",g_wc CLIPPED,
              " GROUP BY icy01,icy02 ",
              " ORDER BY icy01,icy02 "
                                                                                
   PREPARE t031_precount FROM g_sql
   DECLARE t031_count CURSOR FOR t031_precount
   LET li_cnt = 1
   LET li_rec_b = 0
   FOREACH t031_count INTO l_icy[li_cnt].*
       LET li_rec_b = li_rec_b + 1                                              
       IF STATUS THEN                                                    
          CALL cl_err('t031_count',STATUS,1) 
          LET li_rec_b = li_rec_b - 1 
          EXIT FOREACH 
       END IF 
       LET li_cnt = li_cnt + 1 
   END FOREACH                                                                 
   LET g_row_count = li_rec_b 
END FUNCTION        
 
FUNCTION t031_menu()
 
   WHILE TRUE
      CALL t031_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t031_q()
            END IF
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t031_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"    
            CALL cl_cmdask()
 
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icy),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t031_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_icy.clear()
   CALL t031_curs()  
     
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      INITIALIZE g_icy01 TO NULL
      INITIALIZE g_icy02 TO NULL
      RETURN
   END IF
   OPEN t031_curs    
       
   IF SQLCA.SQLCODE THEN    
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_icy01 TO NULL
      INITIALIZE g_icy02 TO NULL
   ELSE
      CALL t031_count() 
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t031_fetch('F')                
   END IF
 
END FUNCTION
 
FUNCTION t031_fetch(p_flag)
DEFINE  p_flag  LIKE type_file.chr1          
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t031_curs INTO g_icy01,g_icy02
        WHEN 'P' FETCH PREVIOUS t031_curs INTO g_icy01,g_icy02
        WHEN 'F' FETCH FIRST    t031_curs INTO g_icy01,g_icy02
        WHEN 'L' FETCH LAST     t031_curs INTO g_icy01,g_icy02
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
          
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about        
                      CALL cl_about()      
 
                   ON ACTION help      
                      CALL cl_show_help()
 
                   ON ACTION controlg 
                      CALL cl_cmdask()
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t031_curs INTO g_icy01,g_icy02
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_icy01 = NULL
       LET g_icy02 = NULL
       DISPLAY g_icy01 TO icy01
       DISPLAY g_icy02 TO icy02
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting(g_curs_index,g_row_count)
    END IF
 
    CALL t031_show()
END FUNCTION
 
FUNCTION t031_show()
 
    DISPLAY g_icy01 TO icy01               #單頭 
    DISPLAY g_icy02 TO icy02               #單頭
    CALL t031_ogb01()
    
    CALL t031_b_fill()                             
    CALL cl_show_fld_cont()   
 
END FUNCTION
 
FUNCTION t031_ogb01()
  DEFINE l_ogb31      LIKE ogb_file.ogb31
  DEFINE l_ogb32      LIKE ogb_file.ogb32
  DEFINE l_ogb04      LIKE ogb_file.ogb04
  DEFINE l_ogb05      LIKE ogb_file.ogb05
  DEFINE l_ogb12      LIKE ogb_file.ogb12
# DEFINE l_ta_ogb020  LIKE ogb_file.ta_ogb020
  DEFINE l_ogbiicd02  LIKE ogbi_file.ogbiicd02
  DEFINE l_ima02      LIKE ima_file.ima02
 
# SELECT ogb31,ogb32,ogb04,ogb05,ogb12,ta_ogb020
  SELECT ogb31,ogb32,ogb04,ogb05,ogb12,ogbiicd02
#   INTO l_ogb31,l_ogb32,l_ogb04,l_ogb05,l_ogb12,l_ta_ogb020
    INTO l_ogb31,l_ogb32,l_ogb04,l_ogb05,l_ogb12,l_ogbiicd02
#   FROM ogb_file
    FROM ogb_file,ogbi_file
   WHERE ogb01 = g_icy01
     AND ogb03 = g_icy02
     AND ogb01 = ogbi01   #FUN-830124
     AND ogb03 = ogbi03   #FUN-830124
 
  IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
# IF cl_null(l_ta_ogb020) THEN LET l_ta_ogb020 = 0 END IF
  IF cl_null(l_ogbiicd02) THEN LET l_ogbiicd02 = 0 END IF
  SELECT ima02 INTO l_ima02
    FROM ima_file
   WHERE ima01 = l_ogb04
 
  DISPLAY l_ogb31 TO FORMONLY.ogb31
  DISPLAY l_ogb32 TO FORMONLY.ogb32
  DISPLAY l_ogb04 TO FORMONLY.ogb04
  DISPLAY l_ogb05 TO FORMONLY.ogb05
  DISPLAY l_ogb12 TO FORMONLY.ogb12
# DISPLAY l_ta_ogb020 TO FORMONLY.ta_ogb020
  DISPLAY l_ogbiicd02 TO FORMONLY.ogbiicd02
  DISPLAY l_ima02 TO FORMONLY.ima02
 
  CALL t031_recount_head()
 
END FUNCTION
 
FUNCTION t031_b_fill()
 
    LET g_sql = "SELECT icy03,icy04,icy05,icy06,icy07,",
                "       icy08,icy09,icy10,icy11,icy12,",
                "       icy13,icy14 ",
                "  FROM icy_file ",
                " WHERE icy01 = '",g_icy01 CLIPPED,"'",
                "   AND icy02 = ", g_icy02,
                " ORDER BY icy03 "
 
    PREPARE t031_prepare2 FROM g_sql      
    DECLARE icy_curs CURSOR FOR t031_prepare2
    CALL g_icy.clear()
    LET g_cnt = 1
    FOREACH icy_curs INTO g_icy[g_cnt].*   #單身ARRAY填充
       IF STATUS THEN
          CALL cl_err('icy_curs:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_icy.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t031_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_cnt           LIKE type_file.num5,              #檢查重復用
    l_n             LIKE type_file.num5,              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,              #單身鎖住否
    p_cmd           LIKE type_file.chr1,              #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5,              #可刪除否
    #l_imaicd04      LIKE imaicd_file.imaicd04,   #FUN-BA0051 mark
    #l_imaicd08      LIKE imaicd_file.imaicd08,   #FUN-BA0051 mark
    l_oga02         LIKE oga_file.oga02,
    l_ogb05         LIKE ogb_file.ogb05,
    l_flag          LIKE type_file.num5,
    #l_qty           LIKE img_file.img10,  #FUN-C30302
    l_ogb12         LIKE ogb_file.ogb12,
#   l_ta_ogb020     LIKE ogb_file.ta_ogb020
    l_ogbiicd02     LIKE ogbi_file.ogbiicd02,
    l_r             LIKE type_file.chr1,    #FUN-C30302
    l_qty           LIKE type_file.num15_3  #FUN-C30302
 
    LET g_action_choice = ""
 
    IF cl_null(g_icy01) OR cl_null(g_icy02) THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
      "SELECT icy03,icy04,icy05,icy06,icy07,icy08,",
      "       icy09,icy10,icy11,icy12,icy13,icy14 ",
      "  FROM icy_file ",
      "  UPEDLOCK WHERE icy01 = ? AND icy02 = ? AND icy03 = ? ",
      "  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    INPUT ARRAY g_icy WITHOUT DEFAULTS FROM s_icy.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                 #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
               LET p_cmd = 'u'
               LET g_icy_t.* = g_icy[l_ac].*    #BACKUP
               LET g_icy_o.* = g_icy[l_ac].*    #BACKUP
 
               OPEN t031_bcl USING g_icy01,g_icy02,
                                   g_icy_t.icy03
               IF STATUS THEN
                  CALL cl_err("OPEN t031_bcl:",STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t031_bcl INTO g_icy[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_icy_t.icy03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET g_icy_t.* = g_icy[l_ac].*
                  LET g_icy_o.* = g_icy[l_ac].*
                  CALL t031_set_entry_b()
                  CALL t031_set_no_entry_b()
               END IF
               CALL cl_show_fld_cont()   
            END IF
 
        BEFORE FIELD icy04
           CALL t031_set_entry_b()
 
        ON CHANGE icy04
           IF g_icy[l_ac].icy04 = 'Y' THEN
              CALL t031_def_qty()
           ELSE
              CALL t031_cal_qty()
           END IF
 
        AFTER FIELD icy04
           IF NOT cl_null(g_icy[l_ac].icy04) THEN
              IF p_cmd = 'u' AND
                 g_icy[l_ac].icy04 != g_icy_o.icy04 THEN
                 IF g_icy[l_ac].icy04 = 'N' THEN
                    #FUN-BA0051 --START mark--
                    #LET l_imaicd04 = NULL LET l_imaicd08 = NULL
                    #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
                    #  FROM ima_file,imaicd_file
                    # WHERE ima01 = g_icy[l_ac].icy05
                    #   AND ima01 =imaicd00
                    #IF l_imaicd04 MATCHES '[124]' AND l_imaicd08 = 'Y' THEN
                    #FUN-BA0051 --START mark--
                    IF s_icdbin(g_icy[l_ac].icy05) THEN   #FUN-BA0051
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt
                         FROM idb_file
                        WHERE idb07 = g_icy01
                          AND idb08 = g_icy[l_ac].icy13
                       IF l_cnt > 0 THEN
                          IF NOT cl_confirm('aic-307') THEN
                             LET g_icy[l_ac].icy04 = g_icy_o.icy04
                             LET g_icy[l_ac].icy12 = g_icy_o.icy12
                             LET g_icy[l_ac].icy11 = 
                             g_icy[l_ac].icy11 + g_icy[l_ac].icy12
                             DISPLAY BY NAME g_icy[l_ac].icy04,
                                             g_icy[l_ac].icy11,
                                             g_icy[l_ac].icy12
                             NEXT FIELD icy04
                          ELSE
                             CALL s_icdinout_del(-1,g_icy01,
                                                     g_icy[l_ac].icy13,'')  #FUN-B80119--傳入p_plant參數''---
                                  RETURNING l_flag
                             IF l_flag = 0 THEN
                                LET g_icy[l_ac].icy04 = g_icy_o.icy04
                                LET g_icy[l_ac].icy12 = g_icy_o.icy12
                                LET g_icy[l_ac].icy11 = g_icy[l_ac].icy11 + g_icy[l_ac].icy12
                                DISPLAY BY NAME g_icy[l_ac].icy04,
                                                g_icy[l_ac].icy11,
                                                g_icy[l_ac].icy12
                                NEXT FIELD icy04
                             END IF
                          END IF
                       END IF
                    END IF
                    LET g_icy[l_ac].icy13 = g_icy02
                    DISPLAY BY NAME g_icy[l_ac].icy13
                 ELSE
                    LET g_icy[l_ac].icy13 = g_seq
                    LET g_seq = g_seq + 1
                    DISPLAY BY NAME g_icy[l_ac].icy13 
                 END IF
              END IF
              CALL t031_set_no_entry_b()
           END IF
           LET g_icy_o.icy04 = g_icy[l_ac].icy04
 
        AFTER FIELD icy12
           IF NOT cl_null(g_icy[l_ac].icy12) THEN
              IF g_icy[l_ac].icy12 < 0 THEN
                 CALL cl_err(g_icy[l_ac].icy12,'aic-054',0)
                 LET g_icy[l_ac].icy12 = g_icy_o.icy12
                 DISPLAY BY NAME g_icy[l_ac].icy12
                 NEXT FIELD icy12
              END IF
              IF g_icy[l_ac].icy12 > g_icy[l_ac].icy10 - (g_icy[l_ac].icy11 - g_icy_o.icy12) THEN
                 CALL cl_err(g_icy[l_ac].icy12,'aic-055',0)
                 LET g_icy[l_ac].icy12 = g_icy_o.icy12
                 DISPLAY BY NAME g_icy[l_ac].icy12
                 NEXT FIELD icy12
              END IF
              IF g_icy[l_ac].icy12 = 0 THEN
                 #FUN-BA0051 --START mark--
                 #LET l_imaicd04 = NULL LET l_imaicd08 = NULL
                 #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
                 #  FROM ima_file,imaicd_file
                 # WHERE ima01 = g_icy[l_ac].icy05
                 #   AND ima01 = imaicd00
                 #IF l_imaicd04 MATCHES '[124]' AND l_imaicd08 = 'Y' THEN
                 #FUN-BA0051 --START mark--
                 IF s_icdbin(g_icy[l_ac].icy05) THEN   #FUN-BA0051
                     LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt
                      FROM idb_file
                     WHERE idb07 = g_icy01
                       AND idb08 = g_icy[l_ac].icy13
                    IF l_cnt > 0 THEN
                       IF NOT cl_confirm('aic-307') THEN
                          LET g_icy[l_ac].icy12 = g_icy_o.icy12
                          DISPLAY BY NAME g_icy[l_ac].icy12
                          NEXT FIELD icy12
                       ELSE
                          CALL s_icdinout_del(-1,g_icy01,
                                                  g_icy[l_ac].icy13,'')  #FUN-B80119--傳入p_plant參數''---
                               RETURNING l_flag
                          IF l_flag = 0 THEN
                             LET g_icy[l_ac].icy12 = g_icy_o.icy12
                             DISPLAY BY NAME g_icy[l_ac].icy12
                             NEXT FIELD icy12
                          END IF
                       END IF
                    END IF
                 END IF
                 LET g_icy[l_ac].icy04 = 'N'
                 LET g_icy[l_ac].icy13 = g_icy02
                 DISPLAY BY NAME g_icy[l_ac].icy04
                 DISPLAY BY NAME g_icy[l_ac].icy13
              END IF
              LET g_icy[l_ac].icy11 = g_icy[l_ac].icy11 +
                                             g_icy[l_ac].icy12 -
                                             g_icy_o.icy12 
              DISPLAY BY NAME g_icy[l_ac].icy11
           ELSE
              NEXT FIELD icy12
           END IF
           LET g_icy_o.icy12 = g_icy[l_ac].icy12
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_icy[l_ac].* = g_icy_t.*
               CLOSE t031_bcl
               ROLLBACK WORK
               CALL t031_recount_head()
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_icy[l_ac].icy03,-263,1)
               LET g_icy[l_ac].* = g_icy_t.*
            ELSE
               IF g_icy[l_ac].icy04 = 'Y' AND
                  g_icy[l_ac].icy12 = 0 THEN
                  LET g_icy[l_ac].icy04 = 'N'
                  CALL t031_cal_qty()
               END IF
 
               UPDATE icy_file SET
                             icy04 = g_icy[l_ac].icy04,
                             icy11 = g_icy[l_ac].icy11,
                             icy12 = g_icy[l_ac].icy12,
                             icy13 = g_icy[l_ac].icy13,
                             icy14 = g_icy[l_ac].icy14
                 WHERE icy01 = g_icy01 
                   AND icy02 = g_icy02 
                   AND icy03 = g_icy_t.icy03 
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err(g_icy[l_ac].icy03,SQLCA.SQLCODE,0)
                  LET g_icy[l_ac].* = g_icy_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
               CALL t031_recount_head()
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_icy[l_ac].* = g_icy_t.*
               END IF
               CLOSE t031_bcl
               ROLLBACK WORK
               CALL t031_recount_head()
               EXIT INPUT
            END IF
            #FUN-BA0051 --START mark--
            #LET l_imaicd04 = NULL  LET l_imaicd08 = NULL
            #SELECT imaicd04,imaicd08
            #  INTO l_imaicd04,l_imaicd08
            #  FROM ima_file,imaicd_file
            # WHERE ima01 = g_icy[l_ac].icy05
            #  AND  ima01 = imaicd00 
            #IF l_imaicd04 MATCHES '[124]' AND l_imaicd08 = 'Y' THEN
            #FUN-BA0051 --END mark--
            IF s_icdbin(g_icy[l_ac].icy05) THEN   #FUN-BA0051
               IF g_icy[l_ac].icy12 > 0 THEN
                  IF cl_confirm('aic-308') THEN
                     LET l_oga02 = NULL
                     SELECT oga02 INTO l_oga02
                       FROM oga_file
                      WHERE oga01 = g_icy01
 
                     LET l_ogb05 = NULL
                     SELECT ogb05 INTO l_ogb05
                       FROM ogb_file
                      WHERE ogb01 = g_icy01
                        AND ogb03 = g_icy02
 
                     CALL s_icdout(g_icy[l_ac].icy05,
                                    g_icy[l_ac].icy06,
                                    g_icy[l_ac].icy07,
                                    g_icy[l_ac].icy08,
                                    l_ogb05,
                                    g_icy[l_ac].icy12,
                                    g_icy01,
                                    g_icy[l_ac].icy13,
                                    l_oga02,'N','','','','') 
                          RETURNING g_aa,l_r,l_qty   #FUN-C30302
                          #FUN-C30302---begin
                          IF l_r = 'Y' THEN 
                              LET l_qty = s_digqty(l_qty,l_ogb05) 
                              LET g_icy[l_ac].icy12 = l_qty
                              DISPLAY BY NAME g_icy[l_ac].icy12
                          END IF 
                          #FUN-C30302---end
                          
                     CALL s_icdchk(2,g_icy[l_ac].icy05,
                                      g_icy[l_ac].icy06,
                                      g_icy[l_ac].icy07,
                                      g_icy[l_ac].icy08,
                                      g_icy[l_ac].icy12,
                                      g_icy01,
                                      g_icy[l_ac].icy13,
                                      l_oga02,'')  #FUN-B80119--傳入p_plant參數''---
                          RETURNING l_flag
                     IF l_flag = 0 THEN
                        CALL cl_err('','aic-056',1)
                     END IF
                  END IF
                  IF l_ac = g_rec_b THEN
                     EXIT INPUT
                  END IF
               END IF
            END IF
            CLOSE t031_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about      
           CALL cl_about()    
 
        ON ACTION help         
           CALL cl_show_help()  
 
    END INPUT
    CLOSE t031_bcl
    COMMIT WORK
 
    CALL t031_chk_qty()
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,1)
    END IF
END FUNCTION
 
FUNCTION t031_chk_qty()
  DEFINE  l_qty1   LIKE img_file.img10
  DEFINE  l_qty2   LIKE img_file.img10
# DEFINE  l_ta_ogb020   LIKE ogb_file.ta_ogb020
  DEFINE  l_ogbiicd02   LIKE ogbi_file.ogbiicd02
  DEFINE  l_ogb04       LIKE ogb_file.ogb04
  #DEFINE  l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
  #DEFINE  l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 
  LET g_errno = ''
 
  LET l_qty1 = 0
  SELECT SUM(icy12) INTO l_qty1
    FROM icy_file
   WHERE icy01 = g_icy01
     AND icy02 = g_icy02
  IF SQLCA.SQLCODE OR cl_null(l_qty1) THEN
     LET l_qty1 = 0
  END IF
 
  LET l_qty2 = 0
# LET l_ta_ogb020 = 0 
  LET l_ogbiicd02 = 0 
  LET l_ogb04 = ''
# SELECT ogb12,ta_ogb020,ogb04 INTO l_qty2,l_ta_ogb020,l_ogb04
  SELECT ogb12,ogbiicd02,ogb04 INTO l_qty2,l_ogbiicd02,l_ogb04
#   FROM ogb_file
    FROM ogb_file,ogbi_file
   WHERE ogb01 = g_icy01
     AND ogb03 = g_icy02
     AND ogb01 = ogbi01
     AND ogb03 = ogbi03
     
  IF SQLCA.SQLCODE OR cl_null(l_qty2) THEN
     LET l_qty2 = 0
#    LET l_ta_ogb020 = 0 
     LET l_ogbiicd02 = 0 
  END IF
  #FUN-BA0051 --START mark--
  #LET l_imaicd04 = ''
  #LET l_imaicd08 = ''
  #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
  #   FROM ima_file,imaicd_file
  #  WHERE ima01 = l_ogb04
  #    AND ima01 = imaicd00
  #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 = 'Y' THEN
  #FUN-BA0051 --END mark--
  IF s_icdbin(l_ogb04) THEN   #FUN-BA0051 
#    LET l_ta_ogb020 = 0 
     LET l_ogbiicd02 = 0 
  END IF
# LET l_qty2 = l_qty2 + l_ta_ogb020
  LET l_qty2 = l_qty2 + l_ogbiicd02
 
  IF l_qty1 != l_qty2 THEN
     LET g_errno = 'aic-309'
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION t031_def_qty()
  DEFINE  l_hold_qty   LIKE img_file.img10
  DEFINE  l_unhold_qty LIKE img_file.img10
  DEFINE  l_ogb12      LIKE ogb_file.ogb12
# DEFINE  l_ta_ogb020  LIKE ogb_file.ta_ogb020
  DEFINE  l_ogbiicd02  LIKE ogbi_file.ogbiicd02
  DEFINE  l_ogb04      LIKE ogb_file.ogb04    
  #DEFINE  l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
  #DEFINE  l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 
# LET l_ogb12 = 0  LET l_ta_ogb020 = 0
  LET l_ogb12 = 0  LET l_ogbiicd02 = 0
  LET l_ogb04 = ''
 
# SELECT ogb12,ta_ogb020,ogb04
  SELECT ogb12,ogbiicd02,ogb04
#   INTO l_ogb12,l_ta_ogb020,l_ogb04
    INTO l_ogb12,l_ogbiicd02,l_ogb04
#   FROM ogb_file
    FROM ogb_file,ogbi_file
   WHERE ogb01 = g_icy01
     AND ogb03 = g_icy02
     AND ogb01 = ogbi01
     AND ogb03 = ogbi03
  IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
# IF cl_null(l_ta_ogb020) THEN LET l_ta_ogb020 = 0 END IF
  IF cl_null(l_ogbiicd02) THEN LET l_ogbiicd02 = 0 END IF
 
  #FUN-BA0051 --START mark--
  #LET l_imaicd04 = ''
  #LET l_imaicd08 = ''
  #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
  #   FROM ima_file,imaicd_file
  #  WHERE ima01 = l_ogb04
  #   AND ima01 = imaicd00
  #  
  #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 = 'Y' THEN
  #FUN-BA0051 --END mark--
  IF s_icdbin(l_ogb04) THEN   #FUN-BA0051 
#    LET l_ta_ogb020 = 0 
     LET l_ogbiicd02 = 0 
  END IF
 
  LET l_hold_qty = 0
  SELECT SUM(icy12) INTO l_hold_qty
    FROM icy_file
   WHERE icy01 = g_icy01
     AND icy02 = g_icy02
     
  IF cl_null(l_hold_qty) THEN LET l_hold_qty = 0 END IF
 
  IF g_icy_o.icy12 > 0 THEN
     LET l_hold_qty = l_hold_qty - g_icy_o.icy12
  END IF
 
# LET l_unhold_qty = l_ogb12 + l_ta_ogb020 - l_hold_qty
  LET l_unhold_qty = l_ogb12 + l_ogbiicd02 - l_hold_qty
 
  IF g_icy_o.icy12 > 0 THEN
     IF g_icy[l_ac].icy10 -
       (g_icy[l_ac].icy11 - g_icy_o.icy12) >= l_unhold_qty THEN
        LET g_icy[l_ac].icy12 = l_unhold_qty
     ELSE
        LET g_icy[l_ac].icy12 = g_icy[l_ac].icy10 -
                                      (g_icy[l_ac].icy11 -
                                       g_icy_o.icy12)
     END IF
     LET g_icy[l_ac].icy11 = g_icy[l_ac].icy11 + 
                                    g_icy[l_ac].icy12 -
                                    g_icy_o.icy12
  ELSE
     IF g_icy[l_ac].icy10 - g_icy[l_ac].icy11 >= l_unhold_qty THEN
        LET g_icy[l_ac].icy12 = l_unhold_qty
     ELSE
        LET g_icy[l_ac].icy12 = g_icy[l_ac].icy10 -
                                       g_icy[l_ac].icy11 
     END IF
     LET g_icy[l_ac].icy11 = g_icy[l_ac].icy11 + 
                                    g_icy[l_ac].icy12 
 
  END IF
  LET g_icy_o.icy11 = g_icy[l_ac].icy11
  LET g_icy_o.icy12 = g_icy[l_ac].icy12
  DISPLAY BY NAME g_icy[l_ac].icy11,g_icy[l_ac].icy12
 
  UPDATE icy_file SET icy11 = g_icy[l_ac].icy11,
                      icy12 = g_icy[l_ac].icy12
   WHERE icy01 = g_icy01 
     AND icy02 = g_icy02 
     AND icy03 = g_icy_t.icy03 
 
  CALL t031_recount_head()
 
END FUNCTION
 
FUNCTION t031_cal_qty()
 
  LET g_icy[l_ac].icy11 = g_icy[l_ac].icy11 - 
                                 g_icy[l_ac].icy12
  LET g_icy[l_ac].icy12 = 0
  LET g_icy_o.icy11 = g_icy[l_ac].icy11
  LET g_icy_o.icy12 = g_icy[l_ac].icy12
  DISPLAY BY NAME g_icy[l_ac].icy11,g_icy[l_ac].icy12
 
  UPDATE icy_file SET icy11 = g_icy[l_ac].icy11,
                      icy12 = g_icy[l_ac].icy12
   WHERE icy01 = g_icy01 
     AND icy02 = g_icy02 
     AND icy03 = g_icy_t.icy03 
 
  CALL t031_recount_head()
 
END FUNCTION
 
FUNCTION t031_recount_head()
  DEFINE  l_qty1       LIKE img_file.img10
  DEFINE  l_qty2       LIKE img_file.img10
  DEFINE  l_ogb12      LIKE ogb_file.ogb12
# DEFINE  l_ta_ogb020  LIKE ogb_file.ta_ogb020
  DEFINE  l_ogbiicd02  LIKE ogbi_file.ogbiicd02
  #DEFINE  l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
  #DEFINE  l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
  DEFINE  l_ogb04      LIKE ogb_file.ogb04
 
   LET l_qty1 = 0
   SELECT SUM(icy12) INTO l_qty1
     FROM icy_file
    WHERE icy01 = g_icy01
      AND icy02 = g_icy02
      
   IF SQLCA.SQLCODE OR cl_null(l_qty1) THEN
      LET l_qty1 = 0
   END IF
 
#  LET l_ogb12 = 0  LET l_ta_ogb020 = 0
   LET l_ogb12 = 0  LET l_ogbiicd02 = 0
   LET l_ogb04 = ''
#  SELECT ogb12,ta_ogb020,ogb04
   SELECT ogb12,ogbiicd02,ogb04
#    INTO l_ogb12,l_ta_ogb020,l_ogb04
     INTO l_ogb12,l_ogbiicd02,l_ogb04
#    FROM ogb_file
     FROM ogb_file,ogbi_file
    WHERE ogb01 = g_icy01
      AND ogb03 = g_icy02
      AND ogb01 = ogbi01
      AND ogb03 = ogbi03
      
   IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
#  IF cl_null(l_ta_ogb020) THEN LET l_ta_ogb020 = 0 END IF
   IF cl_null(l_ogbiicd02) THEN LET l_ogbiicd02 = 0 END IF
 
   #FUN-BA0051 --START mark--
   #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
   #   FROM ima_file,imaicd_file
   #  WHERE ima01 = l_ogb04
   #    AND ima01 = imaicd00
   #  
   #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 = 'Y' THEN
   #FUN-BA0051 --END mark--
   IF s_icdbin(l_ogb04) THEN   #FUN-BA0051
#     LET l_ta_ogb020 = 0 
      LET l_ogbiicd02 = 0 
   END IF
 
#  LET l_qty2 = l_ogb12 + l_ta_ogb020 - l_qty1
   LET l_qty2 = l_ogb12 + l_ogbiicd02 - l_qty1
 
   DISPLAY l_qty1 TO FORMONLY.hold_qty
   DISPLAY l_qty2 TO FORMONLY.unhold_qty
 
END FUNCTION
 
FUNCTION t031_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_icy TO s_icy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t031_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
                              
      ON ACTION previous
         CALL t031_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
                              
      ON ACTION jump
         CALL t031_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION next
         CALL t031_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION last
         CALL t031_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
                              
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()           
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG = FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION t031_set_entry_b()
 
   CALL cl_set_comp_entry("icy12",TRUE)
 
END FUNCTION
 
FUNCTION t031_set_no_entry_b()
 
   IF g_icy[l_ac].icy04 = 'N' THEN
      CALL cl_set_comp_entry("icy12",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t031_ins_ogb_chk()
   DEFINE  l_ogb         RECORD LIKE ogb_file.*
   DEFINE  l_ogbi        RECORD LIKE ogbi_file.*   
   DEFINE  l_icy         RECORD LIKE icy_file.*
   DEFINE  l_imaicd04    LIKE imaicd_file.imaicd04
   DEFINE  l_cnt         LIKE type_file.num5
   DEFINE  l_n           LIKE type_file.num5
   DEFINE  l_flag        LIKE type_file.num5
   DEFINE  l_icy13       LIKE icy_file.icy13
   #DEFINE  l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 
   BEGIN WORK
   LET g_success = 'Y'
 
   DECLARE t031_ins_ogb_chk_cs CURSOR FOR
     SELECT icy01,icy02 FROM icy_file
      GROUP BY icy01,icy02
      ORDER BY icy01,icy02
 
   LET g_cnt = 0
   FOREACH t031_ins_ogb_chk_cs INTO g_icy01,g_icy02
      IF STATUS THEN
         CALL cl_err('t031_ins_ogb_chk_cs:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      CALL t031_chk_qty()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_icy02,'aic-057',1)
         DECLARE t031_del_icdout_cs CURSOR FOR
           SELECT icy13 FROM icy_file
            WHERE icy01 = g_icy01
              AND icy02 = g_icy02
         FOREACH t031_del_icdout_cs INTO l_icy13
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM idb_file
             WHERE idb07 = g_icy01
               AND idb08 = l_icy13 
            IF l_cnt > 0 THEN
               CALL s_icdinout_del(-1,g_icy01,l_icy13,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
            END IF
         END FOREACH
         CONTINUE FOREACH
      END IF
 
      DECLARE t031_ins_ogb_chk_cs2 CURSOR FOR
        SELECT * FROM icy_file WHERE icy01 = g_icy01
                                    AND icy02 = g_icy02
                                    AND icy04 = 'Y'
           ORDER BY icy12 DESC 
      LET l_spare_part = 'N'
      LET l_spare_part_ogb09 = NULL
      LET l_spare_part_ogb091 = NULL
      LET l_spare_part_ogb092 = NULL
 
      LET l_spare_qty = 0    
      LET l_spare_qtysum = 0 
 
      FOREACH t031_ins_ogb_chk_cs2 INTO l_icy.*
         IF STATUS THEN
            CALL cl_err('t031_ins_ogb_chk_cs2:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         SELECT * INTO l_ogb.* FROM ogb_file
          WHERE ogb01 = g_icy01
            AND ogb03 = g_icy02
         #FUN-BA0051 --START mark--
         #LET l_imaicd04 = ''
         #LET l_imaicd08 = ''
         #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
         #   FROM ima_file,imaicd_file 
         #  WHERE ima01 = l_ogb.ogb04
         #    AND ima01 = imaicd00
         #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 = 'Y' THEN
         #FUN-BA0051 --END mark--
         IF s_icdbin(l_ogb.ogb04) THEN   #FUN-BA0051
#           LET l_ogb.ta_ogb020 = 0 
            LET l_ogbi.ogbiicd02 = 0 
         END IF
     
#        IF l_ogb.ta_ogb020 > 0 AND (l_spare_qtysum != l_ogb.ta_ogb020) THEN
         IF l_ogbi.ogbiicd02 > 0 AND (l_spare_qtysum != l_ogbi.ogbiicd02) THEN
#           IF l_icy.icy12 >= (l_ogb.ta_ogb020 - l_spare_qtysum) THEN
            IF l_icy.icy12 >= (l_ogbi.ogbiicd02 - l_spare_qtysum) THEN
#              LET l_spare_qty =(l_ogb.ta_ogb020 - l_spare_qtysum)
               LET l_spare_qty =(l_ogbi.ogbiicd02 - l_spare_qtysum)
               LET l_icy.icy12 = l_icy.icy12 - l_spare_qty
            ELSE
               LET l_spare_qty = l_icy.icy12
               LET l_icy.icy12 = 0
            END IF
 
            LET l_spare_part = 'Y'
            LET l_spare_part_ogb09 = l_icy.icy06
            LET l_spare_part_ogb091 = l_icy.icy07
            LET l_spare_part_ogb092 = l_icy.icy08
            IF l_icy.icy12 = 0 THEN
               CALL ins_ogb_spare(l_icy.icy13)
               CONTINUE FOREACH
            END IF
         END IF  
    
         LET l_ogb.ogb03 = l_icy.icy13
         LET l_ogb.ogb09 = l_icy.icy06
         LET l_ogb.ogb091 = l_icy.icy07
         LET l_ogb.ogb092 = l_icy.icy08
 
         LET l_imaicd04 = NULL
         SELECT imaicd04 INTO l_imaicd04
           FROM ima_file,imaicd_file
          WHERE ima01 = l_ogb.ogb04
            AND ima01 = imaicd00
          
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM jce_file
          WHERE jce02 = l_ogb.ogb09
            AND jceacti = 'Y'
            
         IF SQLCA.SQLCODE OR cl_null(l_cnt) THEN
            LET l_cnt = 0
         END IF
         IF l_imaicd04 MATCHES '[1234]' AND l_cnt > 0 THEN
#           LET l_ogb.ta_ogb010 = 'Y'
            LET l_ogbi.ogbiicd01= 'Y'
         ELSE
#           LET l_ogb.ta_ogb010 = 'N'
            LET l_ogbi.ogbiicd01 = 'N'
         END IF
#        LET l_ogb.ta_ogb020 = 0
         LET l_ogbi.ogbiicd02 = 0
#        LET l_ogb.ta_ogb040 = l_icy.icy09
         LET l_ogbi.ogbiicd04 = l_icy.icy09
 
         LET g_ima906 = NULL
         SELECT ima906 INTO g_ima906
           FROM ima_file
          WHERE ima01 = l_icy.icy05
          
         IF g_sma.sma115 = 'Y' THEN
            CASE g_ima906
              WHEN '1'
                   LET l_ogb.ogb912 = l_icy.icy12
              WHEN '2'
                   LET l_ogb.ogb915 = l_icy.icy12 / l_ogb.ogb914
                   LET l_n = l_ogb.ogb915
                   LET l_ogb.ogb915 = l_n
                   LET l_ogb.ogb912 = l_icy.icy12 - 
                                     (l_ogb.ogb915 * l_ogb.ogb914)
                   LET l_ogb.ogb912 = l_ogb.ogb912 / l_ogb.ogb911
              WHEN '3'
                   LET l_ogb.ogb912 = l_icy.icy12
            END CASE
            LET l_ogb.ogb912 = s_digqty(l_ogb.ogb912,l_ogb.ogb910)   #FUN-910088--add--
            LET l_ogb.ogb915 = s_digqty(l_ogb.ogb915,l_ogb.ogb913)   #FUN-910088--add--
         END IF
         LET l_ogb.ogb12 = l_icy.icy12
         LET l_ogb.ogb12 = s_digqty(l_ogb.ogb12,l_ogb.ogb05)     #FUN-910088--add--
         LET l_ogb.ogb917 = l_icy.icy12
         LET l_ogb.ogb917 = s_digqty(l_ogb.ogb917,l_ogb.ogb916)   #FUN-910088--add--
 
         IF g_oga213 = 'N' THEN   #稅前
#           LET l_ogb.ogb14  = l_ogb.ogb13 * l_ogb.ogb12    #CHI-B70039 mark
            LET l_ogb.ogb14  = l_ogb.ogb917 * l_ogb.ogb13   #CHI-B70039
            LET l_ogb.ogb14t = l_ogb.ogb14 * (1+g_oga211/100)
         ELSE
#           LET l_ogb.ogb14t = l_ogb.ogb13 * l_ogb.ogb12    #CHI-B70039 mark
            LET l_ogb.ogb14t = l_ogb.ogb917 * l_ogb.ogb13   #CHI-B70039
            LET l_ogb.ogb14  = l_ogb.ogb14t/(1+g_oga211/100)
         END IF
         LET l_ogb.ogb44='1' #No.FUN-870007
         LET l_ogb.ogb47=0   #No.FUN-870007
         IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN    #FUN-AB0061                 
            LET l_ogb.ogb37=l_ogb.ogb13                   #FUN-AB0061                  
         END IF                               #FUN-AB0061      
         LET l_ogb.ogbplant = g_plant #FUN-980004
         LET l_ogb.ogblegal = g_legal #FUN-980004
         #FUN-AB0096 --------add start-------------
         #IF cl_null(l_ogb.ogb50) THEN         #FUN-AC0055 mark
         #   LET l_ogb.ogb50 = '1'             #FUN-AC0055 mark
         #END IF                               #FUN-AC0055 mark
         #FUN-AB0096 -------add end---------------
         #FUN-C50097 ADD BEGIN-----
          IF cl_null(l_ogb.ogb50) THEN 
            LET l_ogb.ogb50 = 0
          END IF 
          IF cl_null(l_ogb.ogb51) THEN 
            LET l_ogb.ogb51 = 0
          END IF 
          IF cl_null(l_ogb.ogb52) THEN 
            LET l_ogb.ogb52 = 0
          END IF  
          IF cl_null(l_ogb.ogb53) THEN 
            LET l_ogb.ogb53= 0
          END IF 
          IF cl_null(l_ogb.ogb54) THEN 
            LET l_ogb.ogb54 = 0
          END IF 
          IF cl_null(l_ogb.ogb55) THEN 
            LET l_ogb.ogb55 = 0
          END IF                                              
          #FUN-C50097 ADD END------- 
         INSERT INTO ogb_file VALUES(l_ogb.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('ins ogb:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH
         ELSE
            #No.FUN-7B0018 080304 add --begin
            IF NOT s_industry('std') THEN
               LET l_ogbi.ogbi01 = l_ogb.ogb01
               LET l_ogbi.ogbi03 = l_ogb.ogb03
               IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                  LET g_success = 'N'
               END IF
            END IF
            #No.FUN-7B0018 080304 add --end  
            LET g_cnt = g_cnt + 1
            CALL ins_ogb_spare(l_icy.icy13) 
         END IF
      END FOREACH
 
      DELETE FROM ogb_file WHERE ogb01 = g_icy01
                             AND ogb03 = g_icy02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('del ogb:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      #No.FUN-7B0018 080304 add --begin
      ELSE
         IF NOT s_industry('std') THEN
            IF NOT s_del_ogbi(g_icy01,g_icy02,'') THEN
               LET g_success = 'N'
            END IF
         END IF
      #No.FUN-7B0018 080304 add --end
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM idb_file
       WHERE idb07 = g_icy01
         AND idb08 = g_icy02
           
      IF l_cnt > 0 THEN
         CALL s_icdinout_del(2,g_icy01,g_icy02,'')  #FUN-B80119--傳入p_plant參數''---
              RETURNING l_flag
         IF l_flag = 0 THEN
            CALL cl_err('del idb:fail','!',1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
  
   IF g_cnt > 0 AND g_success = 'Y' THEN
      CALL t031_upd_seq()
   END IF
   IF g_success = 'Y' THEN
      CALL cl_err('','aic-059',1)
      COMMIT WORK
   ELSE
      CALL cl_err('','aic-060',1)
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t031_upd_seq()
   DEFINE l_ogb  RECORD LIKE ogb_file.*
   DEFINE l_ogbi RECORD LIKE ogbi_file.*
   DEFINE l_ogb913      LIKE ogb_file.ogb913
   DEFINE l_ogb914      LIKE ogb_file.ogb914
   DEFINE l_ogb915      LIKE ogb_file.ogb915 
   DEFINE l_ogb15       LIKE ogb_file.ogb15,
          l_ogb15_fac   LIKE ogb_file.ogb15_fac,
          l_ogb16       LIKE ogb_file.ogb16
   #DEFINE l_imaicd04    LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
   #DEFINE l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
#  DEFINE l_ta_oeb030   LIKE oeb_file.ta_oeb030
   DEFINE l_oebiicd03   LIKE oebi_file.oebiicd03
   DEFINE l_ogb917      LIKE ogb_file.ogb917
#  DEFINE l_ta_ogb020   LIKE ogb_file.ta_ogb020
   DEFINE l_ogbiicd02   LIKE ogbi_file.ogbiicd02
 
   DECLARE t031_upd_seq_cs CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01 = g_icy01
      ORDER BY ogb03
 
   LET g_cnt = 0
   FOREACH t031_upd_seq_cs INTO l_ogb.*
      IF STATUS THEN
         CALL cl_err('t031_upd_seq_cs:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
      
      CALL t031_icd_dies(l_ogb.*) RETURNING l_ogb913,l_ogb914,l_ogb915
      LET l_ogb915 = s_digqty(l_ogb915,l_ogb913)    #FUN-910088--add-- 
    
      #重新賦予庫存明細單位、數量、轉換率的值
      CALL t031_set_ogb16(l_ogb.*) RETURNING l_ogb15,l_ogb15_fac,l_ogb16
 
 
      LET l_ogb917 = l_ogb.ogb917
#     LET l_ta_ogb020 = l_ogb.ta_ogb020 
      LET l_ogbiicd02 = l_ogbi.ogbiicd02
 
      
#     LET l_ta_oeb030 = 0 
      LET l_oebiicd03 = 0 
      #FUN-BA0051 --START mark--
      #LET l_imaicd04 = ''
      #LET l_imaicd08 = '' 
      #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
      #   FROM ima_file,imaicd_file
      #  WHERE ima01 = l_ogb.ogb04
      #    AND ima01 = imaicd00
      #  
      #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin(l_ogb.ogb04) THEN   #FUN-BA0051
#        SELECT ta_oeb030 INTO l_ta_oeb030
         SELECT oebicd03 INTO l_oebiicd03
#           FROM oeb_file
            FROM oeb_file,oebi_file
           WHERE oeb01 = l_ogb.ogb31
             AND oeb03 = l_ogb.ogb32
             AND oeb01=oebi01      
             AND oeb03=oebi03     
#        IF l_ta_oeb030 > 0 THEN
         IF l_oebiicd03 > 0 THEN
            IF l_ogb.ogb916 = l_ogb.ogb910 THEN 
               LET l_ogb917 = l_ogb.ogb12
#              LET l_ta_ogb020 = l_ogb915 * (l_ta_oeb030 /100)
               LET l_ogbiicd02 = l_ogb915 * (l_oebiicd03 /100)
#              CALL cl_digcut(l_ta_ogb020,0) RETURNING l_ta_ogb020
               CALL cl_digcut(l_ogbiicd02,0) RETURNING l_ogbiicd02
            ELSE
#              LET l_ogb917 = l_ogb915 / (1 + l_ta_oeb030/100)
               LET l_ogb917 = l_ogb915 / (1 + l_oebiicd03/100)
               CALL cl_digcut(l_ogb917,0) RETURNING l_ogb917
#              LET l_ta_ogb020 = l_ogb915 - l_ogb917
               LET l_ogbiicd02 = l_ogb915 - l_ogb917
            END IF
         END IF
      END IF
 
      UPDATE ogb_file SET ogb03 = g_cnt,
                          ogb913= l_ogb913,          #單位二
                          ogb914= l_ogb914,          #單位二換算率
                          ogb915= l_ogb915,          #單位二數量
                          ogb15 = l_ogb15,           #庫存明細單位由廠/倉/批自動得出
                          ogb15_fac = l_ogb15_fac,   #銷售/庫存明細單位轉換率
                          ogb16 = l_ogb16 ,          #數量(依庫存明細單位)
                          ogb917 = l_ogb917          #計價單位
#                         ta_ogb020 = l_ta_ogb020    #Spare Part量                   
#                          ogbiicd02 = l_ogbiicd02   #Spare Part量                   
        WHERE ogb01 = l_ogb.ogb01
          AND ogb03 = l_ogb.ogb03
      
        UPDATE ogbi_file SET ogbiicd02=l_ogbiicd02, ogbi03 = g_cnt  #TQC-B80094 add ogbi03 = g_cnt   
              WHERE ogbi01=l_ogb.ogb01 AND ogbi03=l_ogb.ogb03  #FUN-830124
 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd ogb:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      UPDATE idb_file SET idb08 = g_cnt
       WHERE idb07 = l_ogb.ogb01
         AND idb08 = l_ogb.ogb03
         
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd idb:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t031_icd_dies(p_ogb)
   DEFINE p_ogb RECORD LIKE ogb_file.*
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04
   DEFINE l_ogb913     LIKE ogb_file.ogb913
   DEFINE l_ogb914     LIKE ogb_file.ogb914
   DEFINE l_ogb915     LIKE ogb_file.ogb915
   DEFINE l_idb16      LIKE idb_file.idb16
   DEFINE l_ima906     LIKE ima_file.ima906 
 
   LET l_ogb913= ''                           #單位二
   LET l_ogb915= 0                            #單位二數量
   LET l_ogb914= 0                            #單位二轉換率
 
   SELECT imaicd04,ima906 INTO l_imaicd04,l_ima906 
     FROM ima_file,imaicd_file
    WHERE ima01 = p_ogb.ogb04
      AND ima01 = imaicd00
 
   #該料號單位使用為單一單位,單位二相關資訊保留原始狀態不重新計算
    IF l_ima906 = '1' THEN 
      LET l_ogb913= p_ogb.ogb913             #單位二
      LET l_ogb915= p_ogb.ogb915             #單位二數量
      LET l_ogb914= p_ogb.ogb914             #單位二轉換率
      RETURN l_ogb913,l_ogb914,l_ogb915
   END IF   
 
   CASE
      #料件狀態='1.未測Wafer','0.Body'
      WHEN l_imaicd04 = '1' OR l_imaicd04 = '0'
           SELECT SUM(idb16) INTO l_idb16 
              FROM idb_file
             WHERE idb01 = p_ogb.ogb04              #料件
               AND idb02 = p_ogb.ogb09              #倉庫
               AND idb03 = p_ogb.ogb091             #儲位
               AND idb04 = p_ogb.ogb092             #批號
               AND idb07 = p_ogb.ogb01              #單據編號
               AND idb08 = p_ogb.ogb03              #單據項次
               AND idb16 IS NOT NULL
 
            LET l_ogb913= p_ogb.ogb913              #單位二
            LET l_ogb915= l_idb16                   #單位二數量
            LET l_ogb914= p_ogb.ogb912 / l_ogb915   #單位二轉換率
 
      #料件狀態='2.已測Wafer',只加總Pass Bin='Y'的
       WHEN l_imaicd04 = '2'
            SELECT SUM(idb16) INTO l_idb16
               FROM idb_file
             WHERE idb01 =  p_ogb.ogb04       #料件
               AND idb02 =  p_ogb.ogb09       #倉庫
               AND idb03 =  p_ogb.ogb091      #儲位
               AND idb04 =  p_ogb.ogb092      #批號
               AND idb07 =  p_ogb.ogb01       #單據編號
               AND idb08 =  p_ogb.ogb03       #單據項次
               AND idb16 IS NOT NULL
               AND idb20 = 'Y'
 
            LET l_ogb913= p_ogb.ogb913              #單位二
            LET l_ogb915= l_idb16                   #單位二數量
            LET l_ogb914= p_ogb.ogb912 / l_ogb915   #單位二轉換率
 
       #料件狀態=料件狀態='3.未測IC','4.已測IC'
       WHEN l_imaicd04 = '3' OR l_imaicd04 = '4'
            LET l_ogb913= p_ogb.ogb910             #單位二
            LET l_ogb915= p_ogb.ogb912             #單位二數量
            LET l_ogb914= p_ogb.ogb912 /l_ogb915   #單位二換算率
 
       OTHERWISE
            LET l_ogb913= p_ogb.ogb913             #單位二
            LET l_ogb915= p_ogb.ogb915             #單位二數量
            LET l_ogb914= p_ogb.ogb914             #單位二換算率
    END CASE
 
    RETURN l_ogb913,l_ogb914,l_ogb915
END FUNCTION
 
#重新給予庫存明細單位、數量、換算率的值
FUNCTION t031_set_ogb16(p_ogb)
   DEFINE p_ogb  RECORD LIKE ogb_file.*
   DEFINE l_ogb15       LIKE ogb_file.ogb15,
          l_ogb15_fac   LIKE ogb_file.ogb15_fac,
          l_ogb16       LIKE ogb_file.ogb16
   DEFINE l_cnt         LIKE type_file.num5
 
   LET l_cnt = 0
   LET l_ogb15 = p_ogb.ogb15
   LET l_ogb15_fac = p_ogb.ogb15
   LET l_ogb16 = p_ogb.ogb16
 
   SELECT img09 INTO l_ogb15 FROM img_file
      WHERE img01 = p_ogb.ogb04
        AND img02 = p_ogb.ogb09
        AND img03 = p_ogb.ogb091
        AND img04 = p_ogb.ogb092
   IF p_ogb.ogb05 = l_ogb15 THEN
      LET l_ogb15_fac =1
   ELSE
      #檢查該發料單位與主檔之單位是否可以轉換
      CALL s_umfchk(p_ogb.ogb04,p_ogb.ogb05,l_ogb15)
             RETURNING l_cnt,l_ogb15_fac
      IF l_cnt = 1 THEN
         CALL cl_err('','aic-058',1)
      END IF
   END IF
 
   IF cl_null(l_ogb15) THEN LET l_ogb15 = p_ogb.ogb05 END IF
   IF cl_null(l_ogb15_fac) THEN LET l_ogb15_fac = 1 END IF
   LET l_ogb16 = p_ogb.ogb12 * l_ogb15_fac
   LET l_ogb16 = s_digqty(l_ogb16,l_ogb15)    #FUN-910088--add--
 
   RETURN l_ogb15,l_ogb15_fac,l_ogb16
 
END FUNCTION 
 
FUNCTION ins_ogb_spare(p_icy13)
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   DEFINE l_imaicd04  LIKE imaicd_file.imaicd04
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_icy13     LIKE ogb_file.ogb03
   DEFINE l_idb       RECORD LIKE idb_file.*
#  DEFINE l_sum       LIKE ogb_file.ta_ogb020,
   DEFINE l_sum       LIKE ogbi_file.ogbiicd02,
          l_idb11_old LIKE idb_file.idb11,
          l_idb11_new LIKE idb_file.idb11,
          l_die       LIKE idb_file.idb16
   DEFINE l_ogbi      RECORD LIKE ogbi_file.* #No.FUN-7B0018
 
   INITIALIZE l_ogb.* TO NULL
 
   #需要另外INSERT一筆spare_part
   IF l_spare_part = 'Y' AND g_success = 'Y' THEN
 
      LET l_spare_qtysum = l_spare_qtysum + l_spare_qty
      LET l_spare_part = 'N'
 
      SELECT * INTO l_ogb.* FROM ogb_file
         WHERE ogb01 = g_icy01
           AND ogb03 = g_icy02
 
      LET l_ogb.ogb03 = g_seq
      LET g_seq = g_seq + 1
      LET l_ogb.ogb09  = l_spare_part_ogb09
      LET l_ogb.ogb091 = l_spare_part_ogb091
      LET l_ogb.ogb092 = l_spare_part_ogb092
 
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04
        FROM ima_file,imaicd_file
       WHERE ima01 = l_ogb.ogb04
         AND ima01 = imaicd00
 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM jce_file
       WHERE jce02 = l_ogb.ogb09
         AND jceacti = 'Y'
      IF SQLCA.SQLCODE OR cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF
 
      IF l_imaicd04 MATCHES '[1234]' AND l_cnt > 0 THEN
#        LET l_ogb.ta_ogb010 = 'Y'
         LET l_ogbi.ogbiicd01= 'Y'
      ELSE
#        LET l_ogb.ta_ogb010 = 'N'
         LET l_ogbi.ogbiicd01 = 'N'
      END IF
      LET l_ogb.ogb12 = l_spare_qty
      LET l_ogb.ogb12 = s_digqty(l_ogb.ogb12,l_ogb.ogb05)    #FUN-910088--add--
      LET l_ogb.ogb917 = l_spare_qty
      LET l_ogb.ogb917 = s_digqty(l_ogb.ogb917,l_ogb.ogb916)   #FUN-910088--add--
#     LET l_ogb.ta_ogb020 = 0
      LET l_ogbi.ogbiicd02 = 0
#     LET l_ogb.ta_ogb030 = '2'
      LET l_ogbi.ogbiicd03 = '2'
      LET l_ogb.ogb13 = 0
      LET l_ogb.ogb14 = 0
      LET l_ogb.ogb14t = 0
 
      LET g_ima906 = NULL
      SELECT ima906 INTO g_ima906
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
      IF g_sma.sma115 = 'Y' THEN
         CASE g_ima906
            WHEN '1'
                 LET l_ogb.ogb912 = l_ogb.ogb12
            WHEN '2'
                 LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                 LET l_n = l_ogb.ogb915
                 LET l_ogb.ogb915 = l_n
                 LET l_ogb.ogb912 = l_ogb.ogb12 -
                                   (l_ogb.ogb915 * l_ogb.ogb914)
                 LET l_ogb.ogb912 = l_ogb.ogb912 / l_ogb.ogb911
            WHEN '3'
                 LET l_ogb.ogb912 = l_ogb.ogb12
         END CASE
         LET l_ogb.ogb912 = s_digqty(l_ogb.ogb912,l_ogb.ogb910)    #FUN-910088--add--
         LET l_ogb.ogb915 = s_digqty(l_ogb.ogb915,l_ogb.ogb913)    #FUN-910088--add--
      END IF
 
      IF g_oga213 = 'N' THEN                                  #稅前
#        LET l_ogb.ogb14 = l_ogb.ogb13 * l_ogb.ogb12    #CHI-B70039 mark
         LET l_ogb.ogb14 = l_ogb.ogb917 * l_ogb.ogb13   #CHI-B70039
         LET l_ogb.ogb14t = l_ogb.ogb14 * (1 + g_oga211/100)
      ELSE
#        LET l_ogb.ogb14t = l_ogb.ogb13 * l_ogb.ogb12    #CHI-B70039 mark
         LET l_ogb.ogb14t = l_ogb.ogb917 * l_ogb.ogb13   #CHI-B70039
         LET l_ogb.ogb14  = l_ogb.ogb14t / (1 + g_oga211/100)
      END IF
      LET l_ogb.ogb44='1' #No.FUN-870007
      LET l_ogb.ogb47=0   #No.FUN-870007
      IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN    #FUN-AB0061           
         LET l_ogb.ogb37=l_ogb.ogb13                   #FUN-AB0061           
      END IF                               #FUN-AB0061   
      LET l_ogb.ogbplant = g_plant #FUN-980004
      LET l_ogb.ogblegal = g_legal #FUN-980004
      #FUN-AB0096 ----------add start-----------
      #IF cl_null(l_ogb.ogb50) THEN    #FUN-AC0055 mark
      #   LET l_ogb.ogb50 = '1'        #FUN-AC0055 mark
      #END IF                          #FUN-AC0055 mark
      #FUN-AB0096 ----------add end--------------
       #FUN-C50097 ADD BEGIN-----
       IF cl_null(l_ogb.ogb50) THEN 
         LET l_ogb.ogb50 = 0
       END IF 
       IF cl_null(l_ogb.ogb51) THEN 
         LET l_ogb.ogb51 = 0
       END IF 
       IF cl_null(l_ogb.ogb52) THEN 
         LET l_ogb.ogb52 = 0
       END IF                                      
       IF cl_null(l_ogb.ogb53) THEN 
         LET l_ogb.ogb53= 0
       END IF 
       IF cl_null(l_ogb.ogb54) THEN 
         LET l_ogb.ogb54 = 0
       END IF 
       IF cl_null(l_ogb.ogb55) THEN 
         LET l_ogb.ogb55 = 0
       END IF 
       #FUN-C50097 ADD END-------      
      INSERT INTO ogb_file VALUES(l_ogb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('ins ogb:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      ELSE
         #No.FUN-7B0018 080304 add --begin
         IF NOT s_industry('std') THEN
            LET l_ogbi.ogbi01 = l_ogb.ogb01
            LET l_ogbi.ogbi03 = l_ogb.ogb03
            IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
               LET g_success = 'N'
            END IF
         END IF
         #No.FUN-7B0018 080304 add --end  
         LET g_cnt = g_cnt + 1
      END IF
 
   #處理spare part項次的idb_file
   DECLARE sel_idb CURSOR FOR 
      SELECT * FROM idb_file
         WHERE idb07 = g_icy01
           AND idb08 = p_icy13
         ORDER BY idb11 DESC
 
   LET l_sum = 0 
   FOREACH sel_idb INTO l_idb.*
      IF l_sum = l_spare_qty THEN
         CONTINUE FOREACH
      END IF
      IF l_idb.idb11 >= (l_spare_qty - l_sum) THEN
         LET l_idb11_new = (l_spare_qty - l_sum)
         LET l_idb11_old = l_idb.idb11 -(l_spare_qty - l_sum)
      ELSE
         LET l_idb11_new = l_idb.idb11
         LET l_idb11_old = 0 
      END IF
      LET l_sum = l_sum + l_idb11_new
      
      #更新來源資料的idb_file
      LET l_die = l_idb.idb16 * 
                 (l_idb11_old/l_idb.idb11)
      LET l_idb11_old = s_digqty(l_idb11_old,l_idb.idb12)     #FUN-BB0085 
      IF l_idb11_old <= 0 THEN
         DELETE FROM idb_file
            WHERE idb07 = l_idb.idb07
              AND idb08 = l_idb.idb08  
              AND idb01 = l_idb.idb01
              AND idb02 = l_idb.idb02
              AND idb03 = l_idb.idb03
              AND idb04 = l_idb.idb04
              AND idb05 = l_idb.idb05
              AND idb06 = l_idb.idb06
      ELSE
        #UPDATE idb_file SET idb11 = l_idb110_old,      #FUN-BB0085 mark
         UPDATE idb_file SET idb11 = l_idb11_old,       #FUN-BB0085
                             idb16 = l_die
            WHERE idb07 = l_idb.idb07
              AND idb08 = l_idb.idb08  
              AND idb01 = l_idb.idb01
              AND idb02 = l_idb.idb02
              AND idb03 = l_idb.idb03
              AND idb04 = l_idb.idb04
              AND idb05 = l_idb.idb05
              AND idb06 = l_idb.idb06
      END IF
 
      #產生spare part 項次的idb_file
      LET l_idb.idb08 = g_seq - 1             #項次
      LET l_idb.idb11 = l_idb11_new           #出庫數量
      LET l_idb.idb11 = s_digqty(l_idb.idb11,l_idb.idb12)  #FUN-BB0085
      LET l_idb.idb16 = l_idb.idb16 - l_die
 
      LET l_idb.idbplant = g_plant #FUN-980004
      LET l_idb.idblegal = g_legal #FUN-980004
      INSERT INTO idb_file VALUES(l_idb.*)
 
   END FOREACH
END IF
END FUNCTION 
