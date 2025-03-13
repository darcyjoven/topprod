# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsq841.4gl
# Descriptions...: APS料件供需明細查詢
# Date & Author..: 98/04/03 By Duke   #FUN-940016
# Modify.........: No.TQC-940148 09/04/24 By Duke 修正apsq841 部份版本最大日期取樣sql,並調整 rowid 型態為chr18 
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No:TQC-990134 09/09/24 By Mandy SQL語法調整,因為5.0此種寫法r.c2 會err
# Modify.........: No:FUN-A80050 10/08/10 By Mandy 在計算動態出入庫量時,SUM(tlf907 * tlf60)應該成SUM(tlf907 * tlf60*tlf10),要多乘以異動數量才對。
#                                                  SUM(入出庫碼*異動單據單位對庫存單位之換算率*異動數量)
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B80053 11/08/08 By fengrui  程式撰寫規範修正

DATABASE ds

#FUN-940016 09/04/07 create by duke
GLOBALS "../../config/top.global"
  DEFINE g_sw           LIKE type_file.chr1     
  DEFINE g_wc,g_wc2     STRING                  # WHERE CONDICTION  
  DEFINE g_sql          STRING      
  DEFINE g_vzy01        LIKE  vzy_file.vzy01
  DEFINE g_vzy02        LIKE  vzy_file.vzy02
  DEFINE g_vzy12        LIKE  vzy_file.vzy12
  DEFINE qty_tlf907     LIKE  tlf_file.tlf907
  DEFINE planername     LIKE  gen_file.gen02
  DEFINE poername       LIKE  gen_file.gen02
  #DEFINE g_ima_rowid    LIKE type_file.chr18   #TQC-940148 MARK
 #DEFINE g_ima_rowid    LIKE type_file.chr18   #TQC-940148 ADD       #No.TQC-940183 #FUN-B50050 mark
  DEFINE g_rec_b,g_i    LIKE type_file.num5     
  DEFINE g_ima          RECORD
                         ima01     LIKE ima_file.ima01,    #料號
                         ima02     LIKE ima_file.ima02,    #品名
                         ima021    LIKE ima_file.ima021,   #品名
                         ima08     LIKE ima_file.ima08,    #來源碼
                         ima25     LIKE ima_file.ima25,    #庫存單位
                         ima24     LIKE ima_file.ima24,    #檢驗碼
                         ima67     LIKE ima_file.ima67,    #計劃員
                         ima43     LIKE ima_file.ima43,    #採購員
                         ima48     LIKE ima_file.ima48,    #採購安全期
                         ima491     LIKE ima_file.ima491,  #入庫前置期
                         ima59     LIKE ima_file.ima59,    #固定前置時間
                         ima61     LIKE ima_file.ima61,    #QC前置時間
                         ima27     LIKE ima_file.ima27,    #安全庫存量
                         ima45     LIKE ima_file.ima45,    #採購單位倍量
                         ima46     LIKE ima_file.ima46,    #最少採購數量
                         ima56     LIKE ima_file.ima56,    #生產單位倍量
                         ima561     LIKE ima_file.ima561,  #最少生產數量 
                         ima262    LIKE ima_file.ima262,   #庫存量
                         ima26     LIKE ima_file.ima26    #MRP可用庫存量
                        END RECORD
  DEFINE g_sr           DYNAMIC ARRAY OF RECORD
                         ds_date   LIKE type_file.dat,     
                         ds_class  LIKE ze_file.ze03,      
                         ds_no     LIKE pmm_file.pmm01,    
                         ds_cust   LIKE pmm_file.pmm09,
                         vod20     LIKE vod_file.vod20,
                         vod04     LIKE vod_file.vod04,
                         vod21     LIKE vod_file.vod21,
                         vod09     LIKE vod_file.vod09,
                         ds_qlty   LIKE rpc_file.rpc13,
                         ds_total  LIKE rpc_file.rpc13
                         END RECORD,
        g_sr_s         RECORD
                         ds_date   LIKE type_file.dat,     
                         ds_class  LIKE ze_file.ze03,      
                         ds_no     LIKE pmm_file.pmm01,    
                         ds_cust   LIKE pmm_file.pmm09,
                         vod20     LIKE vod_file.vod20,
                         vod04     LIKE vod_file.vod04,
                         vod21     LIKE vod_file.vod21,
                         vod09     LIKE vod_file.vod09,
                         ds_qlty   LIKE rpc_file.rpc13,
                         ds_total  LIKE rpc_file.rpc13
                       END RECORD

DEFINE g_order          LIKE type_file.num5    
DEFINE p_row,p_col      LIKE type_file.num5    
DEFINE g_cnt            LIKE type_file.num10   
DEFINE g_msg            LIKE type_file.chr1000 
DEFINE g_row_count      LIKE type_file.num10   
DEFINE g_curs_index     LIKE type_file.num10   
DEFINE g_jump           LIKE type_file.num10   
DEFINE mi_no_ask        LIKE type_file.num5    

FUNCTION apsq841()
    DEFINE l_za05      LIKE za_file.za05      

    #FUN-B50050--mod---str---
    OPTIONS
        INPUT NO WRAP
    WHENEVER ERROR CONTINUE
    #FUN-B50050--mod---end---

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
      EXIT PROGRAM
   END IF

    #No.FUN-B80053--mark--Begin--- 
    #CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    #No.FUN-B80053--mark--End-----
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW q841_w AT p_row,p_col WITH FORM "aps/42f/apsq841"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_init()

   CALL q841_menu()
   CLOSE WINDOW q841_w
   #No.FUN-B80053--mark--Begin---
   #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0074
   #No.FUN-B80053--mark--End-----
END FUNCTION

FUNCTION q841_cs()
   DEFINE   l_cnt LIKE type_file.num5    

      CLEAR FORM #清除畫面
      CALL g_sr.clear()
      CALL cl_opmsg('q')
      IF g_sw = 1 THEN
         CALL cl_set_head_visible("","YES")      
   CALL q841_input()
   {
   #-----------INPUT--------------------
      SELECT vzy01,vzy02,vzy12 INTO g_vzy01,g_vzy02,g_vzy12
        FROM vzy_file,
             (SELECT MAX(vzy12) mvzy12  
                FROM vzy_file
               WHERE vzy00 = g_plant
                 AND vzy12 IS NOT NULL
                 AND vzy10 IS NULL
              )  mvzy_file
       WHERE vzy00 = g_plant
         AND vzy12 = mvzy12
         AND vzy10 IS NULL
     #DISPLAY BY NAME g_vzy12    #TQC-940148 MARK   
 
      INPUT g_vzy01,g_vzy02,g_vzy12  WITHOUT DEFAULTS
          FROM  vzy01, vzy02, vzy12

      AFTER FIELD vzy01
        IF cl_null(g_vzy01) THEN
           LET g_vzy02 = NULL
           LET g_vzy12 = NULL
           NEXT  FIELD vzy01
        ELSE 
            SELECT count(*) INTO l_cnt
              FROM vzy_file
             WHERE vzy01 = g_vzy01
               AND vzy00 = g_plant
            IF l_cnt <=0 THEN
                LET g_vzy02 = NULL
                LET g_vzy12 = NULL
                CALL cl_err('','aic-004',1)
                NEXT FIELD vzy01
            ELSE
                SELECT vzy02,vzy12 INTO g_vzy02,g_vzy12
                  FROM vzy_file,
                       (SELECT MAX(vzy12) mvzy12
                          FROM vzy_file
                         WHERE vzy00 = g_plant
                           AND vzy12 IS NOT NULL
                           AND vzy01 = g_vzy01  #TQC-940148 ADD
                           AND (vzy10 IS NULL)
                       )  mvzy_file
                  WHERE vzy00 = g_plant
                    AND vzy12 = mvzy12
                    AND vzy01 = g_vzy01
                    AND (vzy10 IS NULL)
               #DISPLAY BY NAME g_vzy12    #TQC-940148 MARK
            END IF
        END IF

      AFTER FIELD vzy02
        IF cl_null(g_vzy02) THEN
           LET g_vzy12 = NULL
           NEXT  FIELD vzy02
        ELSE
            SELECT count(*) INTO l_cnt
              FROM vzy_file
             WHERE vzy01 = g_vzy01
               AND vzy00 = g_plant
               AND vzy02 = g_vzy02
            IF l_cnt <=0 THEN
                LET g_vzy12 = NULL
                CALL cl_err('','aic-004',1)
                NEXT FIELD vzy02
            ELSE
               #TQC-940148 MOD --STR---------------
               #SELECT vzy12 INTO g_vzy12
               #  FROM vzy_file,
               #       (SELECT MAX(vzy12) mvzy12
               #          FROM vzy_file
               #         WHERE vzy00 = g_plant
               #           AND vzy12 IS NOT NULL
               #           AND (vzy10 IS NULL)
               #       )  mvzy_file
               #WHERE vzy00 = g_plant
               #   AND vzy01 = g_vzy01
               #   AND vzy02 = g_vzy02
               #   AND vzy12 = mvzy12
               #   AND (vzy10 IS NULL)
                SELECT MAX(vzy12) INTO g_vzy12
                  FROM vzy_file
                WHERE vzy00 = g_plant
                   AND vzy01 = g_vzy01
                   AND vzy02 = g_vzy02
                   AND vzy10 IS NULL
               #TQC-940148 MOD --END------------- 
               # DISPLAY BY NAME g_vzy12  #TQC-940148 MARK
            END IF
        END IF


      ON ACTION controlp
         CASE
           WHEN INFIELD(vzy01)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_vzy05"
                LET g_qryparam.arg1     = g_plant CLIPPED
                CALL cl_create_qry() RETURNING g_vzy01
                LET  g_vzy02 = NULL 
                SELECT vzy02,vzy12 INTO g_vzy02,g_vzy12
                FROM vzy_file,
                     (SELECT vzy00 mvzy00,vzy01 mvzy01,MAX(vzy12) mvzy12  
                        FROM vzy_file
                        WHERE vzy00 = g_plant
                          AND vzy01 = g_vzy01
                          AND vzy12 IS NOT NULL
                          AND(vzy10 IS NULL)
                        GROUP BY vzy00,vzy01)  mvzy_file
                WHERE vzy00 = mvzy00 
                  AND vzy01 = mvzy01
                  AND vzy12 = mvzy12
                  AND vzy00 = g_plant
                  AND (vzy10 IS NULL)
             NEXT FIELD vzy01

           OTHERWISE
              EXIT CASE
        END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
   
       ON ACTION about         
          CALL cl_about()      
   
       ON ACTION help          
          CALL cl_show_help()  
   
       ON ACTION controlg      
          CALL cl_cmdask()     
   
       ON ACTION locale       
          CALL cl_dynamic_locale()
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
  
       ON ACTION qbe_save
          CALL cl_qbe_save()
  
    END INPUT
    IF INT_FLAG THEN RETURN END IF
    #---------------------------------------------------------
    }
     
         CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima08,ima24
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
              ON ACTION controlp
                  CASE
                    WHEN INFIELD(ima01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima01
                     NEXT FIELD ima01
                  END CASE
         END CONSTRUCT
         IF INT_FLAG THEN RETURN END IF
      END IF
      IF g_sw = 2 THEN
         LET p_row = 6 LET p_col = 3
         OPEN WINDOW q841_w2 AT p_row,p_col WITH FORM "aps/42f/apsq841_2"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         CALL cl_ui_locale("apsq841_2")
 
         CONSTRUCT BY NAME g_wc2 ON sfa01
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     

 
         END CONSTRUCT
         CLOSE WINDOW q841_w2
         IF INT_FLAG THEN RETURN END IF
         LET g_wc = "ima01 IN (SELECT sfa03 FROM sfa_file WHERE ",
                     g_wc2 CLIPPED,")"

         CALL q841_input()
      END IF

      IF g_sw = 3 THEN
         LET p_row = 6 LET p_col = 3
         OPEN WINDOW q841_w3 AT p_row,p_col WITH FORM "aps/42f/apsq841_3"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         CALL cl_ui_locale("apsq841_3")

         CONSTRUCT BY NAME g_wc2 ON oeb01
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
         END CONSTRUCT
         CLOSE WINDOW q841_w3
         IF INT_FLAG THEN RETURN END IF
         LET g_wc = "ima01 IN (SELECT oeb04 FROM oeb_file WHERE ",
                     g_wc2 CLIPPED,")"

         CALL q841_input()
      END IF

      IF g_sw = 4 THEN
         LET p_row = 6 LET p_col = 3
         OPEN WINDOW q841_w4 AT p_row,p_col WITH FORM "aps/42f/apsq841_4"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         CALL cl_ui_locale("apsq841_4")
 
         CONSTRUCT BY NAME g_wc2 ON bmb01
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
              ON ACTION controlp                                                                                                    
                  CASE                                                                                                              
                    WHEN INFIELD(bmb01)                                                                                             
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_bmb01"                                                                                  
                     LET g_qryparam.state = 'c'                                                                                     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                     DISPLAY g_qryparam.multiret TO bmb01                                                                           
                     NEXT FIELD bmb01                                                                                               
                  END CASE
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()     
 
 
         END CONSTRUCT
         CLOSE WINDOW q841_w4
         IF INT_FLAG THEN RETURN END IF
         LET g_wc = "ima01 IN (SELECT bmb03 FROM bmb_file WHERE ",
                     g_wc2 CLIPPED,")"
         CALL q841_input()
      END IF
   LET g_sql=" SELECT ima01,ima02,ima021,ima08,ima25,ima24,ima67,ima43,ima48,ima491,",
            #"        ima59,ima61,ima27,ima45,ima46,ima56,ima561,ima262,ima26,ROWID ", #FUN-B50050 mark
             "        ima59,ima61,ima27,ima45,ima46,ima56,ima561,ima262,ima26 ",       #FUN-B50050 add
             " FROM ima_file ", " WHERE ",g_wc CLIPPED

   #資料權限的檢查
   IF g_priv2='4' THEN#只能使用自己的資料
      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN#只能使用相同群的資料
     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    
     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q841_prepare FROM g_sql
   DECLARE q841_cs SCROLL CURSOR FOR q841_prepare

   LET g_sql=" SELECT count(*) FROM ima_file ", " WHERE ",g_wc CLIPPED
   #資料權限的檢查
   IF g_priv2='4' THEN#只能使用自己的資料
      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN#只能使用相同群的資料
     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    
     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   END IF

   PREPARE q841_pp  FROM g_sql
   DECLARE q841_cnt CURSOR FOR q841_pp
END FUNCTION


FUNCTION q841_menu()

   WHILE TRUE
      CALL q841_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            LET g_sw = 1
            CALL q841_q()
         WHEN "query_by_w_o"
            LET g_sw = 2
            CALL q841_q()
         WHEN "query_by_order"
            LET g_sw = 3
            CALL q841_q()
         WHEN "query_by_bom"
            LET g_sw = 4
            CALL q841_q()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q841_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q841_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting!"
    OPEN q841_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('q841_q:',SQLCA.sqlcode,0)
    ELSE
       OPEN q841_cnt
       FETCH q841_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q841_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION q841_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  

    CASE p_flag
        WHEN 'N' FETCH NEXT     q841_cs INTO g_ima.* #FUN-B50050 刪除,g_ima_rowid
        WHEN 'P' FETCH PREVIOUS q841_cs INTO g_ima.* #FUN-B50050 刪除,g_ima_rowid
        WHEN 'F' FETCH FIRST    q841_cs INTO g_ima.* #FUN-B50050 刪除,g_ima_rowid
        WHEN 'L' FETCH LAST     q841_cs INTO g_ima.* #FUN-B50050 刪除,g_ima_rowid
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
                   ON ACTION about         
                      CALL cl_about()      
 
                   ON ACTION help          
                      CALL cl_show_help()  
 
                   ON ACTION controlg      
                      CALL cl_cmdask()     
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump q841_cs INTO g_ima.* #FUN-B50050 刪除,g_ima_rowid
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err('Fetch:',SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  
       #LET g_ima_rowid = NULL      #FUN-B50050 mark
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    #----取出動態出入庫量
    LET qty_tlf907 = 0
    IF NOT cl_null(g_vzy12) THEN
      #SUM(入出庫碼*異動單據單位對庫存單位之換算率*異動數量)
      #SELECT  SUM(tlf907 * tlf60) INTO qty_tlf907          #FUN-A80050 mark
       SELECT  SUM(tlf907 * tlf60 *tlf10 ) INTO qty_tlf907  #FUN-A80050 add
         FROM  tlf_file
        WHERE  tlf01 = g_ima.ima01
          AND  tlf06 >= g_vzy12
       IF cl_null(qty_tlf907) THEN
          LET qty_tlf907 = 0
       END IF
    END IF   
    DISPLAY BY NAME qty_tlf907 ATTRIBUTE(REVERSE)

    LET planername = NULL
    LET poername   = NULL
   
    SELECT  gen02 INTO planername
      FROM  gen_file
      WHERE gen01 = g_ima.ima67

    SELECT  gen02 INTO poername
      FROM  gen_file
     WHERE  gen01 = g_ima.ima43

    DISPLAY BY NAME planername ATTRIBUTE(REVERSE)
    DISPLAY BY NAME poername ATTRIBUTE(REVERSE)

    CALL q841_show()
END FUNCTION

FUNCTION q841_show()
   DISPLAY BY NAME g_ima.*
   
   MESSAGE ' WAIT '
   CALL q841_b_fill() #單身
   MESSAGE ''
    CALL cl_show_fld_cont()                  
END FUNCTION

FUNCTION q841_b_fill()              #BODY FILL UP
   DEFINE l_sfb02	LIKE type_file.num5,    
	  I,J		LIKE type_file.num10,   
          m_oeb12       LIKE oeb_file.oeb12,
          m_ogb12       LIKE ogb_file.ogb12,
          l_pmm09       LIKE pmm_file.pmm09,
          l_pmc03       LIKE pmc_file.pmc03,
          l_sfb82       LIKE sfb_file.sfb82,
          l_ima55_fac   LIKE ima_file.ima55_fac,
 	  qty_1,qty_2,qty_3,qty_4,qty_5,qty_51,qty_6,qty_7 LIKE sfb_file.sfb08,
          qty_8,qty_9,qty_10,qty_11  LIKE sfb_file.sfb08 
   DEFINE l_msg         STRING    #MOD-5B0174

    #-->受訂量
    DECLARE q841_bcs1 CURSOR FOR
       SELECT oeb15,'',oeb01,occ02,'','','','',(oeb12-oeb24+oeb25-oeb26)*oeb05_fac,0   
         FROM oeb_file, oea_file, occ_file
         WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01
           AND occ01 = oea03 AND oea00<>'0' AND oeb70 = 'N' 
           AND oeb12-oeb24+oeb25-oeb26 >0      
           AND oeaconf = 'Y'   
         ORDER BY oeb15
    #-->在製量
    SELECT ima55_fac INTO l_ima55_fac #BugNo:5474
      FROM ima_file
     WHERE ima01 = g_ima.ima01
    IF cl_null(l_ima55_fac) THEN
        LET l_ima55_fac = 1
    END IF
    DECLARE q841_bcs2 CURSOR FOR
       SELECT sfb15,'',sfb01,gem02,'','','','',(sfb08-sfb09-sfb10-sfb11-sfb12)*l_ima55_fac,0,sfb02,sfb82
         FROM sfb_file, OUTER gem_file
        WHERE sfb05 = g_ima.ima01 AND sfb04 !='8' AND sfb82 = gem_file.gem01
          AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
        ORDER BY sfb15
    #-->請購量
    DECLARE q841_bcs3 CURSOR FOR
       SELECT pml35,'',pml01,pmc03,'','','','',(pml20-pml21)*pml09,0   
         FROM pml_file, pmk_file, OUTER pmc_file
         WHERE pml04 = g_ima.ima01 AND pml01 = pmk01 AND pmk09 = pmc_file.pmc01
          AND pml20 > pml21 AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W')   ##MOD-530804
         AND pml011 !='SUB' AND pmk18 != 'X'
        ORDER BY pml35   
    #-->採購量
    DECLARE q841_bcs4 CURSOR FOR
       SELECT pmn35,'',pmm01,pmc03,'','','','',(pmn20-pmn50+pmn55)*pmn09,0
         FROM pmn_file, pmm_file, OUTER pmc_file
        WHERE pmn04 = g_ima.ima01 AND pmn01 = pmm01 AND pmm09 = pmc_file.pmc01
          AND pmn20 -(pmn50-pmn55)>0 AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W') AND pmn011 !='SUB' #FUN-5C0046
          AND pmm18 != 'X'
        ORDER BY pmn35
    #-->IQC 在驗量
    DECLARE q841_bcs5 CURSOR FOR
       SELECT rva06,'',rvb01,pmc03,'','','','',(rvb07-rvb29-rvb30)*pmn09,0
         FROM rvb_file, rva_file, OUTER pmc_file, pmn_file
        WHERE rvb05 = g_ima.ima01 AND rvb01 = rva01 AND rva05 = pmc_file.pmc01
          AND rvb04 = pmn_file.pmn01 AND rvb03 = pmn_file.pmn02
          AND rvb07 > (rvb29+rvb30)
          AND rvaconf='Y'  
        ORDER BY rva06
    #-->FQC 在驗量
    DECLARE q841_bcs51 CURSOR FOR
       SELECT sfb15,'',sfb01,gem02,'','','','',sfb11,0   
         FROM sfb_file, OUTER gem_file
        WHERE sfb05 = g_ima.ima01
          AND sfb02 <> '7' AND sfb87!='X'
          AND sfb04 <'8' AND sfb82=gem_file.gem01
          AND sfb11 > 0   #No:7188
    #-->備料量
    #工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領
    #若 A  < 0 ,則 LET A = 0,同amrp500 之計算邏輯
    DECLARE q841_bcs6 CURSOR FOR
       SELECT sfb13,'',sfa01,gem02,'','','','',(sfa05-sfa06-sfa065+sfa063-sfa062)*sfa13,0  
              ,sfb82,sfb02                                                     
         FROM sfb_file,sfa_file, OUTER gem_file
        WHERE sfa03 = g_ima.ima01 AND sfb01 = sfa01 AND sfb82 = gem_file.gem01
          AND sfb04 !='8' AND sfa05 > 0 AND sfa05 > sfa06+sfa065 AND sfb87!='X'
        ORDER BY sfb13
    #-->銷售備置量
    SELECT SUM(oeb905*oeb05_fac) INTO m_oeb12    #no.7182
     FROM oeb_file, oea_file, occ_file
    WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND oea00 <>'0' AND oeb19 = 'Y'
      AND oeb70 = 'N' AND oeb12 > oeb24 AND oea03=occ01
      AND oeaconf != 'X' 
   
    #-->計畫請購量
    DECLARE q841_bcs8 CURSOR FOR
       SELECT vob14,'',vob03,pmc03,'','','',vob07,vob33,0
              FROM vob_file, OUTER pmc_file
         WHERE vob01 = g_vzy01
           AND vob02 = g_vzy02
           AND vob05 = '1'
           AND vob10 = pmc_file.pmc01
           AND vob36 = 'N'
           AND vob07 = g_ima.ima01
         ORDER BY vob14

    #-->計畫製造量
    DECLARE q841_bcs9 CURSOR FOR
       SELECT vod10,'',vod03,'','','','','',vod35*vod29,0
              FROM vod_file
         WHERE vod01 = g_vzy01
           AND vod02 = g_vzy02
           AND vod08 = '1'
           AND (vod37 = 'N' OR vod37 IS NULL)
           AND vod09 = g_ima.ima01
         ORDER BY vod10

    #-->計畫生產備料量
    DECLARE q841_bcs11 CURSOR FOR
      SELECT voe11,'',vod03,'',vod20,vod04,vod21,vod09,voe12*(-1),0
             FROM voe_file,vod_file
        WHERE vod01 = g_vzy01
          AND vod02 = g_vzy02
          AND vod08 = '1'
          AND (vod37 = 'N' OR vod37 IS NULL)
          AND vod00 = voe00
          AND vod01 = voe01
          AND vod02 = voe02
        #TQC-940148 ADD --STR-----------------------------------------
          AND vod03 = voe03
          AND voe06 = g_ima.ima01
        #TQC-940148 ADD --END-----------------------------------------
        ORDER BY voe11

    #-->獨立需求量
    DECLARE q841_bcs10 CURSOR FOR
      SELECT rpc12,'',rpc02,'','','','',rpc01,(rpc13 - rpc131)*(-1),0
             FROM rpc_file
        WHERE rpc01 = g_ima.ima01
          AND rpc13-rpc131 > 0
          AND rpc19 <> 'Y'
          AND rpc18 = 'Y'
        ORDER BY rpc12


    DISPLAY BY NAME qty_7 ATTRIBUTE(REVERSE)    #------ 銷售備置量不條列明細

#----------------------------------------------------------------------------
    CALL g_sr.clear()
    LET g_cnt = 1
    LET qty_1=0 LET qty_2=0 LET qty_3=0 LET qty_4=0 LET qty_5=0
    LET qty_51=0 LET qty_6=0 LET qty_7=0
    LET qty_8=0  LET qty_9=0 LET qty_10=0  LET qty_11=0
    
#----------------------------------------------------------------------------
    FOREACH q841_bcs1 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F1:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-821',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_1 = qty_1 + g_sr[g_cnt].ds_qlty
       LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    DISPLAY BY NAME qty_1 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs2 INTO g_sr[g_cnt].*,l_sfb02,l_sfb82
       IF STATUS THEN CALL cl_err('F2:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-822',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_2 = qty_2 + g_sr[g_cnt].ds_qlty
       IF cl_null(g_sr[g_cnt].ds_cust) THEN
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 =l_sfb82
          IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
             SELECT pmm09,pmc03 INTO l_pmm09,l_pmc03 FROM pmm_file,pmc_file
                          WHERE pmm01 = g_sr[g_cnt].ds_no
                            AND pmm09 = pmc01
             IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          END IF
          LET g_sr[g_cnt].ds_cust = l_pmc03
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    DISPLAY BY NAME qty_2 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs3 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F3:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-823',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_3 = qty_3 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    IF qty_3 < 0 THEN 
       LET  qty_3 = 0 - qty_3
    END IF
    DISPLAY BY NAME qty_3 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs4 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F4:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-824',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_4 = qty_4 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_4 < 0 THEN
       LET  qty_4 = 0 - qty_4
    END IF
    DISPLAY BY NAME qty_4 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs5 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F5:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-825',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_5 = qty_5 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_5 < 0 THEN
       LET  qty_5 = 0 - qty_5
    END  IF

    DISPLAY BY NAME qty_5 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs51 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F51:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-826',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_51 = qty_51 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_51 < 0 THEN
        LET  qty_51 = 0 - qty_51
    END  IF
 
    DISPLAY BY NAME qty_51 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs6 INTO g_sr[g_cnt].*,l_sfb82,l_sfb02    
       IF STATUS THEN CALL cl_err('F6:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-827',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       IF cl_null(g_sr[g_cnt].ds_cust) THEN
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 =l_sfb82
          IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
             SELECT pmm09,pmc03 INTO l_pmm09,l_pmc03 FROM pmm_file,pmc_file
                          WHERE pmm01 = g_sr[g_cnt].ds_no
                            AND pmm09 = pmc01
             IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          END IF
          LET g_sr[g_cnt].ds_cust = l_pmc03
       END IF
       IF g_sr[g_cnt].ds_qlty < 0 THEN LET g_sr[g_cnt].ds_qlty = 0  END IF 
       LET qty_6 = qty_6 + g_sr[g_cnt].ds_qlty
       LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH

    CALL g_sr.deleteElement(g_cnt)    
    IF qty_6 < 0 THEN
       LET  qty_6 = 0 - qty_6
    END  IF

    DISPLAY BY NAME qty_6 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs8 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F8:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aps-733',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_8 = qty_8 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_8 < 0 THEN
       LET  qty_8 = 0 - qty_8
    END  IF

    DISPLAY BY NAME qty_8 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs9 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F9:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aps-734',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_9 = qty_9 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_9 < 0 THEN
       LET  qty_9 = 0 - qty_9
    END  IF

    DISPLAY BY NAME qty_9 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs11 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F11:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aps-735',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_11 = qty_11 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_11 < 0 THEN
       LET  qty_11 = 0 - qty_11
    END  IF

    DISPLAY BY NAME qty_11 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs10 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F10:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aps-736',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_10 = qty_10 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    IF qty_10 < 0 THEN
       LET  qty_10 = 0 - qty_10
    END  IF

    DISPLAY BY NAME qty_10 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------

LET g_cnt = g_cnt - 1      			# Get real number of record
 LET g_rec_b = g_cnt     
#------------------------Bubble Sort Start !!!--------11/10/94 by nick------
FOR I= 1 TO g_cnt-1
    FOR J= g_cnt-1 TO I STEP -1
    #---------- COMPARE  & SWAP ------------
        IF (g_sr[J].ds_date > g_sr[J+1].ds_date) OR
                     (g_sr[J+1].ds_date IS NULL) THEN
	   LET g_sr_s.*	= g_sr[J].*
	   LET g_sr[J].* = g_sr[J+1].*
	   LET g_sr[J+1].* = g_sr_s.*	
	END IF	
   END FOR
END FOR
#------------------------Bubble Sort End------------------------------------
FOR I = 1 TO g_cnt
    LET g_ima.ima26 = g_ima.ima26 + g_sr[I].ds_qlty
    LET g_sr[I].ds_total = g_ima.ima26
END FOR

 #MOD-490145顯示單身筆數
DISPLAY g_rec_b TO FORMONLY.cn2
LET g_cnt = 0

END FUNCTION


FUNCTION q841_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    


   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      CALL cl_show_fld_cont()                   

      ON ACTION first
         CALL q841_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 

      ON ACTION previous
         CALL q841_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION jump
         CALL q841_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 

      ON ACTION next
         CALL q841_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION last
         CALL q841_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

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
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
         EXIT DISPLAY
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DISPLAY
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DISPLAY

      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
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

        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION  q841_input()
DEFINE   l_cnt LIKE type_file.num5
     #TQC-990134---mod----str----
     #SELECT vzy01,vzy02,vzy12 INTO g_vzy01,g_vzy02,g_vzy12
     #  FROM vzy_file,
     #       (SELECT MAX(vzy12) mvzy12  
     #          FROM vzy_file
     #         WHERE vzy00 = g_plant
     #           AND vzy12 IS NOT NULL
     #           AND(vzy10 IS NULL)
     #        )  mvzy_file
     # WHERE vzy00 = g_plant
     #   AND vzy12 = mvzy12
     #   AND (vzy10 IS NULL)
      SELECT vzy01,vzy02,vzy12 
        INTO g_vzy01,g_vzy02,g_vzy12
        FROM vzy_file
       WHERE vzy00 = g_plant
         AND vzy10 IS NULL
         AND vzy12 = (SELECT MAX(vzy12)
                        FROM vzy_file
                       WHERE vzy00 = g_plant
                         AND vzy10 IS NULL
                         AND vzy12 IS NOT NULL)
     #TQC-990134---mod----str----
      #DISPLAY BY NAME g_vzy12     #TQC-940148 MARK  
 
      INPUT g_vzy01,g_vzy02,g_vzy12  WITHOUT DEFAULTS
          FROM  vzy01, vzy02, vzy12

      AFTER FIELD vzy01
        IF cl_null(g_vzy01) THEN
           LET g_vzy02 = NULL
           LET g_vzy12 = NULL
           NEXT  FIELD vzy01
        ELSE 
            SELECT count(*) INTO l_cnt
              FROM vzy_file
             WHERE vzy01 = g_vzy01
               AND vzy00 = g_plant
            IF l_cnt <=0 THEN
                LET g_vzy02 = NULL
                LET g_vzy12 = NULL
                CALL cl_err('','aic-004',1)
                NEXT FIELD vzy01
            ELSE
               #TQC-990134--mod---str---
               #SELECT vzy02,vzy12 INTO g_vzy02,g_vzy12
               #  FROM vzy_file,
               #       (SELECT MAX(vzy12) mvzy12
               #          FROM vzy_file
               #         WHERE vzy00 = g_plant
               #           AND vzy12 IS NOT NULL
               #           AND vzy01 = g_vzy01   #TQC-940148 ADD
               #           AND (vzy10 IS NULL)
               #       )  mvzy_file
               #  WHERE vzy00 = g_plant
               #    AND vzy12 = mvzy12
               #    AND vzy01 = g_vzy01
               #    AND (vzy10 IS NULL)
                SELECT vzy02,vzy12 INTO g_vzy02,g_vzy12
                  FROM vzy_file
                  WHERE vzy00 = g_plant
                    AND vzy01 = g_vzy01
                    AND vzy10 IS NULL
                    AND vzy12 = 
                       (SELECT MAX(vzy12) 
                          FROM vzy_file
                         WHERE vzy00 = g_plant
                           AND vzy01 = g_vzy01   
                           AND vzy10 IS NULL
                           AND vzy12 IS NOT NULL)
               #TQC-990134--mod---end---
               #DISPLAY BY NAME g_vzy12   #TQC-940148 MARK
            END IF
        END IF

      AFTER FIELD vzy02
        IF cl_null(g_vzy02) THEN
           LET g_vzy12 = NULL
           NEXT  FIELD vzy02
        ELSE
            SELECT count(*) INTO l_cnt
              FROM vzy_file
             WHERE vzy01 = g_vzy01
               AND vzy00 = g_plant
               AND vzy02 = g_vzy02
            IF l_cnt <=0 THEN
                LET g_vzy12 = NULL
                CALL cl_err('','aic-004',1)
                NEXT FIELD vzy02
            ELSE
               #TQC-940148 MOD --STR-----------------
               #SELECT vzy12 INTO g_vzy12
               #  FROM vzy_file,
               #       (SELECT MAX(vzy12) mvzy12
               #          FROM vzy_file
               #         WHERE vzy00 = g_plant
               #           AND vzy12 IS NOT NULL
               #           AND (vzy10 IS NULL)
               #       )  mvzy_file
               # WHERE vzy00 = g_plant
               #   AND vzy01 = g_vzy01
               #   AND vzy02 = g_vzy02
               #   AND vzy12 = mvzy12
               #   AND (vzy10 IS NULL)
                SELECT MAX(vzy12) INTO g_vzy12
                  FROM vzy_file
                 WHERE vzy00 = g_plant
                   AND vzy01 = g_vzy01
                   AND vzy02 = g_vzy02
                   AND vzy10 IS NULL
               #TQC-940148 MOD --END------------  
               #DISPLAY BY NAME g_vzy12   #TQC-940148 MARK
            END IF
        END IF


      ON ACTION controlp
         CASE
           WHEN INFIELD(vzy01)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_vzy05"
                LET g_qryparam.arg1     = g_plant CLIPPED
                CALL cl_create_qry() RETURNING g_vzy01
                LET  g_vzy02 = NULL 
               #TQC-990134----mod----str----
               #SELECT vzy02,vzy12 INTO g_vzy02,g_vzy12
               #FROM vzy_file,
               #     (SELECT vzy00 mvzy00,vzy01 mvzy01,MAX(vzy12) mvzy12  
               #        FROM vzy_file
               #        WHERE vzy00 = g_plant
               #          AND vzy01 = g_vzy01
               #          AND vzy12 IS NOT NULL
               #          AND(vzy10 IS NULL)
               #        GROUP BY vzy00,vzy01)  mvzy_file
               #WHERE vzy00 = mvzy00 
               #  AND vzy01 = mvzy01
               #  AND vzy12 = mvzy12
               #  AND vzy00 = g_plant
               #  AND (vzy10 IS NULL)
                SELECT vzy02,vzy12 INTO g_vzy02,g_vzy12
                FROM vzy_file
                WHERE vzy00 = g_plant
                  AND vzy01 = g_vzy01
                  AND vzy10 IS NULL
                  AND vzy12 = 
                     (SELECT MAX(vzy12) 
                        FROM vzy_file
                        WHERE vzy00 = g_plant
                          AND vzy01 = g_vzy01
                          AND vzy10 IS NULL
                          AND vzy12 IS NOT NULL)
               #TQC-990134----mod----str----
             NEXT FIELD vzy01

           OTHERWISE
              EXIT CASE
        END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
   
       ON ACTION about         
          CALL cl_about()      
   
       ON ACTION help          
          CALL cl_show_help()  
   
       ON ACTION controlg      
          CALL cl_cmdask()     
   
       ON ACTION locale       
          CALL cl_dynamic_locale()
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
  
       ON ACTION qbe_save
          CALL cl_qbe_save()
  
    END INPUT
    IF INT_FLAG THEN RETURN END IF
END FUNCTION
