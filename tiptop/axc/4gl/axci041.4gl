# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axci041.4gl
# Descriptions...: 成本中心成本項目分攤方式設置作業
# Date & Author..: No.FUN-7C0101 08/01/21 By Cockroach
# Modify.........: No.FUN-830135 08/03/28 By douzh 補過單
# Modify.........: No.MOD-840395 08/04/21 By Sarah 限制相同"成本中心+成本項目"其分攤方式(cda06)需一致
# Modify.........: No.FUN-840181 08/06/11 By Sherry 增加實際機時
# Modify.........: No.FUN-8B0047 08/11/12 By Sherry 增加製費類別,標準產量
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-920010 09/02/04 By jan 1.新增'類別' '部門'欄位 2.key 值 新增cda04
# Modify.........: No.FUN-920011 09/02/06 By jan 新增 '整批產生' action
# Modify.........: No.CHI-920067 09/03/03 By Pengu 當ccz06設定為1時成本中心應要可輸入空白
# Modify.........: No.MOD-950001 09/05/21 By Pengu 再抓取會計科目時應加上aag07 <> '1' and aag03 ='2' 的條件
# Modify.........: No.FUN-960024 09/06/05 By jan .key 值 新增cda10
# Modify.........: No.TQC-970158 09/07/20 By destiny cda05增加管控 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-960195 09/10/20 By Pengu 未控管不可輸入統制帳戶科目
# Modify.........: No:MOD-980017 09/11/25 By sabrina 1.執行ACTION整批產生，發生錯誤
#                                                    2.insert cda_file失敗的錯誤訊息顯示cds_file應是cda_file才對
# Modify.........: No.FUN-9C0073 10/01/11 By chenls  程序精簡
# Modify.........: No:MOD-A30104 10/07/23 By Pengu 當ccz26='3'時，成本中心無法開窗
# Modify.........: No:MOD-A20059 10/07/27 By Pengu 當成本項目為人工時，製費類別欄位不可維護
# Modify.........: No:MOD-AB0112 10/11/11 By sabrina 當ccz06='1'時，整批產生的成本中心應要為' '
# Modify.........: No:FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:MOD-B10229 11/01/27 By sabrina (1)整批產生時成本項目選"1"製費類別是空
#                                                    (2)當成本項目選"1"時，製費類別要為"2：變動"
# Modify.........: No:FUN-B40004 11/04/06 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控 
# Modify.........: No:MOD-B60125 11/06/15 By sabrina aag01的開窗資料有誤
# Modify.........: No:MOD-B70282 11/08/18 By Vampire 當tm.cda02!='1'時,將tm.cda08設定為必輸欄位
# Modify.........: No:MOD-BC0093 11/12/09 By johung 調整AFTER FIELD cda08時cda09欄位entry控卡
# Modify.........: No:MOD-C10033 12/01/05 By ck2yuan close window 代碼錯誤 及 cda01查詢時開窗錯誤
# Modify.........: No:TQC-C70097 12/07/16 By lujh 當axcs010中設置ccz06=‘4’時 ‘成本中心’欄位無法開窗，報錯:作業錯誤,
#                                                 請通報 MIS! 動態查詢視窗 q_eca 未存在設置資料,請匯報資管部門處理!
# Modify.........: No:CHI-C40026 12/08/13 By ck2yuan 畫面上新增一個欄位  '科目名稱'
# Modify.........: No:MOD-CA0046 12/10/26 By Elise 單身新增時，需顯示科目名稱
# Modify.........: No:MOD-D30063 13/03/08 By ck2ayun 按F1新增後，再按取消，該空白行會留著。
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cda           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
                 cda01  LIKE cda_file.cda01,
                 cda02  LIKE cda_file.cda02,
                 cda04  LIKE cda_file.cda04,    #FUN-920010
                 cda05  LIKE cda_file.cda05,
                 aag02  LIKE aag_file.aag02,    #CHI-C40026 add
                 cda06  LIKE cda_file.cda06,
                 cda07  LIKE cda_file.cda07,
                 cda08  LIKE cda_file.cda08,    #FUN-8B0047
                 cda09  LIKE cda_file.cda09,    #FUN-8B0047
                 cda10  LIKE cda_file.cda10,    #FUN-920010
                 gem02  LIKE gem_file.gem02     #FUN-920010
                    END RECORD,
    g_cda_t         RECORD                 
                 cda01  LIKE cda_file.cda01,
                 cda02  LIKE cda_file.cda02,
                 cda04  LIKE cda_file.cda04,    #FUN-920010
                 cda05  LIKE cda_file.cda05,
                 aag02  LIKE aag_file.aag02,    #CHI-C40026 add
                 cda06  LIKE cda_file.cda06,
                 cda07  LIKE cda_file.cda07,
                 cda08  LIKE cda_file.cda08,    #FUN-8B0047
                 cda09  LIKE cda_file.cda09,    #FUN-8B0047
                 cda10  LIKE cda_file.cda10,    #FUN-920010
                 gem02  LIKE gem_file.gem02     #FUN-920010
                    END RECORD,
     g_wc2,g_sql    string,  
    g_rec_b         LIKE type_file.num5,               
    l_ac            LIKE type_file.num5                
 
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done      LIKE type_file.num5           
DEFINE   g_chr           LIKE type_file.chr1         
DEFINE   g_cnt           LIKE type_file.num10         
DEFINE   g_msg           LIKE type_file.chr1000      
MAIN
#     DEFINEl_time LIKE type_file.chr8            
DEFINE p_row,p_col   LIKE type_file.num5              
 
    OPTIONS                                
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time   
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW i041_w AT p_row,p_col WITH FORM "axc/42f/axci041"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i041_b_fill(g_wc2)
    CALL i041_menu()
    CLOSE WINDOW i041_w                     
      CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time   
END MAIN
 
FUNCTION i041_menu()
 
   WHILE TRUE
      CALL i041_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i041_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i041_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL i041_out()
            END IF  
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "generate"      #批次產生
            IF cl_chk_act_auth() THEN
               CALL i041_g()
            END IF
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cda),'','')
             END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i041_q()
   CALL i041_b_askkey()
END FUNCTION
 
FUNCTION i041_b()
DEFINE l_cda06         LIKE cda_file.cda06, 
       l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,              
       l_lock_sw       LIKE type_file.chr1,               
       l_aag07         LIKE aag_file.aag07,    #No:MOD-960195 add
       p_cmd           LIKE type_file.chr1,             
       l_allow_insert  LIKE type_file.chr1,                        
       l_allow_delete  LIKE type_file.chr1,                           
       l_flag          LIKE type_file.chr1,    #MOD-840395 add
       l_cnt           LIKE type_file.num5     #No.TQC-970158
DEFINE l_aag05         LIKE aag_file.aag05     #No.FUN-B40004
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT cda01,cda02,cda04,cda05,cda06,cda07,cda08,cda09,cda10,''  FROM cda_file", #FUN-8B0047 #FUN-920010 add cda04,cda10,''  #CHI-C40026 mark
    LET g_forupd_sql = "SELECT cda01,cda02,cda04,cda05,'',cda06,cda07,cda08,cda09,cda10,''  FROM cda_file", #CHI-C40026 add
                       " WHERE cda01=? AND cda02=? AND cda04=? AND cda05=? AND cda10=? FOR UPDATE"  #FUN-920010 add cda04 #FUN-960024 add cda10
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_cda WITHOUT DEFAULTS FROM s_cda.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_cda_t.* = g_cda[l_ac].*  #BACKUP
 
            LET g_before_input_done = FALSE
            CALL i041_set_entry_b(p_cmd)
            CALL i041_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
            BEGIN WORK
 
            OPEN i041_bcl USING g_cda_t.cda01,g_cda_t.cda02,g_cda_t.cda04,g_cda_t.cda05,g_cda_t.cda10  #FUN-920010 add g_cda_t.cda04 #FUN-960024 add cda10
            IF STATUS THEN
               CALL cl_err("OPEN i041_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i041_bcl INTO g_cda[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_cda_t.cda01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
                IF g_cda[l_ac].cda06 ='4'THEN                                                                                             
                   CALL cl_set_comp_entry("cda07",TRUE)                                                                                  
                ELSE                                                                                                                      
                   CALL cl_set_comp_entry("cda07",FALSE)                                                                                 
                END IF                          
                IF g_cda[l_ac].cda04 ='1'THEN                                                                                             
                   CALL cl_set_comp_entry("cda10",TRUE)                                                                                  
                ELSE                                                                                                                      
                   CALL cl_set_comp_entry("cda10",FALSE)                                                                                 
                END IF              
                SELECT gem02 INTO g_cda[l_ac].gem02 FROM gem_file
                 WHERE gem01 = g_cda[l_ac].cda10

                SELECT aag02 INTO g_cda[l_ac].aag02 FROM aag_file     #CHI-C40026 add
                 WHERE aag00=g_aza.aza81 AND aag01=g_cda[l_ac].cda05  #CHI-C40026 add
            END IF
 
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
 
         LET g_before_input_done = FALSE
         CALL i041_set_entry_b(p_cmd)
         CALL i041_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 
         INITIALIZE g_cda[l_ac].* TO NULL     
         LET g_cda[l_ac].cda08='2'      #FUN-8B0047
         LET g_cda_t.* = g_cda[l_ac].*        
         CALL cl_show_fld_cont()    
         NEXT FIELD cda01
 
      AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CALL g_cda.deleteElement(l_ac)  
            IF g_rec_b != 0 THEN
              LET g_action_choice = "detail"
            END IF
            EXIT INPUT
         END IF
        #限制相同"成本中心(cda01)+成本項目(cdb02)"其分攤方式(cda06)需一致
 
         IF g_cda[l_ac].cda05 !=g_cda_t.cda05 OR
            g_cda[l_ac].cda02 !=g_cda_t.cda02 OR
            g_cda[l_ac].cda04 !=g_cda_t.cda04 OR  #FUN-960024
            g_cda[l_ac].cda10 !=g_cda_t.cda10 OR  #FUN-960024
            g_cda[l_ac].cda01 !=g_cda_t.cda01 THEN
            SELECT COUNT(*) INTO g_cnt  FROM cda_file
             WHERE cda01=g_cda[l_ac].cda01
               AND cda02=g_cda[l_ac].cda02
               AND cda05=g_cda[l_ac].cda05
               AND cda04=g_cda[l_ac].cda04   #FUN-920010
               AND cda10=g_cda[l_ac].cda10   #FUN-960024
            IF g_cnt > 0  THEN
               LET g_msg=g_cda[l_ac].cda01 CLIPPED,'+',g_cda[l_ac].cda02 CLIPPED,'+',g_cda[l_ac].cda04, #FUN-920010 add cda04
                   '+',g_cda[l_ac].cda05 CLIPPED ,'+',g_cda[l_ac].cda10 CLIPPED   #FUN-960024 add cda10
               LET STATUS=-239
               CALL cl_err(g_msg,STATUS,1) NEXT FIELD cda05
            END IF
         END IF
         IF cl_null(g_cda[l_ac].cda01) THEN LET g_cda[l_ac].cda01 = ' ' END IF   #No.CHI-920067 add
         IF cl_null(g_cda[l_ac].cda10) THEN LET g_cda[l_ac].cda10 = ' ' END IF  #FUN-920010
         INSERT INTO cda_file(cda01,cda02,cda04,cda05,cda06,cda07,cda08,cda09,cda10) #FUN-8B0047 #FUN-920010 add cda04,cda10
         VALUES(g_cda[l_ac].cda01,g_cda[l_ac].cda02,g_cda[l_ac].cda04,  #FUN-920010 add cda04
                g_cda[l_ac].cda05,g_cda[l_ac].cda06,
                g_cda[l_ac].cda07,
                g_cda[l_ac].cda08,g_cda[l_ac].cda09,g_cda[l_ac].cda10) #FUN-8B0047  #FUN-920010 add cda10
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","cda_file",g_cda[l_ac].cda01,g_cda[l_ac].cda05,SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD cda01                        #check 
         IF NOT cl_null(g_cda[l_ac].cda01) THEN
            CASE g_ccz.ccz06
               WHEN '3'
                  SELECT COUNT(*) INTO g_cnt
                    FROM ecd_file
                   WHERE ecd01 = g_cda[l_ac].cda01
                     AND ecdacti='Y'
               WHEN '4'
                  SELECT COUNT(*) INTO g_cnt
                    FROM eca_file
                   WHERE eca01 = g_cda[l_ac].cda01
                     AND ecdacti='Y'
               OTHERWISE
                  SELECT COUNT(*) INTO g_cnt
                    FROM gem_file
                   WHERE gem01 = g_cda[l_ac].cda01
                     AND gemacti='Y'
            END CASE
            LET INT_FLAG = 0  
            IF g_cnt =0 AND (p_cmd='a' OR g_chkey='Y') THEN    
               CALL cl_err('','anm-071',1)
               NEXT FIELD cda01
            END IF
         END IF
 
     #-------------No:MOD-A20059 add
      BEFORE FIELD cda02
         CALL i041_set_entry_b(p_cmd)
     #-------------No:MOD-A20059 end

      AFTER FIELD cda02
         IF NOT cl_null(g_cda[l_ac].cda02) THEN 
            IF g_cda[l_ac].cda02 NOT MATCHES '[123456]' THEN
               NEXT FIELD cda02
            END IF
           #MOD-B10229---add---start---
            IF g_cda[l_ac].cda02 = '1' THEN
               LET g_cda[l_ac].cda08 = '2'
               DISPLAY BY NAME g_cda[l_ac].cda08
            END IF
           #MOD-B10229---add---end---
         END IF              
         CALL i041_set_no_entry_b(p_cmd)   #No:MOD-A20059 add
 
      AFTER FIELD cda04
        IF g_cda[l_ac].cda04 IS NOT NULL THEN
           IF g_cda[l_ac].cda04 ='1'THEN                                                                                             
              CALL cl_set_comp_entry("cda10",TRUE)                                                                                  
           ELSE                                                                                                                      
              CALL cl_set_comp_entry("cda10",FALSE)                                                                                 
              LET g_cda[l_ac].cda10 = ' '
              DISPLAY BY NAME g_cda[l_ac].cda10
           END IF
        ELSE
           NEXT FIELD cda01          
        END IF        
 
      AFTER FIELD cda05
         IF g_cda[l_ac].cda05 IS NOT NULL THEN
#FUN-B10052 --begin--            
            SELECT count(*) INTO l_cnt FROM aag_file
             WHERE aag07 <> '1' AND aag03 ='2' AND aagacti = 'Y'
               AND aag00 = g_aza.aza81 AND aag01=g_cda[l_ac].cda05
            IF l_cnt=0 THEN 
                CALL cl_err('','mfg0018',0)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag07"  
                LET g_qryparam.default1 = g_cda[l_ac].cda05
                LET g_qryparam.arg1 = g_aza.aza81               
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag01 LIKE '",g_cda[l_ac].cda05 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_cda[l_ac].cda05
                DISPLAY g_cda[l_ac].cda05 TO cda05                
               NEXT FIELD cda05
            END IF 
#FUN-B10052 --end--        
            IF g_cda[l_ac].cda05 !=g_cda_t.cda05 OR
               g_cda[l_ac].cda02 !=g_cda_t.cda02 OR
               g_cda[l_ac].cda01 !=g_cda_t.cda01 OR
               g_cda[l_ac].cda04 !=g_cda_t.cda04 OR    #FUN-920010
               g_cda[l_ac].cda10 !=g_cda_t.cda10 OR    #FUN-960024
               g_cda_t.cda05 IS NULL OR 
               g_cda_t.cda02 IS NULL OR g_cda_t.cda01 IS NULL OR
               g_cda_t.cda04 IS NULL OR g_cda_t.cda10 IS NULL THEN           #FUN-920010 #FUN-960024 cda10
               SELECT aag07 INTO l_aag07 FROM aag_file
                      WHERE aag01=g_cda[l_ac].cda05
                        AND aag00=g_aza.aza81 
               IF l_aag07 !='2' AND  l_aag07 !='3' THEN
                  CALL cl_err(g_cda[l_ac].cda05,'agl-015',0)
                  NEXT FIELD cda05
               END IF
              SELECT COUNT(*) INTO g_cnt  FROM cda_file
              WHERE cda01=g_cda[l_ac].cda01
                AND cda02=g_cda[l_ac].cda02
                AND cda05=g_cda[l_ac].cda05
                AND cda04=g_cda[l_ac].cda04            #FUN-920010
                AND cda10=g_cda[l_ac].cda10            #FUN-960024
              IF g_cnt > 0  THEN
                LET g_msg=g_cda[l_ac].cda01 CLIPPED,'+',g_cda[l_ac].cda02 CLIPPED,'+',g_cda[l_ac].cda04,  #FUN-920010 add cda04
                      '+',g_cda[l_ac].cda05 CLIPPED,'+',g_cda[l_ac].cda10 CLIPPED  #fun-960024 add cda10  
                LET STATUS=-239
                CALL cl_err(g_msg,STATUS,1) 
                NEXT FIELD cda05
              END IF
             #MOD-CA0046 add---S
              SELECT aag02
                INTO g_cda[l_ac].aag02
                FROM aag_file
               WHERE aag00=g_aza.aza81 
                 AND aag01=g_cda[l_ac].cda05
             #MOD-CA0046 add---E
            END IF
#FUN-B10052 --begin--            
#            SELECT count(*) INTO l_cnt FROM aag_file
#             WHERE aag07 <> '1' AND aag03 ='2' AND aagacti = 'Y'
#               AND aag00 = g_aza.aza81 AND aag01=g_cda[l_ac].cda05
#            IF l_cnt=0 THEN 
#               CALL cl_err('','mfg0018',1)
#               LET g_cda[l_ac].cda05=g_cda_t.cda05
#               NEXT FIELD cda05
#            END IF 
#FUN-B10052 --end--            
         END IF
 
      BEFORE FIELD cda06
         #相同"成本中心(cda01)+成本項目(cdb02)"帶入別筆cda06
         SELECT DISTINCT cda06 INTO g_cda[l_ac].cda06 FROM cda_file
          WHERE cda01=g_cda[l_ac].cda01 AND cda02=g_cda[l_ac].cda02
         DISPLAY g_cda[l_ac].cda06 TO s_cda[l_ac].cda06
 
      AFTER FIELD cda06
         IF NOT cl_null(g_cda[l_ac].cda06) THEN
            IF g_cda[l_ac].cda06 NOT MATCHES '[12345]' THEN  #FUN-840181
               NEXT FIELD cda06
            ELSE
               #限制相同"成本中心(cda01)+成本項目(cdb02)"其分攤方式(cda06)需一致
               LET l_flag = 'Y'
               CALL i041_cda06(p_cmd) RETURNING l_flag,g_cda[l_ac].cda06
               IF l_flag ='N' THEN
                  #同一成本中心+成本項目其分攤方式只能有一種！
                  CALL cl_err('','axc-295',0)
                  DISPLAY g_cda[l_ac].cda06 TO s_cda[l_ac].cda06
                  NEXT FIELD cda06
               END IF
            END IF
         END IF 
         IF g_cda[l_ac].cda06 ='4'THEN                                                                                             
            CALL cl_set_comp_entry("cda07",TRUE)                                                                                  
         ELSE                                                                                                                      
            CALL cl_set_comp_entry("cda07",FALSE)
            IF g_cda[l_ac].cda07 IS NULL OR g_cda[l_ac].cda07 <> '0' THEN
               LET g_cda[l_ac].cda07 = '0' 
            END IF      
            DISPLAY g_cda[l_ac].cda07 TO s_cda[l_ac].cda07                                                                                    
         END IF         
                                                                                                          
      ON CHANGE cda06
         IF g_cda[l_ac].cda06 ='4'THEN                                                                                             
            CALL cl_set_comp_entry("cda07",TRUE)                                                                                  
         ELSE                                                                                                                      
            CALL cl_set_comp_entry("cda07",FALSE)                                                                                 
            IF g_cda[l_ac].cda07 IS NULL OR g_cda[l_ac].cda07 <> '0' THEN                                                         
               LET g_cda[l_ac].cda07 = '0'                                                                                        
            END IF                                                               
            DISPLAY g_cda[l_ac].cda07 TO s_cda[l_ac].cda07                                                                                    
         END IF 
      BEFORE FIELD cda07
         LET l_cda06 = get_fldbuf(s_cda[l_ac].cda06)        
         IF l_cda06 ='4'THEN
            CALL cl_set_comp_entry("cda07",TRUE)
         ELSE 
            CALL cl_set_comp_entry("cda07",FALSE)    
            IF g_cda[l_ac].cda07 IS NULL OR g_cda[l_ac].cda07 <> '0' THEN                                                         
               LET g_cda[l_ac].cda07 = '0'                                                                                        
            END IF                                                               
            DISPLAY g_cda[l_ac].cda07 TO s_cda[l_ac].cda07   
         END IF
 
      AFTER FIELD cda07
         IF cl_null(g_cda[l_ac].cda07) THEN
            NEXT FIELD cda07            
         END IF 
 
      BEFORE FIELD cda08
         CALL i041_set_entry_b(p_cmd)
         CALL i041_set_no_entry_b(p_cmd)   #No:MOD-A20059 add
 
      AFTER FIELD cda08
         IF cl_null(g_cda[l_ac].cda08) THEN
            NEXT FIELD cda08            
         END IF 
         CALL i041_set_entry_b(p_cmd)   #MOD-BC0093 add
         CALL i041_set_no_entry_b(p_cmd)
 
      BEFORE FIELD cda09
         CALL i041_set_entry_b(p_cmd)
 
      AFTER FIELD cda09
         IF cl_null(g_cda[l_ac].cda09) THEN
            NEXT FIELD cda09            
         END IF 
 
      AFTER FIELD cda10
        IF g_cda[l_ac].cda10 IS NOT NULL THEN
           IF g_cda_t.cda10 IS NULL OR
              (g_cda[l_ac].cda10 != g_cda_t.cda10) THEN
              CALL i041_cda10(p_cmd)
               #No.FUN-B40004  --End
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_cda[l_ac].cda10,g_errno,0)
                 LET g_cda[l_ac].cda10 = g_cda_t.cda10
                 LET g_errno=' '   #No.FUN-B40004 add
                 DISPLAY BY NAME g_cda[l_ac].cda10
                 NEXT FIELD cda10
              END IF
              SELECT COUNT(*) INTO l_n FROM gem_file
               WHERE gem01 = g_cda[l_ac].cda10
                 AND gemacti = 'Y'
              IF l_n = 0 THEN
                 CALL cl_err('','anm-071',0)
                 NEXT FIELD cda10
              END IF
              #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_cda[l_ac].cda05
                  AND aag00 = g_aza.aza81
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_cda[l_ac].cda05,g_cda[l_ac].cda10,g_aza.aza81)
                          RETURNING g_errno
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cda[l_ac].cda10,g_errno,0)
                     LET g_cda[l_ac].cda10 = g_cda_t.cda10
                     LET g_errno=' '
                     DISPLAY BY NAME g_cda[l_ac].cda10
                     NEXT FIELD cda10
                  END IF
               END IF
           END IF
        ELSE
           LET g_cda[l_ac].cda10 = ' '
        END IF 
        LET g_cnt = 0
        IF cl_null(g_cda[l_ac].cda01) THEN LET g_cda[l_ac].cda01 = ' ' END IF
        IF (p_cmd='u' AND (g_cda[l_ac].cda10 != g_cda_t.cda10)) OR p_cmd='a' THEN   #No.TQC-970158
           SELECT COUNT(*) INTO g_cnt  FROM cda_file 
            WHERE cda01=g_cda[l_ac].cda01
              AND cda02=g_cda[l_ac].cda02
              AND cda05=g_cda[l_ac].cda05
              AND cda04=g_cda[l_ac].cda04
              AND cda10=g_cda[l_ac].cda10 
           IF g_cnt > 0  THEN
              LET g_msg=g_cda[l_ac].cda01 CLIPPED,'+',g_cda[l_ac].cda02 CLIPPED,'+',g_cda[l_ac].cda04,
                        '+',g_cda[l_ac].cda05 CLIPPED,'+',g_cda[l_ac].cda10 CLIPPED 
              LET STATUS=-239
              CALL cl_err(g_msg,STATUS,1)
              NEXT FIELD cda10 
           END IF
        END IF                                           #No.TQC-970158
         
      BEFORE DELETE                           
         IF g_cda_t.cda01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM cda_file WHERE cda01=g_cda_t.cda01
                                   AND cda02=g_cda_t.cda02
                                   AND cda04=g_cda_t.cda04     #FUN-920010
                                   AND cda05=g_cda_t.cda05
                                   AND cda10=g_cda_t.cda10     #FUN-960024
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","cda_file",g_cda_t.cda01,g_cda_t.cda02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE "Delete OK"
            CLOSE i041_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN              
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cda[l_ac].* = g_cda_t.*
            CLOSE i041_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cda[l_ac].cda01,-263,1)
            LET g_cda[l_ac].* = g_cda_t.*
         ELSE
            UPDATE cda_file SET(cda01,cda02,cda05,cda06,cda07,cda08,cda09,cda04,cda10) #FUN-8B0047  #FUN-920010 add cda04,cda10
                   =(g_cda[l_ac].cda01,g_cda[l_ac].cda02,
                     g_cda[l_ac].cda05,g_cda[l_ac].cda06,
                     g_cda[l_ac].cda07,
                     g_cda[l_ac].cda08,g_cda[l_ac].cda09, #FUN-8B0047
                     g_cda[l_ac].cda04,g_cda[l_ac].cda10) #FUN-920010
            WHERE cda01=g_cda_t.cda01 
              AND cda02=g_cda_t.cda02 
              AND cda04=g_cda_t.cda04    #FUN-920010 
              AND cda05=g_cda_t.cda05
              AND cda10=g_cda_t.cda10    #FUN-960024 
            IF SQLCA.sqlcode THEN  
                CALL cl_err3("upd","cda_file",g_cda[l_ac].cda01,g_cda[l_ac].cda05,SQLCA.sqlcode,"","",1) 
                LET g_cda[l_ac].* = g_cda_t.*
            ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i041_bcl
                COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cda[l_ac].* = g_cda_t.*
           #MOD-D30063 add
            ELSE         
               CALL g_cda.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t             #FUN-D40030 add
               END IF
            END IF
           #MOD-D30063 add
            CLOSE i041_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE i041_bcl
         COMMIT WORK
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cda01)
                CALL cl_init_qry_var() 
                CASE g_ccz.ccz06               
                   WHEN '3'
                     #-------------No:MOD-A30104 modify
                     #LET g_qryparam.form     ="q_ecd"
                     #LET g_qryparam.default1 = g_cda[l_ac].cda01
                     #CALL cl_create_qry() RETURNING g_cda[l_ac].cda01    
                      CALL q_ecd(FALSE,TRUE,g_cda[l_ac].cda01) RETURNING g_cda[l_ac].cda01
                     #-------------No:MOD-A30104 end
                   WHEN '4'
                      #TQC-C70097--mark--str--
                      #LET g_qryparam.form     ="q_eca"
                      #LET g_qryparam.default1 = g_cda[l_ac].cda01
                      #CALL cl_create_qry() RETURNING g_cda[l_ac].cda01     
                      #TQC-C70097--mark--end--
                      CALL q_eca(FALSE,TRUE,g_cda[l_ac].cda01) RETURNING g_cda[l_ac].cda01    #TQC-C70097  add
                   OTHERWISE
                      LET g_qryparam.form     ="q_gem"
                      LET g_qryparam.default1 = g_cda[l_ac].cda01
                      CALL cl_create_qry() RETURNING g_cda[l_ac].cda01
                END CASE
                
                DISPLAY "cda01=",g_cda[l_ac].cda01
                DISPLAY g_cda[l_ac].cda01 TO cda01
                NEXT FIELD cda01
 
             WHEN INFIELD(cda05)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag07"   #MOD-950001 add
                LET g_qryparam.default1 = g_cda[l_ac].cda05
                LET g_qryparam.arg1 = g_aza.aza81               
                CALL cl_create_qry() RETURNING g_cda[l_ac].cda05
                DISPLAY g_cda[l_ac].cda05 TO cda05
                NEXT FIELD cda05
             WHEN INFIELD(cda10)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_gem"
                LET g_qryparam.default1 = g_cda[l_ac].cda10
                CALL cl_create_qry() RETURNING g_cda[l_ac].cda10
                DISPLAY g_cda[l_ac].cda10 TO cda10
                NEXT FIELD cda10
             OTHERWISE
                EXIT CASE
         END CASE
 
      ON ACTION CONTROLN
         CALL i041_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                       
         IF INFIELD(cda01) AND l_ac > 1 THEN
             LET g_cda[l_ac].* = g_cda[l_ac-1].*
             NEXT FIELD cda01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
    END INPUT
 
    CLOSE i041_bcl
    COMMIT WORK
    

END FUNCTION
 
FUNCTION i041_cda06(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1
    DEFINE l_cda06    LIKE cda_file.cda06
    DEFINE l_cda06_t  LIKE cda_file.cda06
    
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM cda_file
     WHERE cda01=g_cda[l_ac].cda01 AND cda02=g_cda[l_ac].cda02
    IF (p_cmd='u' AND g_cnt > 1) OR (p_cmd='a' AND g_cnt > 0) THEN
       #限制相同"成本中心(cda01)+成本項目(cdb02)"其分攤方式(cda06)需一致
       #所以檢查當輸入的cda06的值不等於已存在的,將值改成跟已存在資料庫裡的
       DECLARE cda06_curs CURSOR FOR 
          SELECT DISTINCT cda06 FROM cda_file
           WHERE cda01=g_cda[l_ac].cda01 AND cda02=g_cda[l_ac].cda02
           ORDER BY cda06
 
       FOREACH cda06_curs INTO l_cda06  
          IF l_cda06!=' ' AND g_cda[l_ac].cda06!=l_cda06 THEN
             RETURN 'N',l_cda06
          END IF
       END FOREACH
    END IF
    RETURN 'Y',g_cda[l_ac].cda06
 
END FUNCTION
 
FUNCTION i041_cda10(p_cmd)
DEFINE l_gemacti     LIKE gem_file.gemacti
DEFINE p_cmd         LIKE type_file.chr1
 
    LET g_errno = " " 
    SELECT gem02,gemacti
      INTO g_cda[l_ac].gem02,l_gemacti
      FROM gem_file WHERE gem01=g_cda[l_ac].cda10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-471'                                                                           
                           LET g_cda[l_ac].gem02 = NULL                                                                             
        WHEN l_gemacti='N' LET g_errno = '9028'                                                                                     
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
    END CASE                                  
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY BY NAME g_cda[l_ac].gem02                                                                                             
   END IF
END FUNCTION
 
FUNCTION i041_b_askkey()
    CLEAR FORM
    CALL g_cda.clear()
    CONSTRUCT g_wc2 ON cda01,cda02,cda04,cda05,cda06,cda07,cda08,cda09,cda10     #FUN-920010 add cda04,cda10#FUN-960024
            FROM s_cda[1].cda01,s_cda[1].cda02,s_cda[1].cda04,s_cda[1].cda05,
                 s_cda[1].cda06,s_cda[1].cda07,s_cda[1].cda08,s_cda[1].cda09,s_cda[1].cda10   #FUN-920010 #FUN-960024
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
    ON ACTION controlp   
       CASE
              WHEN INFIELD(cda01)
                 CALL cl_init_qry_var() 
                 CASE g_ccz.ccz06     
                     WHEN '3'
                       #--------------No:MOD-A30104 modify
                       #LET g_qryparam.form     ="q_ecd"
                       #LET g_qryparam.default1 = g_cda[l_ac].cda01
                       #CALL cl_create_qry() RETURNING g_cda[l_ac].cda01                     
                        CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                       #--------------No:MOD-A30104 end
                     WHEN '4'
                        #TQC-C70097--mark--str--
                        #CALL cl_init_qry_var()                                 #No:MOD-A30104 add
                        #LET g_qryparam.form     ="q_eca"
                        #LET g_qryparam.state = "c"                             #No:MOD-A30104 add
                       ##LET g_qryparam.default1 = g_cda[l_ac].cda01            #MOD-C10033 mark
                        #LET g_qryparam.default1 = g_cda[1].cda01               #MOD-C10033 add
                        #CALL cl_create_qry() RETURNING  g_qryparam.multiret    #No:MOD-A30104 modify             
                        #TQC-C70097--mark--end--
                        CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret  #TQC-C70097 add     
                     OTHERWISE
                        CALL cl_init_qry_var()                                 #No:MOD-A30104 add
                        LET g_qryparam.form     ="q_gem"
                        LET g_qryparam.state = "c"                             #No:MOD-A30104 add
                       #LET g_qryparam.default1 = g_cda[l_ac].cda01            #MOD-C10033 mark
                        LET g_qryparam.default1 = g_cda[1].cda01               #MOD-C10033 add
                        CALL cl_create_qry() RETURNING  g_qryparam.multiret    #No:MOD-A30104 modify                    
                   END CASE
                  #------No:MOD-A30104 modify
                  #DISPLAY g_cda[l_ac].cda01 TO s_cda[1].cda01
                   DISPLAY g_qryparam.multiret TO s_cda[1].cda01
                  #------No:MOD-A30104 end
              
                           
              WHEN INFIELD(cda05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_aag07"     #MOD-950001 add
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.default1 = g_cda[1].cda05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_cda[1].cda05
 
              WHEN INFIELD(cda10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.default1 = g_cda[1].cda10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_cda[1].cda10
            
              OTHERWISE
           END CASE
           
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
 
	
		ON ACTION qbe_select
         	   CALL cl_qbe_select()
		ON ACTION qbe_save
		   CALL cl_qbe_save()
	
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i041_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i041_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         STRING       #NO.FUN-910082   
 
    LET g_sql =
       #"SELECT cda01,cda02,cda04,cda05,cda06,cda07,cda08,cda09,cda10,'' ", #FUN-8B0047 #FUN-920010 add cda04,cda10,''  #CHI-C40026 mark
        "SELECT cda01,cda02,cda04,cda05,'',cda06,cda07,cda08,cda09,cda10,'' ",     #CHI-C40026 add
        " FROM cda_file ",
        " WHERE  ", p_wc2 CLIPPED,                  
        " ORDER BY cda01,cda02,cda05"
    PREPARE i041_pb FROM g_sql
    DECLARE cda_curs CURSOR FOR i041_pb
 
    CALL g_cda.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH cda_curs INTO g_cda[g_cnt].*  
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      SELECT gem02 INTO g_cda[g_cnt].gem02 FROM gem_file
       WHERE gem01 = g_cda[g_cnt].cda10
      IF SQLCA.sqlcode THEN
         LET g_cda[g_cnt].gem02 = NULL
      END IF
     #CHI-C40026 str add-----
      SELECT aag02 INTO g_cda[g_cnt].aag02 FROM aag_file
       WHERE aag00=g_aza.aza81 AND aag01=g_cda[g_cnt].cda05
      IF SQLCA.sqlcode THEN
         LET g_cda[g_cnt].aag02 = NULL
      END IF
     #CHI-C40026 end add-----
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    MESSAGE ""
    CALL g_cda.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i041_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cda TO s_cda.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION OUTPUT
         LET g_action_choice="output"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
  
       ON ACTION generate      #批次產生         
          LET g_action_choice="generate"                                                                                     
          EXIT DISPLAY 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i041_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("cda01,cda02,cda04,cda05,cda08,cda09",TRUE) #FUN-8B0047#FUN-920010
  END IF
  IF g_ccz.ccz06 != '1' THEN 
     CALL cl_set_comp_entry("cda01",TRUE)                                                                                         
  END IF
  CALL cl_set_comp_entry("cda08,cda09",TRUE)                                                                                         
END FUNCTION
 
FUNCTION i041_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("cda01,cda02,cda04,cda05",FALSE)   #FUN-920010
  END IF         
  IF g_cda[l_ac].cda06 NOT MATCHES '4' THEN                                                                                                    
     CALL cl_set_comp_entry("cda07",FALSE)                                                                                         
  END IF 
  IF g_ccz.ccz06 = '1' THEN 
     CALL cl_set_comp_entry("cda01",FALSE)                                                                                         
  END IF
  IF g_cda[l_ac].cda02 ='1' THEN                                                                                                    
     CALL cl_set_comp_entry("cda08,cda09",FALSE)                                                                                         
  END IF 
  IF g_cda[l_ac].cda02 MATCHES '[23456]' AND                                                                                                     
     g_cda[l_ac].cda08='2'             THEN    #090117 sarah mod                                                                   
     CALL cl_set_comp_entry("cda09",FALSE)                                                                                         
  END IF 
END FUNCTION   
 
FUNCTION i041_out()
    DEFINE  l_cmd  LIKE type_file.chr1000
    IF  cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
    LET l_cmd = 'p_query "axci041" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                          
    RETURN  
END FUNCTION   
 
FUNCTION i041_g()
   DEFINE p_row,p_col    LIKE type_file.num5  
   DEFINE l_sql,l_wc,l_wc1,l_wc2          STRING
   DEFINE l_cnt,a_cnt    LIKE type_file.num5 
   DEFINE i,j            LIKE type_file.num5 
   DEFINE tm             RECORD
                          cda02 LIKE cda_file.cda02,
                          cda06 LIKE cda_file.cda06,
                          cda04 LIKE cda_file.cda04,
                          cda08 LIKE cda_file.cda08,
                          cda01 LIKE cda_file.cda01,
                          cda05 LIKE cda_file.cda05,
                          cda10 LIKE cda_file.cda10
                         END RECORD
   DEFINE l_cda          RECORD LIKE cda_file.*
   DEFINE g_change_lang  LIKE type_file.chr1 
   DEFINE l_cda06        LIKE cda_file.cda06
 
   LET p_row = 6 LET p_col = 6
 
   OPEN WINDOW i041_w_g AT p_row,p_col WITH FORM "axc/42f/axci041_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axci041_g")
   IF g_ccz.ccz06='1' THEN                           #MOD-AB0112 add  
      CALL cl_set_comp_visible('ecd01',FALSE)        #MOD-AB0112 add    
   END IF                                            #MOD-AB0112 add    
 
   INITIALIZE tm.* TO NULL
 
  WHILE TRUE
  
   INPUT BY NAME tm.cda02,tm.cda06,tm.cda04,tm.cda08 WITHOUT DEFAULTS 
   
   
   AFTER FIELD cda02
         IF NOT cl_null(tm.cda02) THEN 
            IF tm.cda02 NOT MATCHES '[123456]' THEN
               NEXT FIELD cda02
            END IF
         END IF 
         IF tm.cda02 ='1' THEN                                                                                                    
            CALL cl_set_comp_entry("cda08",FALSE)
            LET tm.cda08 = '2'         #MOD-B10229 add
            DISPLAY BY NAME tm.cda08   #MOD-B10229 add
         ELSE
            CALL cl_set_comp_entry("cda08",TRUE)                                                                                         
         END IF  
    
   AFTER FIELD cda04
         IF NOT cl_null(tm.cda04) THEN 
            IF tm.cda04 NOT MATCHES '[12]' THEN
               NEXT FIELD cda04
            END IF
         END IF  
 
  AFTER FIELD cda06
         IF NOT cl_null(tm.cda06) THEN
            IF tm.cda06 NOT MATCHES '[12345]' THEN
               NEXT FIELD cda06 
            END IF
         END IF 
         
   AFTER FIELD cda08
         IF tm.cda02 != '1' THEN               #MOD-B70282 add
            IF  cl_null(tm.cda08) THEN 
                NEXT FIELD cda08
            END IF    
       	END IF                                 #MOD-B70282 add
   
   #MOD-B70282 --- modify --- start ---
   AFTER INPUT
         IF tm.cda02 != '1' THEN
            IF cl_null(tm.cda08) THEN
                NEXT FIELD cda08
            END IF
         END IF
   #MOD-B70282 --- modify ---  end  ---
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW i041_w_g 
      RETURN
   END IF
 
   DIALOG ATTRIBUTES(UNBUFFERED)
     CONSTRUCT BY NAME l_wc ON ecd01
   
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
   ON ACTION controlp
         CASE
            WHEN INFIELD(ecd01)
                 CALL cl_init_qry_var() 
                 CASE g_ccz.ccz06     
                     WHEN '3'
                       #--------------No:MOD-A30104 modify
                       #LET g_qryparam.form     ="q_ecd"
                       #LET g_qryparam.state = "c"
                       #CALL cl_create_qry() RETURNING g_qryparam.multiret                    
                        CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                       #--------------No:MOD-A30104 end
                     WHEN '4'
                        LET g_qryparam.form     ="q_eca"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                     OTHERWISE
                        LET g_qryparam.form     ="q_gem"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret  
                   END CASE
                 DISPLAY g_qryparam.multiret TO ecd01
                 NEXT FIELD ecd01
             
             OTHERWISE EXIT CASE
          END CASE
        AFTER CONSTRUCT
 
     END CONSTRUCT
 
     CONSTRUCT BY NAME l_wc1 ON aag01
   
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
   ON ACTION controlp
         CASE
            WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_aag007"  #MOD-950001 mark #MOD-B60125 mark
                 LET g_qryparam.form     = "q_aag07"   #MOD-B60125 add  
                 LET g_qryparam.state    = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01
             OTHERWISE EXIT CASE
          END CASE
        AFTER CONSTRUCT
 
     END CONSTRUCT
   
     CONSTRUCT BY NAME l_wc2 ON gem01
   
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
   ON ACTION controlp
         CASE
            WHEN INFIELD(gem01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.state    = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gem01
                 NEXT FIELD gem01
             OTHERWISE EXIT CASE
          END CASE
     AFTER CONSTRUCT
 
     END CONSTRUCT
   ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION accept
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
 
   END DIALOG
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i041_w_g RETURN END IF
   
   IF NOT cl_confirm('abx-080') THEN    #是否確定執行 (Y/N) ?
     #CLOSE WINDOW i041_w_c    #MOD-C10033 mark
      CLOSE WINDOW i041_w_g    #MOD-C10033 add 
      RETURN 
   END IF
   
   CASE g_ccz.ccz06
        WHEN '3' LET l_wc = l_wc
        WHEN '4' CALL cl_replace_str(l_wc, "ecd01", "eca01") RETURNING l_wc
        OTHERWISE CALL cl_replace_str(l_wc, "ecd01", "gem01") RETURNING l_wc
   END CASE
   CASE g_ccz.ccz06
        WHEN '3'
        LET l_sql="SELECT ecd01  FROM ecd_file ",
                  " WHERE ",l_wc CLIPPED
        WHEN '4'
        LET l_sql="SELECT eca01  FROM eca_file ",
                  " WHERE ",l_wc CLIPPED
        WHEN '1'                                      #MOD-AB0112 add  
        LET l_sql="SELECT ' '  FROM ccz_file "        #MOD-AB0112 add  
        OTHERWISE
        LET l_sql="SELECT gem01  FROM gem_file ",
                  " WHERE ",l_wc CLIPPED
   END CASE 
   PREPARE i041_cda_p1 FROM l_sql
   DECLARE i041_cda_c1 CURSOR FOR i041_cda_p1
   LET l_sql="SELECT aag01 FROM aag_file ",
             " WHERE ",l_wc1 CLIPPED,
             "   AND aag07 <> '1' AND aag03 = '2' ",
             "   AND aagacti = 'Y' "
   LET l_sql=l_sql CLIPPED," AND aag00='",g_aaz.aaz64,"'"    #No.MOD-950001 modify
   PREPARE i041_cda_p2 FROM l_sql
   DECLARE i041_cda_c2 CURSOR FOR i041_cda_p2
   LET l_sql="SELECT gem01 FROM gem_file ",
             " WHERE ",l_wc2 CLIPPED
   PREPARE i041_cda_p3 FROM l_sql
   DECLARE i041_cda_c3 CURSOR FOR i041_cda_p3
   FOREACH i041_cda_c1 INTO tm.cda01
     IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
     END IF
     FOREACH i041_cda_c2 INTO tm.cda05
       IF SQLCA.sqlcode THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          RETURN
       END IF
       FOREACH i041_cda_c3 INTO tm.cda10
       IF SQLCA.sqlcode THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          RETURN
       END IF
       IF tm.cda04 = '2' THEN LET tm.cda10 = ' ' END IF   #No:MOD-980017 add
       
     
       #先檢查是否已經有存在資料,若有則跳過
       LET g_cnt = 0
       LET l_sql = "SELECT COUNT(*) FROM cda_file ",
                   " WHERE cda01='",tm.cda01,"'", 
                   "   AND cda02='",tm.cda02,"'",
                   "   AND cda04='",tm.cda04,"'",
                   "   AND cda10='",tm.cda10,"'",     #FUN-960024
                   "   AND cda05='",tm.cda05,"'"      #FUN-920010
       PREPARE i041_g_p1 FROM l_sql
       DECLARE i041_g_c1 CURSOR FOR i041_g_p1
       OPEN i041_g_c1
       FETCH i041_g_c1 INTO g_cnt
       IF g_cnt > 0 THEN
          CONTINUE FOREACH 
       END IF
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM cda_file
        WHERE cda01=tm.cda01 AND cda02=tm.cda02
       #限制相同"成本中心(cda01)+成本項目(cdb02)"其分攤方式(cda06)需一致
       #所以檢查當輸入的cda06的值不等於已存在的,將值改成跟已存在資料庫裡的
       IF l_cnt > 0 THEN
       DECLARE cda06a_curs CURSOR FOR 
          SELECT DISTINCT cda06 FROM cda_file
           WHERE cda01=tm.cda01 AND cda02=tm.cda02
           ORDER BY cda06
 
       FOREACH cda06a_curs INTO l_cda06  
          IF l_cda06!=' ' AND tm.cda06!=l_cda06 THEN
             CONTINUE FOREACH
          END IF
       END FOREACH
      END IF
     
       IF tm.cda04 = '2' THEN LET tm.cda10 = ' ' END IF
       IF cl_null(tm.cda10) THEN LET tm.cda10 = ' ' END IF
       LET l_cda.cda01=tm.cda01        
       LET l_cda.cda02=tm.cda02
       LET l_cda.cda04=tm.cda04
       LET l_cda.cda05=tm.cda05
       LET l_cda.cda06=tm.cda06
       LET l_cda.cda08=tm.cda08
       LET l_cda.cda10=tm.cda10      
 
      INSERT INTO cda_file VALUES (l_cda.* )
        IF STATUS THEN
           CALL cl_err3("ins","cda_file",l_cda.cda01,l_cda.cda02,STATUS,"","ins_cda:",1)    #No:MOD-980017 modify
           CLOSE WINDOW i041_w_g
           RETURN
        END IF
      END FOREACH
    END FOREACH
   END FOREACH
   EXIT WHILE
  END WHILE
  MESSAGE ""
  CLOSE WINDOW i041_w_g
END FUNCTION
#No.FUN-9C0073 ---------------------By chenls 10/01/11
