# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cpmp730.4gl
# Descriptions...: 价格批量更新维护作业
# Date & Author..: 16/09/09 by ly

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD        
   sprice         LIKE type_file.chr1,   #价格条件
   cgtype         LIKE type_file.chr1,   #工单类型
   schange        LIKE type_file.chr1   #是否同步更新采购单
END RECORD
   
DEFINE  g_rvv,g_rvv1  DYNAMIC  ARRAY OF RECORD       
            rvu04  LIKE rvv_file.rvv04,   
            pmc02  LIKE pmc_file.pmc02,   
            pmm21  LIKE pmm_file.pmm21,   
            pmm43  LIKE pmm_file.pmm43,   
            rvv01  LIKE rvv_file.rvv01,   
            rvv02  LIKE rvv_file.rvv02,  
            rvu03  LIKE rvu_file.rvu03,
            rvv36  LIKE rvv_file.rvv36,   
            rvv37  LIKE rvv_file.rvv37,   
            rvv31  LIKE rvv_file.rvv31,   
            ima02  LIKE ima_file.ima02,   
            ima021 LIKE ima_file.ima021,  
            rvv17  LIKE rvv_file.rvv17,   
            rvl_rk LIKE rvv_file.rvv17,  
            pmn07  LIKE pmn_file.pmn07, 
            rvv86  LIKE rvv_file.rvv86,   #計價單位 #CHI-A80025 add
            rvv87  LIKE rvv_file.rvv87,   #計價數量 #CHI-A80025 add  
            rvv38t LIKE rvv_file.rvv38t,    
            rvv38  LIKE rvv_file.rvv38,
            rvv39t LIKE rvv_file.rvv39t,   
            rvv39  LIKE rvv_file.rvv39
               END RECORD,
               
   g_rvv_t         RECORD                 #程式變數 (舊值)
            rvu04  LIKE rvv_file.rvv04,   
            pmc02  LIKE pmc_file.pmc02,   
            pmm21  LIKE pmm_file.pmm21,   
            pmm43  LIKE pmm_file.pmm43,   
            rvv01  LIKE rvv_file.rvv01,   
            rvv02  LIKE rvv_file.rvv02, 
            rvu03  LIKE rvu_file.rvu03, 
            rvv36  LIKE rvv_file.rvv36,   
            rvv37  LIKE rvv_file.rvv37,   
            rvv31  LIKE rvv_file.rvv31,   
            ima02  LIKE ima_file.ima02,   
            ima021 LIKE ima_file.ima021,  
            rvv17  LIKE rvv_file.rvv17,   
            rvl_rk LIKE rvv_file.rvv17,  
            pmn07  LIKE pmn_file.pmn07,
            rvv86  LIKE rvv_file.rvv86,   #計價單位 #CHI-A80025 add
            rvv87  LIKE rvv_file.rvv87,   #計價數量 #CHI-A80025 add     
            rvv38t LIKE rvv_file.rvv38t,    
            rvv38  LIKE rvv_file.rvv38,
            rvv39t LIKE rvv_file.rvv39t,   
            rvv39  LIKE rvv_file.rvv39
               END RECORD,
               
   g_argv1         LIKE rvv_file.rvv01,
   g_gec07         LIKE gec_file.gec07,
   g_wc,g_sql      STRING,      #No.FUN-680136 VARCHAR(300)       #TQC-B40112 chr1000->STRING
   g_rec_b         LIKE type_file.num5
#CHI-A80025 add --start--
DEFINE g_ima25     LIKE ima_file.ima25,         #庫存單位
       g_ima44     LIKE ima_file.ima44,
       g_ima906    LIKE ima_file.ima906,
       g_ima907    LIKE ima_file.ima907,
       g_ima908    LIKE ima_file.ima908,
       g_img09     LIKE img_file.img09,         ##庫存單位
       g_unit      LIKE imgg_file.imgg09,
       g_change    LIKE type_file.chr1,
       g_factor    LIKE ima_file.ima31_fac,
       g_before_input_done LIKE type_file.num5
#CHI-A80025 add --end--
DEFINE   g_forupd_sql   STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE  g_type          LIKE pmh_file.pmh22     
DEFINE   l_ac          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE li_cnt        LIKE type_file.num5        #No.FUnFUN00FUN
DEFINE   g_rvv86_t      LIKE rvv_file.rvv86     #No.FUN-BB0086 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1)             #入庫單號

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW t300_w WITH FORM "cpm/42f/cpmp730"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL t300_q()

   CALL i300_def_form() #CHI-A80025 add
   CALL t300_menu()
   CLOSE WINDOW t300_w                    #結束畫面
 
 # CALL cl_used('apmi300',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN
 
FUNCTION t300_curs()
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
   CLEAR FORM                             #清除畫面
   CALL g_rvv.clear()
   LET tm.sprice = '1'
   LET tm.cgtype = '3'
   LET tm.schange = 'N'
   DIALOG ATTRIBUTE(UNBUFFERED)    
		INPUT tm.sprice,tm.cgtype,tm.schange FROM sprice,cgtype,schange ATTRIBUTE(WITHOUT DEFAULTS)
		  
		   BEFORE INPUT
		     CALL cl_qbe_display_condition(lc_qbe_sn)    
		   END INPUT
		CONSTRUCT g_wc ON rvu04,pmc02,pmm21,pmm43,rvv01,rvv02,rvu03,rvv36,rvv37,rvv31,ima02,ima02
		     FROM s_rvv[1].rvu04,s_rvv[1].pmc02,s_rvv[1].pmm21,s_rvv[1].pmm43,s_rvv[1].rvv01,s_rvv[1].rvv02,
		     s_rvv[1].rvu03,s_rvv[1].rvv36,s_rvv[1].rvv37,s_rvv[1].rvv31,s_rvv[1].ima02,s_rvv[1].ima021
		           #No.FUN-580031 --start--     HCN
		           BEFORE CONSTRUCT
		              CALL cl_qbe_init()
		           #No.FUN-580031 --end--       HCN
		END CONSTRUCT
          ON ACTION controlp
            CASE
               WHEN INFIELD(rvu04)        #供应商编码
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_rvu04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvu04
                  NEXT FIELD rvu04
                WHEN INFIELD(rvv01)        #入庫單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_rvv5"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvv01
                  NEXT FIELD rvv01
                WHEN INFIELD(rvv36)        #采购单单号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_pmm"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvv36
                  NEXT FIELD rvv36
               WHEN INFIELD(rvv31)        #料件编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvv31
                  NEXT FIELD rvv31
               OTHERWISE EXIT CASE
            END CASE
 
               ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG 
		   
   END DIALOG     
	LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
	IF INT_FLAG THEN RETURN END IF

    LET g_wc = g_wc CLIPPED  #," AND rvv03 = '1' " #MOD-B40213
   LET g_sql = " SELECT DISTINCT rvv01,rvv02 ",
               "  FROM rvv_file,rvu_file ",
               "  WHERE ", g_wc CLIPPED,
               "  AND rvv01=rvu01",
               "  ORDER BY rvv01"
   PREPARE t300_prepare FROM g_sql        #預備一下
   DECLARE t300_b_curs                    #宣告成可卷動的
      SCROLL CURSOR WITH HOLD FOR t300_prepare
 
   LET g_sql = " SELECT COUNT(DISTINCT rvv01,rvv02) ",
              "  FROM rvv_file,rvu_file ",
              "  WHERE  ",g_wc CLIPPED,
              "  AND rvv01=rvu01"
   PREPARE t300_precount FROM g_sql
   DECLARE t300_count CURSOR FOR t300_precount
 
END FUNCTION
 
FUNCTION t300_menu()
   WHILE TRUE
      CALL t300_bp("G")
      
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"    
            CALL cl_cmdask()
 
         WHEN "price_change"              #價格變更查詢\
         IF tm.sprice <> '1' THEN 
           IF cl_confirm('cpm-111') THEN
             CALL t300_1()
           END IF
          ELSE 
            CALL t300_1() 
         END IF 
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','')
            END IF  
 
        
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t300_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t300_curs()                       #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_rvv[l_ac].rvv01  TO NULL
      RETURN
   END IF
   OPEN t300_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rvv[l_ac].rvv01  TO NULL
   ELSE
      OPEN t300_count
      FETCH t300_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t300_show()              #讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t300_show()
DEFINE l_sql        STRING       #No.FUN-680136 VARCHAR(300)         #TQC-B40112 chr1000->STRING

   DISPLAY tm.sprice  TO sprice               #單頭
   DISPLAY tm.cgtype TO cgtype                #單頭
   DISPLAY tm.schange  TO schange             #單頭
   CALL t300_b_fill(g_wc)                    #單身
   
END FUNCTION
 
FUNCTION t300_b()
DEFINE   l_ac_t         LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
         l_n            LIKE type_file.num5,      #檢查重復用         #No.FUN-680136 SMALLINT
         l_lock_sw      LIKE type_file.chr1,      #單身鎖住否         #No.FUN-680136 VARCHAR(1)
         p_cmd          LIKE type_file.chr1,      #處理狀態           #No.FUN-680136 VARCHAR(1)
         l_time         LIKE type_file.chr8,      #No.FUN-840027
         l_cmd          LIKE type_file.chr1000    #可新增否           #No.FUN-680136 VARCHAR(80)
DEFINE   l_rvv38        LIKE type_file.num10       #NO.TQC-750115
DEFINE   l_rvv38t       LIKE type_file.num10       #NO.TQC-750115
DEFINE   l_rvu08        LIKE rvu_file.rvu08       #MOD-970003 add
DEFINE   l_gec05        LIKE gec_file.gec05       #MOD-A80052
DEFINE   l_rvw06f       LIKE rvw_file.rvw06f      #MOD-A80052
DEFINE   l_rvv35        LIKE rvv_file.rvv35       #CHI-A80025 add
DEFINE   l_n1           LIKE type_file.num5       #No.FUN-BB0086
DEFINE   l_rvv09        LIKE rvv_file.rvv09
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF

   CALL cl_opmsg('b')
   LET g_forupd_sql = " SELECT rvu04,pmc02,pmm21,pmm43,rvv01,rvv02,rvu03,rvv36,rvv37,rvv31,'','',rvv17,",   
                      " pmn20-pmn50-pmn51-pmn53+pmn55+pmn58, pmn07,rvv86,rvv87,rvv38t,rvv38,rvv39t,rvv39",
                      " FROM rvv_file left outer join rvu_file on rvv01 = rvu01 left outer join pmc_file on pmc01 = rvu04,",
                      " pmm_file left outer join pmn_file on pmm01 = pmn01 ",
                      " WHERE rvv36 = pmn01 ", 
                       "AND  rvv01=? AND rvv02=? FOR UPDATE "
   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_rvv WITHOUT DEFAULTS FROM s_rvv.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE ,
                APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #CHI-A80025 add --start--
         LET g_before_input_done = FALSE
         CALL i300_set_entry(p_cmd)
         CALL i300_set_no_entry(p_cmd)
         CALL i300_set_no_required(p_cmd)
         CALL i300_set_required(p_cmd)
         LET g_before_input_done = TRUE
         #CHI-A80025 add --end--
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_rvv_t.* = g_rvv[l_ac].* #BACKUP

            OPEN t300_bcl USING  g_rvv_t.rvv01,g_rvv_t.rvv02

            IF STATUS THEN
               CALL cl_err("OPEN t300_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t300_bcl INTO g_rvv[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rvv_t.rvv01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT ima02,ima021
                    INTO g_rvv[l_ac].ima02,g_rvv[l_ac].ima021
                    FROM ima_file 
                   WHERE ima01 = g_rvv[l_ac].rvv31
                  #MOD-B30669 add --start--
                  IF STATUS THEN
                     IF g_rvv[l_ac].rvv31[1,4] = 'MISC' THEN
                        SELECT ima02,ima021 INTO g_rvv[l_ac].ima02,g_rvv[l_ac].ima021
                          FROM ima_file
                         WHERE ima01 = 'MISC'
                     END IF 
                  END IF
                  #MOD-B30669 add --end--
#MOD-C40212 add begin(JIT無採購單收貨,取不到採購單號的值)
                  IF cl_null(g_rvv[l_ac].rvv36) THEN #先從pmh_file抓取稅別,稅率
                     SELECT pmh17,pmh18,azi04,azi03
                       INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04,t_azi03
                       FROM pmh_file,azi_file,rvu_file
                      WHERE pmh01 = g_rvv[l_ac].rvv31
                        AND pmh02 = rvv06
                        AND pmh05 = '0'
                        AND pmhacti = 'Y' 
                        AND rvu01 = g_rvv[l_ac].rvv01
                        AND rvu113 = azi01 
                        IF cl_null(g_rvv[l_ac].pmm21) THEN #如果還是沒有取到稅別,從供應商慣用稅別抓取 
                           SELECT pmc47,gec04,azi04,azi03 
                             INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04,t_azi03
                             FROM pmc_file,azi_file,gec_file,rvv_file
                            WHERE pmc01 = rvv06
                              AND rvv01 = g_rvv[l_ac].rvv01
                              AND pmc22 = azi01 
                              AND pmc47 = gec01
                        END IF    
                  ELSE 
                  
                     SELECT pmm21,pmm43,azi04,azi03                                                 #MOD-B80063
                     INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04,t_azi03                     #MOD-B80063
                     FROM pmm_file,azi_file                                                       #MOD-A80052
                     WHERE pmm01 = g_rvv[l_ac].rvv36
                     AND pmm22 = azi01                                                           #MOD-A80052

                  END IF    #MOD-C40212 add
                  IF g_rvv[l_ac].rvl_rk < 0 THEN 
                     LET g_rvv[l_ac].rvl_rk = 0
                  END IF 
                  IF cl_null(g_rvv[l_ac].pmm43) THEN
                     SELECT gec01,gec04 
                     INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43
                     FROM gec_file,pmc_file,rvv_file
                     WHERE gec01 = pmc47
                     AND rvv01 =g_rvv[l_ac].rvv01
                     AND pmc01 = rvv06
                     AND gec011='1'  #進項
                  END IF

                  CALL cl_set_comp_entry("rvv38,rvv38t",TRUE)

                  SELECT gec05,gec07 INTO l_gec05,g_gec07        #MOD-A80052
                    FROM gec_file
                   WHERE gec01  = g_rvv[l_ac].pmm21
                     AND gec011 = '1'
                  IF cl_null(g_gec07) THEN LET g_gec07 = 'N' END IF
#No.MOD-8A0087 --begin                                                          
                  CALL cl_set_comp_entry("rvv38t",TRUE)                         
                  CALL cl_set_comp_entry("rvv38",TRUE)                          
#No.MOD-8A0087 --end 
        
#No.MOD-8A0087 --begin                                                          
                  SELECT COUNT(*) INTO l_n FROM apb_file 
                  WHERE apb21 =g_rvv[l_ac].rvv01   
                  AND apb22 = g_rvv[l_ac].rvv02 #MOD-C90212 add apb22  
                 
                  IF l_n >0 THEN                                                
                     CALL cl_err(g_rvv[l_ac].rvv01 ,'apm-922',0)                           
                     CALL cl_set_comp_entry("rvv38t",FALSE)                     
                     CALL cl_set_comp_entry("rvv38",FALSE)                      
                  END IF                                                        
#No.MOD-8A0087 --end 
                  LET g_rvv_t.*=g_rvv[l_ac].*
                  #CHI-A80025 add --start--
                  CALL i300_set_entry(p_cmd)
                  CALL i300_set_no_entry(p_cmd)
                  CALL i300_set_no_required(p_cmd)
                  CALL i300_set_required(p_cmd)

                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM apb_file
                  WHERE apb21 =g_rvv[l_ac].rvv01   
                  AND apb22 = g_rvv[l_ac].rvv02
                  
                  IF l_n >0 THEN                                                
                     CALL cl_set_comp_entry("rvv87",FALSE) 
                  ELSE 
                     CALL cl_set_comp_entry("rvv87",TRUE)                         
                  END IF                                                        
                  #-----END MOD-C90212---------                   
               END IF
            END IF
         ELSE
            CALL g_rvv.deleteElement(l_ac)
            RETURN 
         END IF

      #CHI-A80025 add --start--
      BEFORE FIELD rvv86
          SELECT ima25,ima44,ima906,ima907,ima908
            INTO g_ima25,g_ima44,g_ima906,g_ima907,g_ima908
            FROM ima_file
           WHERE ima01=g_rvv[l_ac].rvv31

          IF NOT cl_null(g_img09) THEN LET g_unit=g_img09 ELSE LET g_unit=g_ima25 END IF
          CALL i300_set_no_required(p_cmd)
      
        AFTER FIELD rvv86
          IF g_rvv_t.rvv86 IS NULL AND g_rvv[l_ac].rvv86 IS NOT NULL OR
             g_rvv_t.rvv86 IS NOT NULL AND g_rvv[l_ac].rvv86 IS NULL OR
             g_rvv_t.rvv86 <> g_rvv[l_ac].rvv86 THEN
             LET g_change='Y'
          END IF
          IF NOT cl_null(g_rvv[l_ac].rvv86) THEN
             IF g_rvv_t.rvv86 IS NULL OR g_rvv[l_ac].rvv86 != g_rvv_t.rvv86 THEN
                CALL i300_unit(g_rvv[l_ac].rvv86)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rvv[l_ac].rvv86,g_errno,0)
                   LET g_rvv[l_ac].rvv86 = g_rvv_t.rvv86
                   NEXT FIELD rvv86
                END IF
             END IF
             CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',
                              g_ima25,g_rvv[l_ac].rvv86,'2')
                  RETURNING g_errno,g_factor
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rvv[l_ac].rvv86,g_errno,0)
                NEXT FIELD rvv86
             END IF
           END IF
           CALL i300_set_required(p_cmd)
           #FUN-BB0086--add--start--
       	   LET l_n1 = 0
           SELECT COUNT(*) INTO l_n1 FROM apb_file WHERE apb21 =g_rvv[l_ac].rvv01   
	   IF l_n1 <= 0 THEN     #TQC-C20183 modify
              IF NOT i300_rvv87_check() THEN
                 LET g_rvv86_t = g_rvv[l_ac].rvv86
                 NEXT FIELD rvv87
              END IF
           ELSE
              LET g_rvv[l_ac].rvv87 = s_digqty(g_rvv[l_ac].rvv87,g_rvv[l_ac].rvv86)
  	      DISPLAY BY NAME g_rvv[l_ac].rvv87
           END IF
           LET g_rvv86_t = g_rvv[l_ac].rvv86
           #FUN-BB0086--add--end--

        BEFORE FIELD rvv87
           IF g_change = 'Y' THEN
              CALL i300_set_rvv87()
           END IF

        AFTER FIELD rvv87
           IF NOT i300_rvv87_check()  THEN NEXT FIELD rvv87 END IF #FUN-BB0086--add--

 
      AFTER FIELD rvv38
         IF NOT cl_null(g_rvv[l_ac].rvv38) THEN 
            IF g_rvv_t.rvv38 != g_rvv[l_ac].rvv38 THEN
 
               SELECT COUNT(*) INTO l_rvv38 FROM rvx_file   #NO.TQC-750115
                WHERE rvx01 = g_rvv[l_ac].rvv01 
                  AND rvx02 = g_rvv_t.rvv02
                  AND rvx03 = g_today 
                  AND rvx04 = g_rvv[l_ac].rvv38  
               LET g_rvv[l_ac].rvv38t = g_rvv[l_ac].rvv38 *(1 + g_rvv[l_ac].pmm43/100)
               LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38,t_azi03)       #MOD-B80063
               LET g_rvv[l_ac].rvv38t = cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)     #MOD-B80063
               CALL i300_set_rvv39() #CHI-A80025 add
            END IF
         END IF
 
      AFTER FIELD rvv38t
         IF NOT cl_null(g_rvv[l_ac].rvv38t) THEN 
            IF g_rvv_t.rvv38t != g_rvv[l_ac].rvv38t THEN
     
               SELECT COUNT(*) INTO l_rvv38t FROM rvx_file   #NO.TQC-750115
                WHERE rvx01 = g_rvv[l_ac].rvv01 
                  AND rvx02 = g_rvv_t.rvv02
                  AND rvx03 = g_today       
                  AND rvx04 = g_rvv[l_ac].rvv38t   #NO.TQC-750115

               LET g_rvv[l_ac].rvv38 = g_rvv[l_ac].rvv38t / (1 + g_rvv[l_ac].pmm43/100)                                             
              
               IF l_gec05 = 'T' THEN
                  LET g_rvv[l_ac].rvv38 = g_rvv[l_ac].rvv38t * (1 - g_rvv[l_ac].pmm43/100) #TQC-C30225 add
                  LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38 , t_azi03) #TQC-C30225 add
                  LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t * g_rvv[l_ac].rvv87 #MOD-B10138 add
                  LET l_rvw06f = g_rvv[l_ac].rvv39t * (g_rvv[l_ac].pmm43/100)
                  LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
                  LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv39t - l_rvw06f 
                  LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04) 
               END IF
               LET g_rvv[l_ac].rvv38t = cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)        #MOD-B80063
               LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38,t_azi03)          #MOD-B80063
               IF l_gec05 = 'T' THEN #MOD-B10138 add
                  LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)     #MOD-A80052 g_azi04 -> t_azi04
                  LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39,t_azi04)       #MOD-A80052 g_azi04 -> t_azi04
               #MOD-B10138 add --start--
               ELSE
                  CALL i300_set_rvv39()
               END IF
               #MOD-B10138 add --end--
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rvv[l_ac].* = g_rvv_t.*
            CLOSE t300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_rvv[l_ac].rvv02,-263,1)
            LET g_rvv[l_ac].* = g_rvv_t.*
         ELSE 
            #CHI-A80025 add --start--
            IF g_sma.sma116 MATCHES '[02]' THEN #不使用計價單位時,計價單位/數量給原單據單位/數量
               SELECT rvv35 INTO l_rvv35 FROM rvv_file
                WHERE rvv01 = g_rvv[l_ac].rvv01 
                  AND rvv02 = g_rvv_t.rvv02
               LET g_rvv[l_ac].rvv86 = l_rvv35
               LET g_rvv[l_ac].rvv87 = g_rvv[l_ac].rvv17
            END IF
            #CHI-A80025 add --end--

            LET g_success = 'Y' #CHI-A80025 add
            SELECT rvv09 INTO l_rvv09 FROM rvv_file WHERE rvv01 = g_rvv[l_ac].rvv01
            IF l_rvv09 > g_sma.sma53 THEN    #MOD-AB0015
               UPDATE rvv_file
                  SET rvv38 = g_rvv[l_ac].rvv38,
                      rvv39 = g_rvv[l_ac].rvv39,
                      rvv38t= g_rvv[l_ac].rvv38t,
                      rvv39t= g_rvv[l_ac].rvv39t, #CHI-A80025 add ,
                      rvv86 = g_rvv[l_ac].rvv86,  #CHI-A80025 add
                      rvv87 = g_rvv[l_ac].rvv87   #CHI-A80025 add
                WHERE rvv01 = g_rvv[l_ac].rvv01 
                  AND rvv02 = g_rvv_t.rvv02
                 #AND rvv03 = '1' #MOD-B40213 mark
                  AND rvv23 = 0
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rvv_file",g_rvv_t.rvv01 ,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_rvv[l_ac].* = g_rvv_t.*
                   #ROLLBACK WORK      #CHI-A80025 mark
                    LET g_success ='N' #CHI-A80025 add
                 ELSE
                    MESSAGE 'UPDATE O.K'
                 END IF
                 IF tm.schange = 'Y' THEN 
                    UPDATE pmn_file 
                    SET pmn31 = g_rvv[l_ac].rvv38 ,pmn31t = g_rvv[l_ac].rvv38t,pmn88 = g_rvv[l_ac].rvv39 ,pmn88t = g_rvv[l_ac].rvv39t 
                    WHERE pmn04 = g_rvv[l_ac].rvv31 AND pmn01 = g_rvv[l_ac].rvv36 AND pmn02= g_rvv[l_ac].rvv37
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","pmn_file",g_rvv[l_ac].rvv01 ,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
                        LET g_success ='N'
                    END IF
                    UPDATE pmm_file SET pmm40=(SELECT sum(pmn88) FROM pmn_file WHERE pmn01=g_rvv[l_ac].rvv36),
                                        pmm40t=(select sum(pmn88t) from pmn_file WHERE pmn01=g_rvv[l_ac].rvv36)
                    WHERE pmm01=g_rvv[l_ac].rvv36

                  END IF 
                  LET g_msg=TIME
                    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
                       VALUES ('cpmp730',g_user,g_today,g_msg,g_rvv[l_ac].rvv01,'update',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
                    CLEAR FORM
            #-----MOD-AB0015---------
            ELSE
               CALL cl_err(g_rvv[l_ac].rvv01 ,'apm1051',0)
               LET g_rvv[l_ac].* = g_rvv_t.*
            END IF   
            #-----END MOD-AB0015-----
            
              LET l_time = TIME  #FUN-840027
    
                INSERT INTO rvx_file(rvx01,rvx02,rvx03,rvx031,rvx04,rvx04t,   #FUN-840027
                                     rvx05,rvx05t,rvx06,rvx06t,rvxuser,rvxplant,rvxlegal,rvxoriu,rvxorig)  #FUN-980006 add rvxplant,rvxlegal       
                VALUES(g_rvv[l_ac].rvv01 ,g_rvv[l_ac].rvv02,g_today,l_time,                #FUN-840027                  
                       g_rvv_t.rvv38,g_rvv_t.rvv38t,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,
                       g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_user,g_plant,g_legal, g_user, g_grup) #FUN-980006 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                
                IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #NO.TQC-750115
               
                   CALL cl_err3("ins","rvx_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                  #ROLLBACK WORK      #CHI-A80025 mark                                              
                   LET g_success ='N' #CHI-A80025 add
    
                ELSE
                   #NO.TQC-750115 start--------
#                  IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
                   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-C30115 add
                       UPDATE rvx_file 
                          SET rvx04t = g_rvv_t.rvv38t,
                              rvx05t = g_rvv[l_ac].rvv38t,
                              rvx05  = g_rvv[l_ac].rvv38,  
                              rvx06  = g_rvv[l_ac].rvv39,
                              rvx06t = g_rvv[l_ac].rvv39t,
                              rvxuser = g_user  
                        WHERE rvx01 = g_rvv[l_ac].rvv01 
                          AND rvx02 = g_rvv[l_ac].rvv02
                         AND rvx03 = g_today        
                         AND rvx031 = l_time         #FUN-840027        
                        AND rvx04 = g_rvv_t.rvv38
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         CALL cl_err3("upd","rvv_file",g_rvv[l_ac].rvv01 ,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
                        #ROLLBACK WORK      #CHI-A80025 mark
                         LET g_success ='N' #CHI-A80025 add
                      END IF
                 END IF 

                 #CHI-A80025 add --start--
                 UPDATE rvu_file SET rvumodu=g_user,rvudate=g_today
                  WHERE rvu01 = g_rvv[l_ac].rvv01 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rvv_file",g_rvv[l_ac].rvv01 ,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
                    LET g_success ='N'
                 END IF
                 #CHI-A80025 add --end--
 
                 #NO.TQC-750115 end------------
                 #COMMIT WORK   #CHI-A80025 mark
                 #CHI-A80025 add --start--
                 IF g_success ='Y' THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK
                 END IF
                 #CHI-A80025 add --end--         
              END IF                                
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_rvv[l_ac].* = g_rvv_t.*
            END IF 
            CLOSE t300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL cl_set_comp_entry("rvv38",TRUE)
         CLOSE t300_bcl
         COMMIT WORK

      #CHI-A80025 add --start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rvv86) #計價單位
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_rvv[l_ac].rvv86
               CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv86
               DISPLAY BY NAME g_rvv[l_ac].rvv86
               NEXT FIELD rvv86
            OTHERWISE EXIT CASE
         END CASE
      #CHI-A80025 add --end--
 
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
    
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT
 
   CLOSE t300_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION t300_b_fill(g_wc)                #BODY FILL UP
DEFINE   g_wc    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
DEFINE  l_rvu02  LIKE rvu_file.rvu02          #MOD-B40012

{
  IF tm.sprice = '1' AND tm.cgtype ='1' THEN
      LET g_wc = g_wc, " AND rvv38 = 0 "," AND pmm02 = 'SUB' "
   END IF                        
   IF tm.sprice = '2' AND tm.cgtype ='1' THEN
      LET g_wc = g_wc, " AND rvv38 > 0 "," AND pmm02 = 'SUB' "
   END IF                        
   IF tm.sprice = '3' AND tm.cgtype ='1'  THEN
      LET g_wc = g_wc," AND pmm02 = 'SUB' "
   END IF                           
   IF tm.sprice = '1' AND tm.cgtype ='2' THEN 
      LET g_wc = g_wc, " AND rvv38 = 0 "," AND pmm02 <> 'SUB' "   
	END IF 		                    
	IF tm.sprice = '2' AND tm.cgtype ='2' THEN  
		LET g_wc = g_wc, " AND rvv38 > 0 "," AND pmm02 <> 'SUB' "
	END IF 		                    
	IF tm.sprice = '3' AND tm.cgtype ='2' THEN  
        LET g_wc = g_wc," AND pmm02 <> 'SUB' "
	END IF 		                          
	IF tm.sprice = '1' AND tm.cgtype ='3' THEN   
       LET g_wc = g_wc, " AND rvv38 = 0 "
			
	END IF 		                    
	IF tm.sprice = '2' AND tm.cgtype ='3' THEN 
       LET g_wc = g_wc, " AND rvv38 > 0 "
	END IF 		                    
	IF tm.sprice = '3' AND tm.cgtype ='3'THEN    
	   LET g_wc = g_wc		                    
    END IF	 }
    
    LET g_sql =" SELECT rvu04,pmc02,pmm21,pmm43,rvv01,rvv02,rvu03,rvv36,rvv37,rvv31,'','',rvv17,",   
               " pmn20-pmn50-pmn51-pmn53+pmn55+pmn58, pmn07,rvv86,rvv87,rvv38t,rvv38,rvv39t,rvv39",
               " FROM rvv_file left outer join rvu_file on rvv01 = rvu01 left outer join pmc_file on pmc01 = rvu04,",
               " pmm_file left outer join pmn_file on pmm01 = pmn01 ",
               " WHERE rvv36 = pmn01 AND rvv37=pmn02 AND  rvu08='SUB' AND rvu04 in ('Z.0124','Z.0144') ", 
               " AND rvv38t=0 AND rvu03 BETWEEN to_date('161201','yymmdd') AND to_date ('161231','yymmdd') AND ",g_wc CLIPPED,
	       " ORDER BY rvu04,rvv01,rvv02,rvv36,rvv37"    
   PREPARE t300_prepare2 FROM g_sql       #預備一下
   DECLARE rvv_curs CURSOR FOR t300_prepare2
 
   CALL g_rvv.clear()
   LET l_ac = 1
   LET g_gec07 = 'N'
 
   FOREACH rvv_curs INTO g_rvv[l_ac].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #MOD-B30669 add --start--
      SELECT ima02,ima021 INTO g_rvv[l_ac].ima02,g_rvv[l_ac].ima021
      FROM ima_file
      WHERE ima01 = g_rvv[l_ac].rvv31
      IF STATUS THEN
         IF g_rvv[l_ac].rvv31[1,4] = 'MISC' THEN
            SELECT ima02,ima021 INTO g_rvv[l_ac].ima02,g_rvv[l_ac].ima021
              FROM ima_file
             WHERE ima01 = 'MISC'
         END IF 
      END IF
      #MOD-B30669 add --end--
      #MOD-B40213 add --start--
      IF cl_null(g_rvv[l_ac].pmm43) THEN
         SELECT gec01,gec04 
           INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43 
         FROM gec_file,pmc_file,rvv_file
         WHERE gec01 = pmc47
            AND pmc01 = rvv06
            AND rvv01 = g_rvv[l_ac].rvv01
            AND gec011='1'  #進項
      END IF
      IF g_rvv[l_ac].rvl_rk < 0 THEN 
        LET g_rvv[l_ac].rvl_rk = 0
      END IF 
      #MOD-B40213 add --end--
#MOD-B40012 --begin--
      IF cl_null(g_rvv[l_ac].rvv36) THEN 
         SELECT rvu02 INTO l_rvu02 FROM rvu_file
          WHERE rvu01 = g_rvv[l_ac].rvv01
         SELECT rva115,rva116 INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43
           FROM rva_file
          WHERE rva01 = l_rvu02  
      END IF 
      LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvv.deleteElement(l_ac)
   LET g_rec_b = l_ac-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET l_ac = 0
END FUNCTION
 
FUNCTION t300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.sprice,tm.cgtype,tm.schange FROM sprice,cgtype,schange ATTRIBUTE(WITHOUT DEFAULTS)
	BEFORE INPUT
	   CALL DIALOG.setArrayAttributes("s_rvv",g_rvv)    #参数：屏幕变量,属性数组
	   CALL ui.Interface.refresh()
	   
	ON CHANGE sprice
	 
	   CALL t300_b_fill(g_wc)
	   CALL ui.interface.refresh()
 
	   DISPLAY tm.sprice TO sprice
	EXIT DIALOG
　　　　ON CHANGE cgtype
	   CALL t300_b_fill(g_wc)
	   CALL ui.interface.refresh()
	   DISPLAY tm.cgtype TO cgtype
	   EXIT DIALOG
	END INPUT   
	
      DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
      END DISPLAY
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
                              
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION price_change              #入庫單單價變更查詢 
         LET g_action_choice="price_change"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i300_def_form() #CHI-A80025 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about        
         CALL cl_about()     
   
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t300_1()                         #價格變更查詢
   DEFINE   l_cmd   LIKE type_file.chr1000   
   DEFINE   l_sql STRING
   DEFINE   l_pmm22 LIKE pmm_file.pmm22,
            l_pmm41 LIKE pmm_file.pmm41,
            l_pmm20 LIKE pmm_file.pmm20,
            l_pmn73 LIKE pmn_file.pmn73,
            l_pmn74 LIKE pmn_file.pmn74,
            l_pmm02 LIKE pmm_file.pmm02

#str-----add by huanglf161102
DEFINE l_tc_pmj09   LIKE tc_pmj_file.tc_pmj09
DEFINE l_tc_pmj07   LIKE tc_pmj_file.tc_pmj07
DEFINE l_tc_pmj07t  LIKE tc_pmj_file.tc_pmj07t
DEFINE l_num        LIKE type_file.num5
#str-----end by huanglf161102
#add by donghy 161106 start
DEFINE l_tc_pmj15   LIKE tc_pmj_file.tc_pmj15
DEFINE l_tc_pmj16   LIKE tc_pmj_file.tc_pmj16
DEFINE l_tc_pmj17   LIKE tc_pmj_file.tc_pmj17
DEFINE l_tc_pmj18   LIKE tc_pmj_file.tc_pmj18
DEFINE l_tc_pmj19   LIKE tc_pmj_file.tc_pmj19
DEFINE l_tc_pmj20   LIKE tc_pmj_file.tc_pmj20
DEFINE l_tc_pmj21   LIKE tc_pmj_file.tc_pmj21
DEFINE l_tc_ecn09   LIKE tc_ecn_file.tc_ecn09
DEFINE l_msg        STRING
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE g_tc_shd01  LIKE tc_shd_file.tc_shd01
DEFINE l_year      CHAR(10)
DEFINE l_mon       CHAR(10)
DEFINE l_day       CHAR(10)
DEFINE l_str       LIKE tc_shd_file.tc_shd01
DEFINE l_tc_shd    RECORD LIKE tc_shd_file.*
DEFINE l_shb01_t   LIKE shb_file.shb01
DEFINE l_shb04_t   LIKE shb_file.shb04
DEFINE l_tc_shb   RECORD LIKE tc_shb_file.*
DEFINE  l_pmn78   LIKE pmn_file.pmn78,
        l_pmn41   LIKE pmn_file.pmn41
#add by donghy 161106 end
   CALL g_rvv.clear()
          
   LET l_ac = 1
 {   IF tm.sprice = '1' AND tm.cgtype ='1' THEN
      LET g_wc = g_wc, " AND rvv38 = 0 "," AND pmm02 = 'SUB' "
   END IF                        
   IF tm.sprice = '2' AND tm.cgtype ='1' THEN
      LET g_wc = g_wc, " AND rvv38 > 0 "," AND pmm02 = 'SUB' "
   END IF                        
   IF tm.sprice = '3' AND tm.cgtype ='1'  THEN
      LET g_wc = g_wc," AND pmm02 = 'SUB' "
   END IF                           
   IF tm.sprice = '1' AND tm.cgtype ='2' THEN 
      LET g_wc = g_wc, " AND rvv38 = 0 "," AND pmm02 <> 'SUB' "   
	END IF 		                    
	IF tm.sprice = '2' AND tm.cgtype ='2' THEN  
		LET g_wc = g_wc, " AND rvv38 > 0 "," AND pmm02 <> 'SUB' "
	END IF 		                    
	IF tm.sprice = '3' AND tm.cgtype ='2' THEN  
        LET g_wc = g_wc," AND pmm02 <> 'SUB' "
	END IF 		                          
	IF tm.sprice = '1' AND tm.cgtype ='3' THEN   
       LET g_wc = g_wc, " AND rvv38 = 0 "
			
	END IF 		                    
	IF tm.sprice = '2' AND tm.cgtype ='3' THEN 
       LET g_wc = g_wc, " AND rvv38 > 0 "
	END IF 		                    
	IF tm.sprice = '3' AND tm.cgtype ='3'THEN    
	   LET g_wc = g_wc		                    
    END IF	 }
   LET l_sql =" SELECT rvu04,pmc02,pmm21,pmm43,rvv01,rvv02,rvu03,rvv36,rvv37,rvv31,'','',rvv17,",   
              " pmn20-pmn50-pmn51-pmn53+pmn55+pmn58, pmn07,rvv86,rvv87,rvv38t,rvv38,rvv39t,rvv39",
              " FROM rvv_file left outer join rvu_file on rvv01 = rvu01 left outer join pmc_file on pmc01 = rvu04,",
              " pmm_file left outer join pmn_file on pmm01 = pmn01 ",
              " WHERE rvv36 = pmn01 AND rvv37=pmn02 AND rvu08='SUB' ", 
              " AND rvu03 BETWEEN TO_DATE('161201','YYMMDD') AND TO_DATE('161231','yymmdd') AND rvu04 in ('Z.0124','Z.0144') ",
              " AND  ",g_wc CLIPPED,
              " ORDER BY rvu04,rvv01,rvv02,rvv36,rvv37"

   PREPARE t300_change FROM l_sql       #預備一下
   DECLARE t300_price_curs CURSOR FOR t300_change
   FOREACH t300_price_curs INTO g_rvv[l_ac].*   #單身 ARRAY 填充
      LET g_rvv1[l_ac].* = g_rvv[l_ac].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_rvv[l_ac].rvl_rk < 0 THEN 
        LET g_rvv[l_ac].rvl_rk = 0
      END IF
      
      LET l_tc_pmj07 = 0
      LET l_tc_pmj07t = 0
      LET l_pmn78 = ''
      DISPLAY l_ac
      SELECT pmn78 INTO l_pmn78 FROM pmn_file WHERE pmn01=g_rvv[l_ac].rvv36 AND pmn02=g_rvv[l_ac].rvv37
      
      SELECT pmm22,pmm41,pmm20,pmm02 INTO l_pmm22,l_pmm41,l_pmm20,l_pmm02 FROM pmm_file WHERE pmm01 = g_rvv[l_ac].rvv36
      IF l_pmm02 = 'SUB' THEN 
          LET g_type = "2"
      ELSE 
          LET g_type = "1"
      END IF
      
      CALL s_defprice_new(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvu04,l_pmm22,
                      g_today,g_rvv[l_ac].rvv87,l_pmn78,g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,g_type,    
                      g_rvv[l_ac].rvv86,'',l_pmm41,l_pmm20,g_plant)
      RETURNING l_tc_pmj07,l_tc_pmj07t,l_pmn73,l_pmn74  
 
      # #tianry add 161202
        
       
        SELECT pmn78,pmn41 INTO l_pmn78,l_pmn41 FROM pmn_file where pmn01=g_rvv[l_ac].rvv36 AND pmn02=g_rvv[l_ac].rvv37 
        LET l_num = 0        
        SELECT COUNT(*) INTO l_num FROM tc_ecm_file 
        WHERE tc_ecm00 = l_pmn41 AND tc_ecm01 = g_rvv[l_ac].rvv31 AND tc_ecm02 =l_pmn78
        IF l_num > 0 THEN
           
          SELECT tc_ecm03,tc_ecm04,tc_ecm05,tc_ecm06,tc_ecm07,tc_ecm08,tc_ecmud06
          INTO l_tc_pmj15,l_tc_pmj16,l_tc_pmj17,l_tc_pmj18,l_tc_pmj19,l_tc_pmj20,l_tc_pmj21
          FROM tc_ecm_file WHERE tc_ecm00 = l_pmn41
          AND tc_ecm01 = g_rvv[l_ac].rvv31  AND tc_ecm02 = l_pmn78         
        ELSE 
            #可能会有部分数据工单开立时尚未维护数据;若工单无资料则检查工艺资料 
            SELECT COUNT(*) INTO l_num FROM tc_ecn_file 
            WHERE tc_ecn01 = g_rvv[l_ac].rvv31 AND tc_ecn02 = l_pmn78
            IF l_num > 0 THEN
               SELECT MAX(tc_ecn09) INTO l_tc_ecn09 FROM tc_ecn_file 
               WHERE tc_ecn01 = g_rvv[l_ac].rvv31 AND tc_ecn02 = l_pmn78
               
               SELECT tc_ecn03,tc_ecn04,tc_ecn05,tc_ecn06,tc_ecn07,tc_ecn08,tc_ecnud06
               INTO l_tc_pmj15,l_tc_pmj16,l_tc_pmj17,l_tc_pmj18,l_tc_pmj19,l_tc_pmj20,l_tc_pmj21
               FROM tc_ecn_file WHERE tc_ecn01 = g_rvv[l_ac].rvv31
               AND tc_ecn02 = l_pmn78  AND tc_ecn09=l_tc_ecn09
            END IF
        END IF        
        IF l_num > 0 THEN
             #数据整理
             IF cl_null(l_tc_pmj15) THEN LET l_tc_pmj15 = 0 END IF
             IF cl_null(l_tc_pmj16) THEN LET l_tc_pmj16 = 0 END IF
             IF cl_null(l_tc_pmj17) THEN LET l_tc_pmj17 = 0 END IF
             IF cl_null(l_tc_pmj18) THEN LET l_tc_pmj18 = 0 END IF
             IF cl_null(l_tc_pmj19) THEN LET l_tc_pmj19 = 0 END IF
             IF cl_null(l_tc_pmj20) THEN LET l_tc_pmj20 = 0 END IF
             IF cl_null(l_tc_pmj21) THEN LET l_tc_pmj21 = 0 END IF
             #只要是参数工艺，无条件设置单价为0后重新取
#             LET l_pmn.pmn31 = 0
#             LET l_pmn.pmn31t = 0     
             LET g_rvv[l_ac].rvv38=0 LET  g_rvv[l_ac].rvv38t=0
 
             #数据整理
             LET l_tc_pmj09 = ''
             LET l_tc_pmj07 = 0
             LET l_tc_pmj07t =0
             SELECT MAX(tc_pmj09) INTO l_tc_pmj09 FROM tc_pmj_file,tc_pmi_file 
              WHERE tc_pmj03 = g_rvv[l_ac].rvv31 #l_pmn.pmn04 
                AND tc_pmi01 = tc_pmj01
                AND tc_pmi03 = g_rvv[l_ac].rvu04
                AND tc_pmj10 = l_pmn78
                AND tc_pmj12 = '2'
                AND tc_pmiconf = 'Y'
                AND tc_pmj15=l_tc_pmj15
                AND tc_pmj16=l_tc_pmj16
                AND tc_pmj17=l_tc_pmj17
                AND tc_pmj18=l_tc_pmj18
                AND tc_pmj19=l_tc_pmj19
                AND tc_pmj20=l_tc_pmj20
                AND tc_pmj21=l_tc_pmj21
             IF NOT cl_null(l_tc_pmj09) THEN 
                SELECT tc_pmj07,tc_pmj07t INTO l_tc_pmj07,l_tc_pmj07t FROM tc_pmj_file,tc_pmi_file
                WHERE tc_pmj03 = g_rvv[l_ac].rvv31
                AND tc_pmi01 = tc_pmj01
                AND tc_pmi03 = g_rvv[l_ac].rvu04
                AND tc_pmj10 = l_pmn78
                AND tc_pmj09 = l_tc_pmj09
                AND tc_pmj12 = '2'
                AND tc_pmiconf = 'Y'
                AND tc_pmj15=l_tc_pmj15
                AND tc_pmj16=l_tc_pmj16
                AND tc_pmj17=l_tc_pmj17
                AND tc_pmj18=l_tc_pmj18
                AND tc_pmj19=l_tc_pmj19
                AND tc_pmj20=l_tc_pmj20
                AND tc_pmj21=l_tc_pmj21
            END IF
         END IF 
         IF cl_null(l_tc_pmj07) THEN 
                LET l_tc_pmj07 = 0 
         END IF 
         IF cl_null(l_tc_pmj07t) THEN 
                LET l_tc_pmj07t = 0
         END IF 
     IF NOT cl_null(l_tc_pmj07) AND  l_tc_pmj07!=0 THEN    
        LET  g_rvv[l_ac].rvv38 = l_tc_pmj07
        LET  g_rvv[l_ac].rvv38t = l_tc_pmj07t    
     END IF 
     #tianry add end 
      CALL i300_set_rvv39()
      #IF g_rvv1[l_ac].rvv38 <> g_rvv[l_ac].rvv38 THEN 
          UPDATE rvv_file 
          SET rvv38 = g_rvv[l_ac].rvv38 ,rvv38t = g_rvv[l_ac].rvv38t,rvv39 = g_rvv[l_ac].rvv39 ,rvv39t = g_rvv[l_ac].rvv39t 
          WHERE rvv31 = g_rvv[l_ac].rvv31 AND rvv01 = g_rvv[l_ac].rvv01 AND rvv02 = g_rvv[l_ac].rvv02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rvv_file",g_rvv[l_ac].rvv01 ,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
            LET g_success ='N'
          END IF
          LET tm.schange='Y' 
          IF tm.schange = 'Y' THEN 
              UPDATE pmn_file 
              SET pmn31 = g_rvv[l_ac].rvv38 ,pmn31t = g_rvv[l_ac].rvv38t,pmn88 = g_rvv[l_ac].rvv39 ,pmn88t = g_rvv[l_ac].rvv39t 
              WHERE pmn04 = g_rvv[l_ac].rvv31 AND pmn01 = g_rvv[l_ac].rvv36 AND pmn02= g_rvv[l_ac].rvv37
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","pmn_file",g_rvv[l_ac].rvv01 ,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
                LET g_success ='N'
              END IF
          END IF 
          LET g_msg=TIME
            INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
               VALUES ('cpmp730',g_user,g_today,g_msg,g_rvv[l_ac].rvv01,'update',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
            CLEAR FORM
         #END IF 
      LET l_ac = l_ac + 1
   END FOREACH
    CALL g_rvv.deleteElement(l_ac)
    LET g_rec_b = l_ac-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET l_ac = 0
    DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b)
    
END FUNCTION

#CHI-A80025 add --start--
FUNCTION i300_unit(p_unit)  #單位
   DEFINE p_unit    LIKE gfe_file.gfe01,
          l_gfeacti LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfeacti INTO l_gfeacti
          FROM gfe_file WHERE gfe01 = p_unit
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                  LET l_gfeacti = NULL
        WHEN l_gfeacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i300_set_rvv39()
  LET g_rvv[l_ac].rvv39  = g_rvv[l_ac].rvv38 * g_rvv[l_ac].rvv87 
  LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t * g_rvv[l_ac].rvv87
  LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04) #MOD-B10138 add
  LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t , t_azi04) #MOD-B10138 add

  IF g_gec07='Y' THEN
     LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv39t / ( 1 + g_rvv[l_ac].pmm43/100)
     LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04)
    #LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t , t_azi04) #MOD-B10105 add #MOD-B10138 mark
  ELSE
     LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv39 * ( 1 + g_rvv[l_ac].pmm43/100)
     LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t , t_azi04)
    #LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04) #MOD-B10105 add #MOD-B10138
  END IF
  DISPLAY BY NAME g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
END FUNCTION

FUNCTION i300_set_rvv87()
  DEFINE    l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_img09  LIKE img_file.img09,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac, 
            l_rvv32  LIKE rvv_file.rvv32,
            l_rvv33  LIKE rvv_file.rvv33,
            l_rvv34  LIKE rvv_file.rvv34,
            l_rvv35  LIKE rvv_file.rvv35,
            l_rvv81  LIKE rvv_file.rvv81,
            l_rvv82  LIKE rvv_file.rvv82,
            l_rvv84  LIKE rvv_file.rvv84,
            l_rvv85  LIKE rvv_file.rvv85

   SELECT ima25,ima44,ima906 INTO g_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
   IF SQLCA.sqlcode = 100 THEN
      IF g_rvv[l_ac].rvv31 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO g_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44=g_ima25 END IF

   SELECT rvv32,rvv33,rvv34,rvv35,rvv81,rvv82,rvv84,rvv85 
     INTO l_rvv32,l_rvv33,l_rvv34,l_rvv35,l_rvv81,l_rvv82,l_rvv84,l_rvv85 FROM rvv_file
    WHERE rvv01 = g_rvv[l_ac].rvv01 
      AND rvv02 = g_rvv_t.rvv02
   LET l_fac2=l_rvv84
   LET l_qty2=l_rvv85
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=l_rvv81
      LET l_qty1=l_rvv82
   ELSE
     LET l_fac1=1
     LET l_qty1=g_rvv[l_ac].rvv17
     CALL s_umfchk(g_rvv[l_ac].rvv31,l_rvv35,l_ima44)
           RETURNING l_ac,l_fac1
     IF l_ac = 1 THEN
        LET l_fac1 = 1
     END IF
   END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01=g_rvv[l_ac].rvv31
      AND img02=l_rvv32
      AND img03=l_rvv33
      AND img04=l_rvv34
   IF l_img09 IS NULL THEN LET l_img09=l_ima44 END IF

   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   LET l_factor = 1
   IF g_sma.sma115 = 'Y' THEN
      CALL s_umfchk(g_rvv[l_ac].rvv31,l_rvv35,g_rvv[l_ac].rvv86)
            RETURNING l_ac,l_factor
   ELSE
      CALL s_umfchk(g_rvv[l_ac].rvv31,l_ima44,g_rvv[l_ac].rvv86)
            RETURNING l_ac,l_factor
   END IF 
   IF l_ac = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor

   LET g_rvv[l_ac].rvv87 = l_tot
END FUNCTION

FUNCTION i300_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
   CALL cl_set_comp_entry("rvv86,rvv87",TRUE)
END FUNCTION

FUNCTION i300_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1,
         l_n       LIKE type_file.num5   #MOD-AB0019

   IF NOT g_before_input_done OR p_cmd = 'u' THEN
      CALL cl_set_comp_entry("rvv86",FALSE)
   END IF

   IF g_sma.sma116 MATCHES '[02]' THEN
      CALL cl_set_comp_entry("rvv86,rvv87",FALSE)
   END IF
                    
   CALL cl_set_comp_entry("rvv87",FALSE)                      

END FUNCTION

FUNCTION i300_set_required(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd IS NOT NULL THEN
      IF g_sma.sma116 MATCHES '[13]' THEN    #使用計價單位時
         CALL cl_set_comp_required("rvv87",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION i300_set_no_required(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   CALL cl_set_comp_required("rvv86,rvv87",FALSE)
END FUNCTION

FUNCTION i300_def_form()
  IF g_sma.sma116 MATCHES '[02]' THEN    #不使用計價單位
     CALL cl_set_comp_visible("rvv86,rvv87",FALSE)
  END IF
END FUNCTION
#CHI-A80025 add --end--

#No.FUN-BB0086---start---add---
FUNCTION i300_rvv87_check()
   IF NOT cl_null(g_rvv[l_ac].rvv86) AND NOT cl_null(g_rvv[l_ac].rvv87) THEN
      IF cl_null(g_rvv_t.rvv87) OR cl_null(g_rvv86_t) OR g_rvv_t.rvv87 != g_rvv[l_ac].rvv87 OR g_rvv86_t != g_rvv[l_ac].rvv86 THEN
         LET g_rvv[l_ac].rvv87=s_digqty(g_rvv[l_ac].rvv87, g_rvv[l_ac].rvv86)
         DISPLAY BY NAME g_rvv[l_ac].rvv87
      END IF
   END IF
   IF g_rvv[l_ac].rvv87 < 0 THEN
      CALL cl_err('','afa-043',0)
      RETURN FALSE 
   END IF
   CALL i300_set_rvv39()
   RETURN TRUE 
END FUNCTION 
#No.FUN-BB0086---end---add---
