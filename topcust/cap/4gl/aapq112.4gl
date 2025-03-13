# Prog. Version..: '5.25.02-11.06.22(00010)'     #
#
# Pattern name...: aapq112.4gl
# Descriptions...: 入庫請款資料查詢
# Date & Author..: 94/03/10 By Roger
# Modify.........: 97/05/12 By danny 組SQL時,加入rvb_file
# Modify.........: 97/07/30 By kitty 加確認QBE及show出確認碼,樣品碼
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-560089 05/06/19 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0104 06/11/21 By Rayven 匯出EXCEL匯出的值多一空白行
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0083 07/11/27 By Carrier add rvv88/rvv23
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9A0024 09/10/09 By destiny display xxx.*改為display對應欄位 
# Modify.........: No:FUN-A30028 10/03/30 By wujie  增加来源单据串查
# Modify.........: No:TQC-A30106 10/04/13 By Carrier 单身查无资料 & rvv01变成可开窗查询
# Modify.........: No.FUN-A50098 10/05/27 By lutingting 原本展子孫寫法改回不展子孫,只抓取單頭輸入PLANT得資料
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:MOD-B60004 11/06/01 By Dido 串查傳遞調整 

DATABASE ds
 
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"     #mod by zhangym 120530
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690028 VARCHAR(600)
        	wc2  	LIKE type_file.chr1000		# Body Where condition  #No.FUN-690028 VARCHAR(600)
        END RECORD,
    g_body DYNAMIC ARRAY OF RECORD
            rvv03   LIKE rvv_file.rvv03,   #add by zhangym 120530
            rvv01   LIKE rvv_file.rvv01,   #add by zhangym 120530
            rvv02   LIKE rvv_file.rvv02,   #項次
            rvv09   LIKE rvv_file.rvv09,
            rvv06   LIKE rvv_file.rvv06,
            pmc03   LIKE pmc_file.pmc03,
            rvv04   LIKE rvv_file.rvv04,
            rvv05   LIKE rvv_file.rvv05,
            rvv36   LIKE rvv_file.rvv36,   #採購單號
            rvv37   LIKE rvv_file.rvv37,   #項次
            rvv31   LIKE rvv_file.rvv31,   #料件編號
            pmn041   LIKE pmn_file.pmn041,   # P/O Item description
            pmm22    LIKE pmm_file.pmm22,    # P/O Curr
            rvv38   LIKE rvv_file.rvv38,   #U/P
            #No.TQC-7B0083  --Begin
            rvv87   LIKE rvv_file.rvv87,        # No.FUN-690028 INTEGER,               #
            rvv23_88 LIKE rvv_file.rvv23,        # No.FUN-690028 INTEGER,               #
            rvv23   LIKE rvv_file.rvv23,        # No.FUN-690028 INTEGER,               #
            rvv88   LIKE rvv_file.rvv88,        # No.FUN-690028 INTEGER,               #
            rvv87_23   LIKE rvv_file.rvv23,        # No.FUN-690028 INTEGER,               #
            #No.TQC-7B0083  --End  
            rvb22   LIKE rvb_file.rvb22,   #INVOICE
            rvuconf1 LIKE rvu_file.rvuconf,   #確認
            rvv25    LIKE rvv_file.rvv25    #樣品
        END RECORD,
    g_argv1     LIKE rvv_file.rvv01,       # INPUT ARGUMENT - 1
    g_query_flag       LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入next  #No.FUN-690028 SMALLINT
     g_wc,g_wc2,g_sql  string,           #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num5,  		           #單身筆數  #No.FUN-690028 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_sl            LIKE type_file.num5                 #目前處理的SCREEN LINE  #No.FUN-690028 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE source           LIKE azp_file.azp01      # No.FUN-690028 VARCHAR(10)     #FUN-630043
DEFINE a           LIKE type_file.chr1    #add by zhangym 130402  
DEFINE g_azp02   LIKE azp_file.azp02  #FUN-630043
 
MAIN
   DEFINE l_time	LIKE type_file.chr8,   		#計算被使用時間  #No.FUN-690028 VARCHAR(8)
          l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #IF (NOT cl_setup("AAP")) THEN
   IF (NOT cl_setup("CAP")) THEN     #mod by zhangym 120530
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q112_w AT p_row,p_col
       # WITH FORM "aap/42f/aapq112"
        WITH FORM "cap/42f/aapq112"    #mod by zhangym 120530      
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
#FUN-A50098--mark--str--只查詢單頭錄入PLANT得資料,所以不再需要臨時表
##FUN-980091-------------(S)
##建立一個 TEMP TABLE存放 plant 及 Key 值
#    DROP TABLE rvv_tmp
#    CREATE TABLE rvv_tmp
#    ( rvv01   VARCHAR(16),
#      source  VARCHAR(10))
##FUN-980091-------------(E)
#FUN-A50098--mark--end
 
 
    CALL q112_menu()
    CLOSE WINDOW q112_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
 
#QBE 查詢資料
FUNCTION q112_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690028 SMALLINT
#FUN-A50098--mark--str--
# #FUN-980091-------------(S)
#  DEFINE   l_plant_list  STRING 
#  DEFINE   l_azw01       LIKE azw_file.azw01
# #FUN-980091-------------(E)
#FUN-A50098--mark--end
 
   IF NOT cl_null(g_argv1)
      #THEN LET tm.wc = "rvv01 = '",g_argv1,"'"
      THEN LET tm.wc2 = "rvv01 = '",g_argv1,"'"   #mod by zhangym 120530
   ELSE CLEAR FORM #清除畫面
   CALL g_body.clear()
     CALL cl_opmsg('q')
     INITIALIZE tm.* TO NULL			# Default condition
      #FUN-630043
      LET source=g_plant 
      DISPLAY BY NAME source
      LET g_azp02=''
      SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01=source
      DISPLAY g_azp02 TO FORMONLY.azp02
      #add by zhangym 130402 begin-----
      LET a = '5'
      DISPLAY BY NAME a
      #add by zhangym 130402 end-----
     #LET g_plant_new=source     #FUN-A50098  跨庫用cl_get_target_table()實現不需要選出DB
     #CALL s_getdbs()            #FUN-A50098 
     # IF g_aza.aza53='Y' THEN   #mark by zhangym 130402
         CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
         #INPUT BY NAME source WITHOUT DEFAULTS
         INPUT BY NAME source,a WITHOUT DEFAULTS     #mod by zhangym 130402
            AFTER FIELD source 
              #FUN-980091-------------()
               IF NOT s_chk_plant(source) THEN
                  NEXT FIELD source
               END IF
              #FUN-980091-------------(E)
               LET g_azp02=''
               SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01=source
               IF STATUS THEN
#                 CALL cl_err(source,'100',0)   #No.FUN-660122
                  CALL cl_err3("sel","azp_file",source,"","100","","",0)  #No.FUN-660122
                  NEXT FIELD source
               END IF
               DISPLAY g_azp02 TO FORMONLY.azp02
              #LET g_plant_new=source     #FUN-A50098
              #CALL s_getdbs()            #FUN-A50098
              
            #add by zhangym 130402 begin----
            AFTER FIELD a
               IF cl_null(a) THEN 
                  NEXT FIELD a
               END IF 
            #add by zhangym 130402 end-----
 
            AFTER INPUT
               IF INT_FLAG THEN EXIT INPUT END IF  
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(source)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azp"
                       LET g_qryparam.default1 = source
                       CALL cl_create_qry() RETURNING source 
                       DISPLAY BY NAME source
                       NEXT FIELD source
               END CASE
 
            ON ACTION exit              #加離開功能genero
               LET INT_FLAG = 1
               EXIT INPUT
 
            ON ACTION controlg       #TQC-860021
               CALL cl_cmdask()      #TQC-860021
 
            ON IDLE g_idle_seconds   #TQC-860021
               CALL cl_on_idle()     #TQC-860021
               CONTINUE INPUT        #TQC-860021
 
            ON ACTION about          #TQC-860021
               CALL cl_about()       #TQC-860021
 
            ON ACTION help           #TQC-860021
               CALL cl_show_help()   #TQC-860021
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            CLOSE WINDOW q112_w 
            CALL  cl_used(g_prog,g_time,2)    RETURNING g_time   #FUN-B30211
            EXIT PROGRAM
         END IF
     # END IF    #mark by zhangym 130402
      #FUN-630043
     CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
     CALL q112_b_askkey()
     IF INT_FLAG THEN RETURN END IF
   END IF
 
  # MESSAGE ' WAIT '

END FUNCTION

FUNCTION q112_b_askkey()
   #No.TQC-7B0083  --Begin
   #CONSTRUCT tm.wc2 ON rvv02,rvv04,rvv05,rvv36,rvv37,rvv31,rvv38,rvv87,
   CONSTRUCT tm.wc2 ON rvv03,rvv01,rvv02,rvv09,rvv06,rvv04,rvv05,rvv36,rvv37,rvv31,rvv38,rvv87,     #mod by zhangym 120530
                       rvv23,rvv88,rvb22,rvv25
       #FROM  s_rvb[1].rvv02,
       FROM  s_rvb[1].rvv03,s_rvb[1].rvv01,s_rvb[1].rvv02,   #mod by zhangym 120530
             s_rvb[1].rvv09,s_rvb[1].rvv06,
             s_rvb[1].rvv04,s_rvb[1].rvv05,
             s_rvb[1].rvv36,s_rvb[1].rvv37,
             s_rvb[1].rvv31,s_rvb[1].rvv38,
             s_rvb[1].rvv87,s_rvb[1].rvv23,
             s_rvb[1].rvv88,s_rvb[1].rvb22,s_rvb[1].rvv25
   #No.TQC-7B0083  --End
      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
      
        ON ACTION CONTROLP
           CASE 
                #No.TQC-A30106  --Begin
                WHEN INFIELD(rvv01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_rvu2"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rvv01
                #No.TQC-A30106  --End 
                WHEN INFIELD(rvv06)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc1"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rvv06                               
           END CASE
                 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
END FUNCTION

#中文的MENU
FUNCTION q112_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-690028 CHAR(80)
   DEFINE   ls_indprog   LIKE zz_file.zz01     #MOD-B60004

   WHILE TRUE
      CALL q112_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q112_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#No.FUN-A30028 --begin  
         WHEN "qry_apm" 
            IF NOT cl_null(g_body[l_ac].rvv01) AND NOT cl_null(g_body[l_ac].rvv03) THEN       
               CASE g_body[l_ac].rvv03
                    WHEN '1' 
                     #LET g_msg = "apmt720 '",g_head_1.rvv01,"' "          #MOD-B60004 mark
                      CALL q112_check_prg('apmt720') RETURNING ls_indprog  #MOD-B60004
                     #CALL cl_cmdrun(g_msg)                                #MOD-B60004 mark
                    WHEN '2' 
                     #LET g_msg = "apmt721 '",g_head_1.rvv01,"'"           #MOD-B60004 mark
                      CALL q112_check_prg('apmt721') RETURNING ls_indprog  #MOD-B60004
                     #CALL cl_cmdrun(g_msg)                                #MOD-B60004 mark 
                    WHEN '3' 
                     #LET g_msg = "apmt722 '",g_head_1.rvv01,"'"           #MOD-B60004 mark
                      CALL q112_check_prg('apmt722') RETURNING ls_indprog  #MOD-B60004
                     #CALL cl_cmdrun(g_msg)                                #MOD-B60004 mark 
               END CASE
               LET g_msg = ls_indprog," '",g_body[l_ac].rvv01,"' 'query' '",g_body[l_ac].rvv01,"'" #MOD-B60004 
               CALL cl_cmdrun(g_msg)                                                       #MOD-B60004       
            END IF                      
#No.FUN-A30028 --end
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_body),'','')
             END IF
         #--

      END CASE
   END WHILE
END FUNCTION

#-MOD-B60004-add-
FUNCTION q112_check_prg(p_prog)
   DEFINE p_prog      LIKE zz_file.zz01
   DEFINE ls_indprog  LIKE zz_file.zz01  
   DEFINE l_cnt       LIKE type_file.num5 

   LET ls_indprog = p_prog 
   IF (g_sma.sma124 <> 'std') AND (NOT cl_null(g_sma.sma124)) THEN 
      LET ls_indprog = p_prog,"_",g_sma.sma124 CLIPPED
      SELECT COUNT(*) INTO l_cnt 
        FROM zz_file
       WHERE zz01 = ls_indprog 
      IF l_cnt = 0 THEN  
         LET ls_indprog = p_prog 
      END IF
   END IF
   RETURN ls_indprog 
END FUNCTION
#-MOD-B60004-end-

FUNCTION q112_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt

   #DELETE FROM rvv_tmp    #FUN-980091     #FUN-A50098

    CALL q112_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF

    CALL q112_show()
END FUNCTION
 
FUNCTION q112_show()

   DISPLAY BY NAME source    #FUN-A50098
   DISPLAY BY NAME a         #add by zhangym 130402

   CALL q112_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q112_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(600)
 
   LET l_sql =
   "SELECT rvv03,rvv01,rvv02,rvv09,rvv06,pmc03,rvv04,rvv05,rvv36,rvv37,rvv31,",
        #"  pmn041,pmm22,rvv38,rvv17,rvv23,rvv17-rvv23,",   #FUN-560089
        "  pmn041,pmm22,rvv38,rvv87,rvv23+rvv88,rvv23,rvv88,rvv87-rvv23-rvv88,",   #FUN-560089  #No.TQC-7B0083 add rvv23_88/rvv88
        "  rvb22,rvuconf,rvv25",
#FUN-A50098--mod--str---跨庫寫法改用cl_get_target_table
#       "  FROM ",g_dbs_tra CLIPPED,"rvu_file,",
#       "       ",g_dbs_tra CLIPPED,"rvv_file,",
#       "       OUTER ",g_dbs_tra CLIPPED,"rvb_file,",
#       "       OUTER ",g_dbs_tra CLIPPED,"pmn_file,",
#       "       OUTER ",g_dbs_tra CLIPPED,"pmm_file ",
        "  FROM ",cl_get_target_table(source,'rvu_file'),",",
        "       ",cl_get_target_table(source,'rvv_file'),
        "  LEFT OUTER JOIN ",cl_get_target_table(source,'rvb_file'),
        "          ON rvv04 = rvb01 AND rvv05 = rvb02",
        "  LEFT OUTER JOIN ",cl_get_target_table(source,'pmn_file'),
        "          ON rvv36 = pmn01 AND rvv37 = pmn02",
        "  LEFT OUTER JOIN ",cl_get_target_table(source,'pmm_file'),
        "          ON rvv36 = pmm01",
        "  LEFT OUTER JOIN ",cl_get_target_table(source,'pmc_file'),
        "          ON rvv06 = pmc01",
#FUN-A50098--mod--end
       #FUN-980091-----------(E)
       #END FUN-630043
        " WHERE rvu01 = rvv01 ",
       #"   AND rvv04 = rvb01 AND rvv05 = rvb02",     #FUN-A50098
       #"   AND rvv36 = pmn01 AND rvv37 = pmn02",     #FUN-A50098
       #"   AND rvv36 = pmm01",                       #FUN-A50098
        "   AND ", tm.wc2 CLIPPED,
        "   AND rvuconf <> 'X' AND rvv03 <> '2' "    #add by zhangym 120903
       #" ORDER BY 1,2 "      #FUN-A50098
       # " ORDER BY rvv02,rvv04"      #FUN-A50098    #mark by zhangym 130402
        
   #add by zhangym 130402 begin-----
   IF a = '1' THEN    #已开票 
      LET l_sql = l_sql CLIPPED," AND rvb22 IS NOT NULL "
   END IF
   IF a = '2' THEN    #未开票
      LET l_sql = l_sql CLIPPED," AND rvv87 > rvv23 "
   END IF 
   IF a = '3' THEN    #已立账
      LET l_sql = l_sql CLIPPED," AND rvv23+rvv88 <> 0 "
   END IF   
   IF a = '4' THEN    #未立账
      LET l_sql = l_sql CLIPPED," AND rvv87 <> rvv23+rvv88 "
   END IF  
   LET l_sql = l_sql CLIPPED," ORDER BY rvv02,rvv04"         
   #add by zhangym 130402 end-----
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   #CALL cl_parse_qry_sql(l_sql,g_head_1.source) RETURNING l_sql #FUN-980091    #FUN-A50098
    CALL cl_parse_qry_sql(l_sql,source) RETURNING l_sql         #FUN-A50098
    PREPARE q112_pb FROM l_sql
    DECLARE q112_bcs                       #BODY CURSOR
        CURSOR FOR q112_pb

    FOR g_cnt = 1 TO g_body.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_body[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q112_bcs INTO g_body[g_cnt].*
        IF g_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_body.deleteElement(g_cnt)  #No.TQC-6B0104
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION

FUNCTION q112_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 CHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_body TO s_rvb.* ATTRIBUTES(COUNT=g_body.getLength(),UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
     #   LET l_sl = SCR_LINE()
     #add by zhangym 120530 begin-----
      BEFORE ROW 
         LET l_ac  = ARR_CURR() 
     #add by zhangym 120530 end-----       

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
      #No.MOD-530853  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530853  --end
      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
#No.FUN-A30028 --begin
      ON ACTION qry_apm
         LET g_action_choice = 'qry_apm'
         EXIT DISPLAY
#No.FUN-A30028 --end
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

