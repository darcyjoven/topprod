# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci120.4gl
# Descriptions...: 產品工藝變更維護作業
# Date & Author..: 08/01/23 By arman 
# Modify.........: No.FUN-810014 08/03/21 By arman
# Modify.........: No.FUN-870124 08/07/24 By jan 服飾功能完善
# Modify.........: No.TQC-910003 09/01/03 BY DUKE  MOVE OLD APS TABLE
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING  
# Modify.........: No.FUN-920186 09/03/17 By lala  理由碼sgr04必須為工藝原因
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-970169 09/07/22 By lilingyu [轉入單位][轉出單位]欄位錄入任意字符均能通過,需控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0118 09/10/23 By liuxqa 修改ROWID
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50100 10/05/28 By lilingyu 平行工藝
# Modify.........: No.FUN-A50066 10/06/24 By jan 變更發出時增加更新製程追蹤檔的處理
# Modify.........: No.FUN-A60092 10/06/30 By lilingyu 單身資料刪除時的處理
# Modify.........: No.TQC-B30038 11/03/03 By destiny 新增时orig,oriu未显示值
# Modify.........: No.TQC-B40011 11/04/02 By destiny 审核时总报请选取处理的资料   
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60264 11/06/22 By lixia 审核时总报请选取处理的资料
# Modify.........: No.MOD-B60044 11/07/17 By Summer 若上一筆資料為新增時，需呼叫i120_set_sgs04a()
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No.MOD-B80118 11/08/24 By sabrina insert into ecb_file語法有誤
# Modify.........: No.TQC-B80125 11/08/22 By lixh1 畫面上增加組成用量欄位(sgs051a,sgs051b)和異動損耗率欄位(sgs014a,sgs014b)
# Modify.........: No.MOD-B80309 11/10/06 By johung check in留置及check out留置應該可以不給值

# Modify.........: No.FUN-B90141 11/11/14 By jason 檢查'單位轉換分子/單位轉換分母'需等於單位轉換率
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.FUN-910088 12/01/18 By chenjing 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-C40008 13/01/10 By Nina 只要程式有UPDATE ecu_file 的任何一個欄位時,多加ecudate=g_today
# Modify.........: No.MOD-D30088 13/03/08 By suncx 新增錄入時工藝序號開窗
# Modify.........: No.MOD-D30118 13/03/12 By bart 判斷若是sgs04=3 修改時，此兩欄位不一定要輸入。
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sgr      RECORD LIKE sgr_file.*,   #No.FUN-810014
    g_sgr_t    RECORD LIKE sgr_file.*,
    g_sgr_o    RECORD LIKE sgr_file.*,
    g_sgr01_t  LIKE sgr_file.sgr01,
    g_sgr02_t  LIKE sgr_file.sgr02,
    g_sgr012_t LIKE sgr_file.sgr012,     #FUN-A50100 
    g_sgr03_t  LIKE sgr_file.sgr03,
    g_ecb03_t  LIKE ecb_file.ecb03,
    l_eci01    LIKE eci_file.eci01,
    g_wc,g_wc2,g_sql   string,                     
    g_sgs           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgs05           LIKE sgs_file.sgs05,      
        sgs04           LIKE sgs_file.sgs04,      
        sgs06           LIKE sgs_file.sgs06,     
        sgs07           LIKE sgs_file.sgs07,    
        sgs08           LIKE sgs_file.sgs08,   
        sgs09           LIKE sgs_file.sgs09,    
        sgs10           LIKE sgs_file.sgs10,    
        sgs11           LIKE sgs_file.sgs11,   
        sgs12           LIKE sgs_file.sgs12,  
        sgs13           LIKE sgs_file.sgs13, 
        sgs14           LIKE sgs_file.sgs14,    
        sgs15           LIKE sgs_file.sgs15,    
        sgs16           LIKE sgs_file.sgs16,   
        sgs17           LIKE sgs_file.sgs17,   
        sgs18           LIKE sgs_file.sgs18,  
        sgs19           LIKE sgs_file.sgs19, 
#       sgs20           LIKE sgs_file.sgs20,   #FUN-A50100
        sgs21           LIKE sgs_file.sgs21,  
#       sgs052b         LIKE sgs_file.sgs052b,  #FUN-A50100  #TQC-B80125 
        sgs22           LIKE sgs_file.sgs22,
        sgs051b         LIKE sgs_file.sgs051b, #TQC-B80125  add sgs051
        sgs052b         LIKE sgs_file.sgs052b, #TQC-B80125   
        sgs014b         LIKE sgs_file.sgs014b, #TQC-B80125   
        sgs053b         LIKE sgs_file.sgs053b,  #FUN-A50100
        sgsslk01       LIKE sgs_file.sgsslk01,
        sgsslk02       LIKE sgs_file.sgsslk02,
        sgsslk03       LIKE sgs_file.sgsslk03,
        sgsslk04       LIKE sgs_file.sgsslk04,
        sgs23           LIKE sgs_file.sgs23,
        sgs24           LIKE sgs_file.sgs24,
        sgs25           LIKE sgs_file.sgs25,
        sgs26           LIKE sgs_file.sgs26,
        sgs27           LIKE sgs_file.sgs27,
        sgs28           LIKE sgs_file.sgs28,
        sgs29           LIKE sgs_file.sgs29,
        sgs30           LIKE sgs_file.sgs30,
        sgs31           LIKE sgs_file.sgs31,
        sgs32           LIKE sgs_file.sgs32,
        sgs33           LIKE sgs_file.sgs33,
        sgs34           LIKE sgs_file.sgs34,
        sgs35           LIKE sgs_file.sgs35,
        sgs36           LIKE sgs_file.sgs36,
#       sgs37           LIKE sgs_file.sgs37,   #FUN-A50100
        sgs38           LIKE sgs_file.sgs38,
        sgs39           LIKE sgs_file.sgs39,     #TQC-B80125
        sgs051a         LIKE sgs_file.sgs051a,   #TQC-B80125 
        sgs052a         LIKE sgs_file.sgs053a,   #FUN-A50100
#       sgs39           LIKE sgs_file.sgs39,     #TQC-B80125 
        sgs014a         LIKE sgs_file.sgs014a,   #TQC-B80125
        sgs053a         LIKE sgs_file.sgs053a,   #FUN-A50100
        sgsslk05       LIKE sgs_file.sgsslk05,
        sgsslk06       LIKE sgs_file.sgsslk06,
        sgsslk07       LIKE sgs_file.sgsslk07,
        sgsslk08       LIKE sgs_file.sgsslk08    
                    END RECORD,
    g_sgs_t         RECORD                 #程式變數 (舊值)
        sgs05           LIKE sgs_file.sgs05,   
        sgs04           LIKE sgs_file.sgs04,    
        sgs06           LIKE sgs_file.sgs06,   
        sgs07           LIKE sgs_file.sgs07,   
        sgs08           LIKE sgs_file.sgs08,  
        sgs09           LIKE sgs_file.sgs09, 
        sgs10           LIKE sgs_file.sgs10,  
        sgs11           LIKE sgs_file.sgs11, 
        sgs12           LIKE sgs_file.sgs12,  
        sgs13           LIKE sgs_file.sgs13, 
        sgs14           LIKE sgs_file.sgs14,  
        sgs15           LIKE sgs_file.sgs15,  
        sgs16           LIKE sgs_file.sgs16, 
        sgs17           LIKE sgs_file.sgs17,  
        sgs18           LIKE sgs_file.sgs18, 
        sgs19           LIKE sgs_file.sgs19,  
#       sgs20           LIKE sgs_file.sgs20,   #FUN-A50100
        sgs21           LIKE sgs_file.sgs21, 
        sgs22           LIKE sgs_file.sgs22,    #TQC-B80125
        sgs051b         LIKE sgs_file.sgs051b,  #TQC-B80125        
        sgs052b         LIKE sgs_file.sgs052b,  #FUN-A50100          
        sgs014b         LIKE sgs_file.sgs014b,  #TQC-B80125
#       sgs22           LIKE sgs_file.sgs22,    #TQC-B80125   mark
        sgs053b         LIKE sgs_file.sgs053b,  #FUN-A50100        
        sgsslk01       LIKE sgs_file.sgsslk01,
        sgsslk02       LIKE sgs_file.sgsslk02,
        sgsslk03       LIKE sgs_file.sgsslk03,
        sgsslk04       LIKE sgs_file.sgsslk04,
        sgs23           LIKE sgs_file.sgs23,
        sgs24           LIKE sgs_file.sgs24,
        sgs25           LIKE sgs_file.sgs25,
        sgs26           LIKE sgs_file.sgs26,
        sgs27           LIKE sgs_file.sgs27,
        sgs28           LIKE sgs_file.sgs28,
        sgs29           LIKE sgs_file.sgs29,
        sgs30           LIKE sgs_file.sgs30,
        sgs31           LIKE sgs_file.sgs31,
        sgs32           LIKE sgs_file.sgs32,
        sgs33           LIKE sgs_file.sgs33,
        sgs34           LIKE sgs_file.sgs34,
        sgs35           LIKE sgs_file.sgs35,
        sgs36           LIKE sgs_file.sgs36,
#       sgs37           LIKE sgs_file.sgs37,  #FUN-A50100
        sgs38           LIKE sgs_file.sgs38,
        sgs39           LIKE sgs_file.sgs39,     #TQC-B80125
        sgs051a         LIKE sgs_file.sgs051a,   #TQC-B80125
        sgs052a         LIKE sgs_file.sgs053a,   #FUN-A50100        
#       sgs39           LIKE sgs_file.sgs39,     #TQC-B80125
        sgs014a         LIKE sgs_file.sgs014a,   #TQC-B80125
        sgs053a         LIKE sgs_file.sgs053a,   #FUN-A50100        
        sgsslk05       LIKE sgs_file.sgsslk05,
        sgsslk06       LIKE sgs_file.sgsslk06,
        sgsslk07       LIKE sgs_file.sgsslk07,
        sgsslk08       LIKE sgs_file.sgsslk08
                    END RECORD,
    g_sw            LIKE type_file.chr1,         
    p_row,p_col     LIKE type_file.num5,        
    g_rec_b         LIKE type_file.num5,         
    l_ac            LIKE type_file.num5         
 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5         
DEFINE g_cnt                 LIKE type_file.num10        
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_row_count           LIKE type_file.num10        
DEFINE g_curs_index          LIKE type_file.num10        
DEFINE g_jump                LIKE type_file.num10       
DEFINE mi_no_ask             LIKE type_file.num10      
DEFINE g_sql_tmp             STRING
 
MAIN
      DEFINE    l_sma124  LIKE sma_file.sma124            
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_prog = "aeci120_slk"                                                                                                      
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 1 LET p_col = 3
 
   OPEN WINDOW i120_w AT p_row,p_col WITH FORM "aec/42f/aeci120"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
                                                                                                             
 
#FUN-A50100 --begin--
   IF g_sma.sma541 = 'Y' THEN 
  	  CALL cl_set_comp_visible("sgr012,ecu014",TRUE)   
   ELSE
  	  CALL cl_set_comp_visible("sgr012,ecu014",FALSE)
   END IF 	
#FUN-A50100 --end--
 
   CALL i120()
 
   CLOSE WINDOW i120_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION i120()
 
   INITIALIZE g_sgr.* TO NULL
   INITIALIZE g_sgr_t.* TO NULL
   INITIALIZE g_sgr_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM sgr_file WHERE sgr01 = ? AND sgr02 = ? ",
                      " AND sgr03 = ? AND sgr012 = ? FOR UPDATE "  #No.TQC-9A0118 mod  #FUN-A50100
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_cl CURSOR FROM g_forupd_sql
 
   CALL i120_menu()
 
END FUNCTION
 
FUNCTION i120_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_sgs.clear()
   CALL cl_set_head_visible("","YES")    
   CONSTRUCT BY NAME g_wc ON 
#FUN-A60092 --begin--   
#        sgr01, sgr02, sgr03,sgr08,sgr06,sgr012,sgr07,sgr09,sgr04,   
#        sgr05,sgruser, sgrgrup, sgrmodu, sgrdate, sgracti  
         sgr01,sgr06,sgr04,sgr02,sgr012,sgr05,sgr03,sgr07,sgr08,sgr09,
         sgruser,sgrgrup,sgroriu,sgrorig,sgrmodu,sgrdate,sgracti 
#FUN-A60092 --end--
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgr01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecu02"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgr01
                   NEXT FIELD sgr01
#FUN-A50100 --begin--
              WHEN INFIELD(sgr012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgr012_1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgr012
                   NEXT FIELD sgr012
#FUN-A50100 --end--                   
              WHEN INFIELD(sgr04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_azf01a"   #FUN-920186
                   LET g_qryparam.arg1  = 'A'         #FUN-920186
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgr04
                   NEXT FIELD sgr04
              OTHERWISE EXIT CASE
           END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON sgs05,sgs04,sgs06,sgs07,sgs08,sgs09,sgs10,sgs11,sgs12,sgs13,sgs14,sgs15,
#                      sgs16,sgs17,sgs18,sgs19,sgs20,sgs21,sgs22,                   #FUN-A50100
#                      sgs16,sgs17,sgs18,sgs19,      sgs21,sgs052b,sgs22,sgs053b,   #FUN-A50100  #TQC-B80125  mark
                       sgs16,sgs17,sgs18,sgs19,sgs21,sgs22,sgs051b,sgs052b,sgs014b,sgs053b,      #TQC-B80125
                      sgsslk01,sgsslk02,sgsslk03,sgsslk04,
                      sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,
#                     sgs34,sgs35,sgs36,sgs37,sgs38,sgs39                   #FUN-A50100 
#                     sgs34,sgs35,sgs36,      sgs38,sgs052a,sgs39,sgs053a  #FUN-A50100  #TQC-B80125  mark
                      sgs34,sgs35,sgs36,sgs38,sgs39,sgs051a,sgs052a,sgs014a,sgs053a     #TQC-B80125 
                      ,sgsslk05,sgsslk06,sgsslk07,sgsslk08
           FROM s_sgs[1].sgs05,s_sgs[1].sgs04,s_sgs[1].sgs06,s_sgs[1].sgs07,s_sgs[1].sgs08,s_sgs[1].sgs09,
                s_sgs[1].sgs10,s_sgs[1].sgs11,s_sgs[1].sgs12,s_sgs[1].sgs13,s_sgs[1].sgs14,s_sgs[1].sgs15,
#               s_sgs[1].sgs16,s_sgs[1].sgs17,s_sgs[1].sgs18,s_sgs[1].sgs19,s_sgs[1].sgs20,s_sgs[1].sgs21,  #FUN-A50100
                s_sgs[1].sgs16,s_sgs[1].sgs17,s_sgs[1].sgs18,s_sgs[1].sgs19,               s_sgs[1].sgs21,  #FUN-A50100
                s_sgs[1].sgs22,           #TQC-B80125
                s_sgs[1].sgs051b,         #TQC-B80125 add
                s_sgs[1].sgs052b,         #FUN-A50100
#               s_sgs[1].sgs22,           #TQC-B80125
                s_sgs[1].sgs014b,         #TQC-B80125
                s_sgs[1].sgs053b,         #FUN-A50100
                s_sgs[1].sgsslk01,s_sgs[1].sgsslk02,s_sgs[1].sgsslk03,s_sgs[1].sgsslk04,
                s_sgs[1].sgs23,s_sgs[1].sgs24,s_sgs[1].sgs25,s_sgs[1].sgs26,s_sgs[1].sgs27,s_sgs[1].sgs28,
                s_sgs[1].sgs29,s_sgs[1].sgs30,s_sgs[1].sgs31,s_sgs[1].sgs32,s_sgs[1].sgs33,s_sgs[1].sgs34,
#               s_sgs[1].sgs35,s_sgs[1].sgs36,s_sgs[1].sgs37,s_sgs[1].sgs38,s_sgs[1].sgs39             #FUN-A50100
#               s_sgs[1].sgs35,s_sgs[1].sgs36,               s_sgs[1].sgs38,s_sgs[1].sgs052a,s_sgs[1].sgs39,s_sgs[1].sgs053a  #FUN-A50100         #TQC-B80125  mark
                s_sgs[1].sgs35,s_sgs[1].sgs36,s_sgs[1].sgs38,s_sgs[1].sgs39,s_sgs[1].sgs051a,s_sgs[1].sgs052a,s_sgs[1].sgs014a,s_sgs[1].sgs053a   #TQC-B80125
                ,s_sgs[1].sgsslk05,s_sgs[1].sgsslk06,s_sgs[1].sgsslk07,s_sgs[1].sgsslk08
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp                        #
           CASE
              WHEN INFIELD(sgs25)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_eci"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgs25
                   NEXT FIELD sgs25
              WHEN INFIELD(sgs24)
                   CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgs24
                   NEXT FIELD sgs24
              WHEN INFIELD(sgs23)
                   CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgs23
                   NEXT FIELD sgs23
              WHEN INFIELD(sgs35)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgg"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgs35
                   NEXT FIELD sgs35
              WHEN INFIELD(sgs36)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgg"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgs36
                   NEXT FIELD sgs36
#FUN-A50100 --begin--
#              WHEN INFIELD(sgs37)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c"
#                   LET g_qryparam.form = "q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO sgs37
#                   NEXT FIELD sgs37
#FUN-A50100 --end--                   
              WHEN INFIELD(sgs38)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgs38
                   NEXT FIELD sgs38
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF   #FUN-A50100
    
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sgruser', 'sgrgrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT sgr01,sgr02,sgr03,sgr012 FROM sgr_file ",  #No.TQC-9A0118 mod  #FUN-A50100 add sgr012
                " WHERE ",g_wc CLIPPED, " ORDER BY sgr01,sgr02,sgr03,sgr012"  #FUN-A50100 add sgr012
   ELSE
      LET g_sql="SELECT sgr01,sgr02,sgr03,sgr012",  #No.TQC-9A0118 mod   #FUN-A50100 add sgr012
                "  FROM sgr_file,sgs_file ",
                " WHERE sgr01=sgs01 AND sgr02=sgs02 AND sgr03=sgs03",
                "   AND sgr012 = sgs012",                             #FUN-A50100 add
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY sgr01,sgr02,sgr03,sgr012"                  #FUN-A50100 add sgr012
   END IF
   PREPARE i120_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE i120_cs SCROLL CURSOR WITH HOLD FOR i120_prepare
 
   IF g_wc2=' 1=1' THEN
       LET g_sql_tmp= "SELECT UNIQUE sgr01,sgr02,sgr03,sgr012 FROM sgr_file WHERE ",g_wc CLIPPED,  #FUN-A50100 add sgr012
                      " INTO TEMP x"
    ELSE
       LET g_sql_tmp= "SELECT UNIQUE sgr01,sgr02,sgr03,sgr012 FROM sgr_file,sgs_file",  #FUN-A50100 add sgr012
                  " WHERE sgr01=sgs01 AND sgr02=sgs02",
                 "   AND sgr03=sgs03 ",
                 "   AND sgr012 = sgs012",     #FUN-A50100 
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "   INTO TEMP x"
    END IF
    DROP TABLE x
    PREPARE i120_precount_x FROM g_sql_tmp
    EXECUTE i120_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i120_precount FROM g_sql
    DECLARE i120_count CURSOR FOR i120_precount
 
END FUNCTION
 
FUNCTION i120_menu()
 
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i120_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i120_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i120_copy() ROLLBACK WORK
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = ""
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgs),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_sgr.sgr01 IS NOT NULL THEN
                LET g_doc.column1 = "sgr01"
                LET g_doc.column2 = "sgr02"
                LET g_doc.column3 = "sgr03"
                LET g_doc.column4 = "sgr012"  #FUN-A50100
                LET g_doc.value1 = g_sgr.sgr01
                LET g_doc.value2 = g_sgr.sgr02
                LET g_doc.value3 = g_sgr.sgr03
                LET g_doc.value4 = g_sgr.sgr012   #FUN-A50100 
                CALL cl_doc()
             END IF 
          END IF
                                                                                             
        WHEN "confirm"                                                                                                           
           IF cl_chk_act_auth() THEN                                                                                                
              CALL i120_confirm()
           END IF                                                                                                                   
                                                                                                                                    
        WHEN "notconfirm"                                                                                                        
           IF cl_chk_act_auth() THEN                                                                                                
              CALL i120_notconfirm()
           END IF 
        
        WHEN "release"       
            IF cl_chk_act_auth() THEN
               CALL i120_g()
            END IF   
 
      END CASE
   END WHILE
   CLOSE i120_cs
END FUNCTION
 
FUNCTION i120_a()
DEFINE l_ecu11         LIKE ecu_file.ecu11    #FUN-A50100 
DEFINE l_n             LIKE type_file.num5    #FUN-A50100 

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_sgs.clear()
    INITIALIZE g_sgr.* LIKE sgr_file.*
    LET g_sgr01_t = NULL
    LET g_sgr012_t = NULL        #FUN-A50100 
    LET g_sgr.sgr08 = 'N'
    LET g_sgr.sgr06 = g_today
    LET g_sgr.sgr09 = 'N'
    LET g_sgr.sgracti = 'Y'
    LET g_sgr.sgruser = g_user
    LET g_sgr.sgrgrup = g_grup
    LET g_sgr.sgrdate = TODAY
    LET g_sgr.sgroriu = g_user #TQC-B30038
    LET g_sgr.sgrorig = g_grup #TQC-B30038
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i120_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_sgs.clear()
            EXIT WHILE
        END IF
        
        IF g_sma.sma541 = 'Y' THEN   #FUN-A50100 
           IF cl_null(g_sgr.sgr01) OR cl_null(g_sgr.sgr02) OR cl_null(g_sgr.sgr03) THEN  
             CONTINUE WHILE 
           END IF   
#FUN-A50100 --begin--           
        ELSE        	   
           IF cl_null(g_sgr.sgr01) OR cl_null(g_sgr.sgr02) THEN  
              CONTINUE WHILE
           END IF 
        END IF
#FUN-A50100 --end--        
        
        LET g_sgr.sgroriu = g_user      #No.FUN-980030 10/01/04
        LET g_sgr.sgrorig = g_grup      #No.FUN-980030 10/01/04

#FUN-A50100  --begin--      
   IF g_sma.sma541 = 'N' THEN 
        IF cl_null(g_sgr.sgr012) THEN LET g_sgr.sgr012 = ' ' END IF   
        IF cl_null(g_sgr.sgr03) THEN 
           SELECT count(*) INTO l_n
             FROM sgr_file
            WHERE sgr01  = g_sgr.sgr01
              AND sgr02  = g_sgr.sgr02
              AND sgr012 = g_sgr.sgr012
              AND sgr09 = 'N'
           IF l_n > 0 THEN
               CALL cl_err('','aec-039',0)
               CONTINUE WHILE
           ELSE
              CALL i120_sgr012('a')      
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,0)
                 CONTINUE WHILE
              ELSE              	      	
                 SELECT ecu11 INTO l_ecu11
                   FROM ecu_file
                  WHERE ecu01  = g_sgr.sgr01
                    AND ecu02  = g_sgr.sgr02
                    AND ecu012 = g_sgr.sgr012
                    AND ecuacti = 'Y'  #CHI-C90006
                  IF l_ecu11 IS NULL THEN
                     LET l_ecu11 = 0 
                  END IF
                  LET g_sgr.sgr03 = l_ecu11 + 1
                  DISPLAY BY NAME g_sgr.sgr03                              
               END IF 
           END IF     
        END IF 
    END IF     
#FUN-A50100 --end--                
        INSERT INTO sgr_file VALUES(g_sgr.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","sgr_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1) 
           CONTINUE WHILE
        ELSE
           LET g_sgr_t.* = g_sgr.*               # 保存上筆資料
        END IF
 
        CALL g_sgs.clear()
        LET g_rec_b = 0
 
        CALL i120_b()
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i120_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入 #No.FUN-680073 VARCHAR(1) 
        l_ecu11         LIKE ecu_file.ecu11,
        l_azf09         LIKE azf_file.azf09,        #FUN-920186
        l_n             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_n1            LIKE type_file.num5
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    DISPLAY BY NAME g_sgr.sgr08,g_sgr.sgr06,g_sgr.sgr09,g_sgr.sgruser,  
                    g_sgr.sgrmodu,g_sgr.sgrgrup,g_sgr.sgrdate,g_sgr.sgracti,
                    g_sgr.sgroriu,g_sgr.sgrorig  #TQC-B30038
    INPUT BY NAME
        g_sgr.sgr01, g_sgr.sgr02, g_sgr.sgr06,g_sgr.sgr012,g_sgr.sgr04,g_sgr.sgr05,  #FUN-A50100 add sgr012
        g_sgr.sgruser,g_sgr.sgrgrup,g_sgr.sgrmodu,g_sgr.sgrdate,g_sgr.sgracti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i120_set_entry(p_cmd)
            CALL i120_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD sgr01
            IF NOT cl_null(g_sgr.sgr01) THEN
               SELECT count(*) INTO l_n
                 FROM ecu_file
                WHERE ecu01 = g_sgr.sgr01
                  AND ecuacti = 'Y'
                  AND ecu10 = 'Y'
                IF l_n = 0 THEN
                   CALL cl_err('','asfi115',0)
                   NEXT FIELD sgr01
                END IF
            ELSE
               NEXT FIELD sgr01
            END IF

#FUN-A50100 --begin--
       AFTER FIELD sgr012 
         IF g_sgr.sgr012 IS NULL THEN 
            NEXT FIELD CURRENT 
         END IF 
         IF (g_sgr.sgr01 != g_sgr01_t) OR (g_sgr01_t IS NULL) OR 
            (g_sgr.sgr02 != g_sgr_t.sgr02) OR (g_sgr_t.sgr02 IS NULL) THEN              
         	  CALL i120_sgr012(p_cmd)   
         	  IF NOT cl_null(g_errno) THEN 
         	     CALL cl_err('',g_errno,0)
         	     NEXT FIELD CURRENT 
         	  ELSE
               LET l_n1 = 0 
               SELECT count(*) INTO l_n1
                 FROM sgr_file
                WHERE sgr01  = g_sgr.sgr01
                  AND sgr02  = g_sgr.sgr02
                  AND sgr012 = g_sgr.sgr012
                  AND sgr09 = 'N'
               IF l_n1 > 0 THEN
                  CALL cl_err('','aec-039',0)
                  NEXT FIELD sgr012
               ELSE
                  SELECT ecu11 INTO l_ecu11
                    FROM ecu_file
                   WHERE ecu01  = g_sgr.sgr01
                     AND ecu02  = g_sgr.sgr02
                     AND ecu012 = g_sgr.sgr012
                     AND ecuacti = 'Y'  #CHI-C90006
                  IF l_ecu11 IS NULL THEN
                     LET l_ecu11 = 0
                  END IF
                  LET g_sgr.sgr03 = l_ecu11 + 1
                  DISPLAY BY NAME g_sgr.sgr03               	     
               END IF         	  	    
         	  END IF 
         END IF                              
#FUN-A50100 --end--
 
        AFTER FIELD sgr02
            IF NOT cl_null(g_sgr.sgr02) THEN
#               IF (g_sgr.sgr01 != g_sgr01_t) OR (g_sgr01_t IS NULL) THEN  #FUN-A50100 
                   SELECT count(*) INTO l_n1 FROM ecu_file
                    WHERE ecu01 = g_sgr.sgr01
                      AND ecu02 = g_sgr.sgr02
                      AND ecuacti = 'Y'
                      AND ecu10 = 'Y'
                   IF l_n1 = 0 THEN                             
                      CALL cl_err('','asfi115',0)
                      NEXT FIELD sgr02
                   END IF
#FUN-A50100 --begin--
#               END IF
#               LET l_n1 = 0 
#               SELECT count(*) INTO l_n1
#                 FROM sgr_file
#                WHERE sgr01 = g_sgr.sgr01
#                  AND sgr02 = g_sgr.sgr02
#                  AND sgr09 = 'N'
#               IF l_n1 > 0 THEN
#                  CALL cl_err('','aec-106',0)
#                  NEXT FIELD sgr02
#               END IF
#FUN-A50100 --end--
            ELSE
               NEXT FIELD sgr02
            END IF
#FUN-A50100 --begin--
#            SELECT ecu11 INTO l_ecu11
#              FROM ecu_file
#             WHERE ecu01 = g_sgr.sgr01
#               AND ecu02 = g_sgr.sgr02
#            IF l_ecu11 IS NULL THEN
#               LET l_ecu11 = 0
#            END IF
#            LET g_sgr.sgr03 = l_ecu11 + 1
#            DISPLAY BY NAME g_sgr.sgr03
#FUN-A50100 --end--
            
        AFTER FIELD sgr04
          IF NOT cl_null(g_sgr.sgr04) THEN
             LET l_n1 = 0 
             SELECT count(*) INTO l_n1
               FROM azf_file
              WHERE azf01 = g_sgr.sgr04
                AND azfacti = 'Y'
                AND azf02 = '2'
             IF l_n1 = 0 THEN
                CALL cl_err('','asfi115',0)
                NEXT FIELD sgr04
             END IF
             SELECT azf09 INTO l_azf09
               FROM azf_file
              WHERE azf01 = g_sgr.sgr04
                AND azfacti = 'Y'
                AND azf02 = '2'
             IF l_azf09 != 'A' THEN
                CALL cl_err('','aoo-409',0)
                NEXT FIELD sgr04
             END IF
             SELECT azf03 INTO g_sgr.sgr05
               FROM azf_file
              WHERE azf01 = g_sgr.sgr04
                AND azfacti = 'Y'
                AND azf02 = '2'
              DISPLAY BY NAME g_sgr.sgr05
          END IF
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_sgr.sgruser = s_get_data_owner("sgr_file") #FUN-C10039
           LET g_sgr.sgrgrup = s_get_data_group("sgr_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgr01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecu02"
                   LET g_qryparam.default1 = g_sgr.sgr01
                   CALL cl_create_qry() RETURNING g_sgr.sgr01
                   DISPLAY BY NAME g_sgr.sgr01       
                   NEXT FIELD sgr01
                   
#FUN-A50100 --begin--                   
              WHEN INFIELD(sgr012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgr012"
                   LET g_qryparam.arg1 = g_sgr.sgr01
                   LET g_qryparam.arg2 = g_sgr.sgr02                   
                   LET g_qryparam.default1 = g_sgr.sgr012
                   CALL cl_create_qry() RETURNING g_sgr.sgr012
                   DISPLAY BY NAME g_sgr.sgr012       
                   NEXT FIELD sgr012
#FUN-A50100 --end--
                                      
              WHEN INFIELD(sgr02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecu03"
                   LET g_qryparam.arg1 = g_sgr.sgr01
                   LET g_qryparam.default1 = g_sgr.sgr02
                   CALL cl_create_qry() RETURNING g_sgr.sgr02
                   DISPLAY BY NAME g_sgr.sgr02       
                   NEXT FIELD sgr02
              WHEN INFIELD(sgr04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf01a"   #FUN-920186
                   LET g_qryparam.arg1  = 'A'         #FUN-920186
                   LET g_qryparam.default1 = g_sgr.sgr04
                   CALL cl_create_qry() RETURNING g_sgr.sgr04
                   DISPLAY BY NAME g_sgr.sgr04       
                   NEXT FIELD sgr04
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    END INPUT
END FUNCTION

#FUN-A50100 --begin--
FUNCTION i120_sgr012(p_flag)
DEFINE p_flag       LIKE type_file.chr1 
DEFINE l_ecu012     LIKE ecu_file.ecu012
DEFINE l_ecu014     LIKE ecu_file.ecu014
DEFINE l_ecu10      LIKE ecu_file.ecu10
DEFINE l_ecuacti    LIKE ecu_file.ecuacti

  LET g_errno = ''
  LET l_ecu012 = NULL
  LET l_ecu014 = NULL 
  
  SELECT ecu012,ecu014,ecu10,ecuacti 
    INTO l_ecu012,l_ecu014,l_ecu10,l_ecuacti
    FROM ecu_file
   WHERE ecu01  = g_sgr.sgr01
     AND ecu02  = g_sgr.sgr02
     AND ecu012 = g_sgr.sgr012
  
  CASE 
    WHEN SQLCA.SQLCODE = 100   LET g_errno  = 'aec-048'
                               LET l_ecu012 = NULL
                               LET l_ecu014 = NULL 
    WHEN l_ecu10 != 'Y'          LET g_errno  = 'alm-007'
                               LET l_ecu012 = NULL
                               LET l_ecu014 = NULL
    WHEN l_ecuacti != 'Y'        LET g_errno  = 'alm-004'
                               LET l_ecu012 = NULL
                               LET l_ecu014 = NULL
    OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '------'                                                                                      
  END CASE 
   
    IF cl_null(g_errno) OR p_flag = 'd' THEN 
       DISPLAY l_ecu014 TO FORMONLY.ecu014 
    END IF     
END FUNCTION                           
#FUN-A50100 --end--
 
FUNCTION i120_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sgr01,sgr02,sgr012",TRUE)    #FUN-A50100 add sgr012
    END IF
 
END FUNCTION
 
FUNCTION i120_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sgr01,sgr02,sgr012",FALSE)      #FUN-A50100 add sgr012
    END IF
 
END FUNCTION
 
FUNCTION i120_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sgr.* TO NULL              #FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL g_sgs.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i120_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_sgs.clear()
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
    OPEN i120_count
    FETCH i120_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i120_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgr.sgr01,SQLCA.sqlcode,0)
        INITIALIZE g_sgr.* TO NULL
    ELSE
        CALL i120_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i120_copy()
   DEFINE  l_newno         LIKE sgr_file.sgr01,
           l_oldno         LIKE sgr_file.sgr01,  
           l_newsgr02      LIKE sgr_file.sgr02,
           l_oldsgr02      LIKE sgr_file.sgr02,
           l_oldsgr012     LIKE sgr_file.sgr012,   #FUN-A50100
           l_newsgr012     LIKE sgr_file.sgr012,   #FUN-A50100
           l_newsgr03      LIKE sgr_file.sgr03,
           l_oldsgr03      LIKE sgr_file.sgr03,
           l_ecu11         LIKE ecu_file.ecu11,
           l_n             LIKE type_file.num5,
           l_n1            LIKE type_file.num5,
           ef_date         LIKE type_file.dat,          #No.FUN-680073 DATE
           ans_1           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           ans_2,l_sdate   LIKE type_file.dat,          #No.FUN-680073 DATE
           l_cnt           LIKE ecu_file.ecu02,         #No.FUN-680073 DECIMAL(4,0)
           l_dir           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           l_sql           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(400)
 
   IF s_shut(0) THEN RETURN END IF
   IF g_sgr.sgr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i120_set_entry('a')
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno,l_newsgr02,l_newsgr012 FROM sgr01,sgr02,sgr012     #FUN-A50100 add sgr012
   
       AFTER FIELD sgr01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO l_n
                 FROM ecu_file
                WHERE ecu01 = l_newno
                  AND ecuacti = 'Y'
                  AND ecu10 = 'Y'
                IF l_n = 0 THEN
                   CALL cl_err('','asfi115',0)
                   NEXT FIELD sgr01
                END IF
            ELSE
               NEXT FIELD sgr01
            END IF

#FUN-A50100 --begin--
       AFTER FIELD sgr012 
         IF l_newsgr012 IS NULL THEN 
            NEXT FIELD CURRENT 
         END IF 
 
         LET g_sgr.sgr01 = l_newno
         LET g_sgr.sgr02 = l_newsgr02
         LET g_sgr.sgr012= l_newsgr012

      	  CALL i120_sgr012('a')   
         	  IF NOT cl_null(g_errno) THEN 
         	     CALL cl_err('',g_errno,0)
         	     NEXT FIELD CURRENT 
         	  ELSE
               LET l_n1 = 0 
               SELECT count(*) INTO l_n1
                 FROM sgr_file
                WHERE sgr01  = l_newno
                  AND sgr02  = l_newsgr02
                  AND sgr012 = l_newsgr012
                  AND sgr09 = 'N'
               IF l_n1 > 0 THEN
                  CALL cl_err('','aec-039',0)
                  NEXT FIELD sgr012
               ELSE
                  SELECT ecu11 INTO l_ecu11
                    FROM ecu_file
                   WHERE ecu01  = l_newno
                     AND ecu02  = l_newsgr02
                     AND ecu012 = l_newsgr012
                     AND ecuacti = 'Y'  #CHI-C90006
                  IF l_ecu11 IS NULL THEN
                     LET l_ecu11 = 0
                  END IF
                  LET l_newsgr03 = l_ecu11 + 1
                  DISPLAY l_newsgr03 TO sgr03               	     
               END IF         	  	    
         	  END IF   
   
    LET g_sgr.sgr01 = g_sgr_t.sgr01
    LET g_sgr.sgr02 = g_sgr_t.sgr02
    LET g_sgr.sgr012= g_sgr_t.sgr012        	                            
#FUN-A50100 --end--

        AFTER FIELD sgr02
            IF NOT cl_null(l_newsgr02) THEN
                   SELECT count(*) INTO l_n1 FROM ecu_file
                    WHERE ecu01 = l_newno
                      AND ecu02 = l_newsgr02
                      AND ecuacti = 'Y'
                      AND ecu10 = 'Y'
                   IF l_n1 = 0 THEN                             
                      CALL cl_err('','asfi115',0)
                      NEXT FIELD sgr02
                   END IF
#FUN-A50100 --begin--                   
#               LET l_n1 = 0 
#               SELECT count(*) INTO l_n1
#                 FROM sgr_file
#                WHERE sgr01 = l_newno
#                  AND sgr02 = l_newsgr02
#                  AND sgr09 = 'N'
#               IF l_n1 > 0 THEN
#                  CALL cl_err('','aec-106',0)
#                  NEXT FIELD sgr02
#               END IF
#FUN-A50100 --end--               
            ELSE
               NEXT FIELD sgr02
            END IF
#FUN-A50100 --begin--            
#            SELECT ecu11 INTO l_ecu11
#              FROM ecu_file
#             WHERE ecu01 = l_newno
#               AND ecu02 = l_newsgr02
#            IF cl_null(l_ecu11) THEN LET l_ecu11 = 0 END IF
#            LET l_newsgr03 = l_ecu11 + 1
#            DISPLAY l_newsgr03 TO  sgr03
#FUN-A50100 --end--
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sgr01) 
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecu02"
                   LET g_qryparam.default1 = l_newno
                   CALL cl_create_qry() RETURNING l_newno
                   DISPLAY l_newno TO sgr01       
                   NEXT FIELD sgr01
#FUN-A50100 --begin--                   
              WHEN INFIELD(sgr012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgr012"
                   LET g_qryparam.arg1 = l_newno
                   LET g_qryparam.arg2 = l_newsgr02                   
                   LET g_qryparam.default1 = l_newsgr012
                   CALL cl_create_qry() RETURNING l_newsgr012
                   DISPLAY l_newsgr012 TO sgr012       
                   NEXT FIELD sgr012
#FUN-A50100 --end--                   
              WHEN INFIELD(sgr02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecu03"
                   LET g_qryparam.arg1 = l_newno
                   LET g_qryparam.default1 = l_newsgr02
                   CALL cl_create_qry() RETURNING l_newsgr02
                   DISPLAY l_newsgr02 TO sgr02       
                   NEXT FIELD sgr02
              OTHERWISE EXIT CASE
           END CASE
 
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
      DISPLAY BY NAME g_sgr.sgr01
      DISPLAY BY NAME g_sgr.sgr02
      DISPLAY BY NAME g_sgr.sgr03
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM sgr_file         #單頭複製
       WHERE sgr01 =g_sgr.sgr01
         AND sgr02 =g_sgr.sgr02
         AND sgr012=g_sgr.sgr012  #FUN-A50100  
         AND sgr03=g_sgr.sgr03
       INTO TEMP y
 
   IF cl_null(l_newsgr012) THEN LET l_newsgr012 = ' ' END IF   #FUN-A50100
   UPDATE y
       SET sgr01=l_newno,    #新的鍵值
           sgr02=l_newsgr02,  #新的鍵值
           sgr012=l_newsgr012,            #FUN-A50100 
           sgr03=l_newsgr03,
           sgr08 = 'N',       #No.FUN-870124
           sgr09 = 'N',       #No.FUN-870124
           sgruser=g_user,   #資料所有者
           sgrgrup=g_grup,   #資料所有者所屬群
           sgrmodu=NULL,     #資料修改日期
           sgrdate=g_today,  #資料建立日期
           sgracti='Y'       #有效資料
 
   INSERT INTO sgr_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","sgr_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM sgs_file         #單身複製
       WHERE sgs01 =g_sgr.sgr01
         AND sgs02 =g_sgr.sgr02
         AND sgs012=g_sgr.sgr012        #FUN-A50100 
         AND sgs03=g_sgr.sgr03
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET sgs01=l_newno,
                sgs02=l_newsgr02,
                sgs012= l_newsgr012,    #FUN-A50100 
                sgs03=l_newsgr03
 
   INSERT INTO sgs_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","sgs_file","","",SQLCA.sqlcode,"","",1)    #FUN-B80046 ADD
      ROLLBACK WORK 
     # CALL cl_err3("ins","sgs_file","","",SQLCA.sqlcode,"","",1)   #FUN-B80046 MARK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_sgr.sgr01
   LET l_oldsgr02 = g_sgr.sgr02
   LET l_oldsgr012=g_sgr.sgr012        #FUN-A50100
   LET l_oldsgr03 =g_sgr.sgr03         #FUN-A50100
   SELECT sgr_file.* INTO g_sgr.* FROM sgr_file 
    WHERE sgr01 = l_newno AND sgr02=l_newsgr02 AND sgr03 = l_newsgr03   #No.TQC-9A0118 mod
      AND sgr012 = l_newsgr012      #FUN-A50100  
   CALL i120_u()
   CALL i120_b()
   #FUN-C30027---begin
   #SELECT sgr_file.* INTO g_sgr.* FROM sgr_file 
   # WHERE sgr01 = l_oldno AND sgr02=l_oldsgr02 AND sgr03 = l_oldsgr03   #No.TQC-9A0118 mod
   #   AND sgr012=l_oldsgr012   #FUN-A50100
   #CALL i120_show()
   #FUN-C30027---end
END FUNCTION 
 
FUNCTION i120_fetch(p_flecu)
    DEFINE
        p_flecu         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    CASE p_flecu
        WHEN 'N' FETCH NEXT     i120_cs INTO g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012   #No.TQC-9A0118 mod   #FUN-A50100 add sgr012
        WHEN 'P' FETCH PREVIOUS i120_cs INTO g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012  #No.TQC-9A0118 mod    #FUN-A50100 add sgr012
        WHEN 'F' FETCH FIRST    i120_cs INTO g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012  #No.TQC-9A0118 mod    #FUN-A50100 add sgr012
        WHEN 'L' FETCH LAST     i120_cs INTO g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012  #No.TQC-9A0118 mod    #FUN-A50100 add sgr012
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i120_cs INTO g_sgr.sgr01,    #No.TQC-9A0118 mod
                                                g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012    #FUN-A50100 add sgr012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgr.sgr01,SQLCA.sqlcode,0)
        INITIALIZE g_sgr.* TO NULL  
        RETURN
    ELSE
       CASE p_flecu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sgr.* FROM sgr_file       # 重讀DB,因TEMP有不被更新特性
     WHERE sgr01 = g_sgr.sgr01 AND sgr02 = g_sgr.sgr02 AND sgr03 = g_sgr.sgr03 #No.TQC-9A0118 mod
       AND sgr012 = g_sgr.sgr012  #FUN-A50100          
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","sgr_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1) 
    ELSE
        LET g_data_owner = g_sgr.sgruser      #FUN-4C0034
        LET g_data_group = g_sgr.sgrgrup      #FUN-4C0034
        CALL i120_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i120_show()
    LET g_sgr_t.* = g_sgr.*
    DISPLAY BY NAME
        g_sgr.sgr01, g_sgr.sgr02, g_sgr.sgr03, g_sgr.sgr08, g_sgr.sgr06,g_sgr.sgr012, g_sgr.sgr07,  #FUN-A50100 add sgr012
        g_sgr.sgr09, g_sgr.sgr04, g_sgr.sgr05, g_sgr.sgruser,g_sgr.sgrgrup,
        g_sgr.sgrmodu,g_sgr.sgrdate,g_sgr.sgracti
 
    CALL i120_sgr012('d')                     #FUN-A50100 
    
    CALL i120_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i120_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sgr.sgr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_sgr.sgr08 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    IF g_sgr.sgracti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
 
    BEGIN WORK
 
    OPEN i120_cl USING g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012   #No.TQC-9A0118 mod  #FUN-A50100 add sgr012
    IF STATUS THEN
       CALL cl_err("OPEN i120_cl:", STATUS, 1)
       CLOSE i120_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i120_cl INTO g_sgr.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
        CLOSE i120_cl ROLLBACK WORK RETURN
    END IF
 
    LET g_sgr01_t = g_sgr.sgr01
    LET g_sgr02_t = g_sgr.sgr02
    LET g_sgr012_t = g_sgr.sgr012  #FUN-A50100 
    LET g_sgr03_t = g_sgr.sgr03
    LET g_sgr_o.*=g_sgr.*
    LET g_sgr.sgrmodu = g_user
    LET g_sgr.sgrdate = g_today               #修改日期
    CALL i120_show()                          # 顯示最新資料
 
    WHILE TRUE
        CALL i120_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sgr.*=g_sgr_t.*
            CALL i120_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sgr_file SET sgr_file.* = g_sgr.*    # 更新DB
         WHERE sgr01 = g_sgr01_t AND sgr02 = g_sgr02_t AND sgr03 = g_sgr03_t   #No.TQC-9A0118 mod             # COLAUTH?
           AND sgr012 = g_sgr012_t     #FUN-A50100   
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sgr_file",g_sgr01_t,g_sgr02_t,SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i120_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i120_r()
    DEFINE l_chr      LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           l_cnt      LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sgr.sgr01)  THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF                                                                                                          
    IF g_sgr.sgr08 = 'Y' THEN                                                                                                       
       CALL cl_err('','mfg1005',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
    BEGIN WORK
 
    OPEN i120_cl USING g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012   #No.TQC-9A0118 mod  #FUN-A50100 add sgr012
    IF STATUS THEN
       CALL cl_err("OPEN i120_cl:", STATUS, 1)
       CLOSE i120_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i120_cl INTO g_sgr.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock sgr:',SQLCA.sqlcode,0)
       CLOSE i120_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i120_show()
 
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sgr01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "sgr02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "sgr03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "sgr012"        #FUN-A50100
        LET g_doc.value1 = g_sgr.sgr01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_sgr.sgr02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_sgr.sgr03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_sgr.sgr012    #FUN-A50100 add sgr012
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM sgr_file WHERE sgr01 = g_sgr.sgr01 AND sgr02 = g_sgr.sgr02 AND sgr03 = g_sgr.sgr03  #No.TQC-9A0118 mod
                               AND sgr012 = g_sgr.sgr012            #FUN-A50100
        DELETE FROM x WHERE sgr01  = g_sgr.sgr01                    #FUN-A50100
                        AND sgr02  = g_sgr.sgr02                    #FUN-A50100
                        AND sgr03  = g_sgr.sgr03                    #FUN-A50100
                        AND sgr012 = g_sgr.sgr012                   #FUN-A50100
        IF STATUS THEN 
        CALL cl_err3("del","sgr_file",g_sgr.sgr01,g_sgr.sgr02,STATUS,"","del sgr:",1)     
        RETURN END IF
         
        DELETE FROM sgs_file WHERE sgs01 = g_sgr.sgr01 
                               AND sgs02 = g_sgr.sgr02 
                               AND sgs03 = g_sgr.sgr03
                               AND sgs012 = g_sgr.sgr012 #FUN-A50100 
        IF STATUS THEN 
        CALL cl_err3("del","sgs_file",g_sgr.sgr01,g_sgr.sgr02,STATUS,"","del sgs:",1)       
        RETURN END IF
 
        INITIALIZE g_sgr.* TO NULL
        CLEAR FORM
        CALL g_sgs.clear()
        OPEN i120_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i120_cs
           CLOSE i120_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i120_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i120_cs
           CLOSE i120_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i120_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i120_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i120_fetch('/')
        END IF
 
    END IF
    CLOSE i120_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i120_confirm()
DEFINE l_n    LIKE type_file.num5
DEFINE l_ecu10  LIKE ecu_file.ecu10   #No.FUN-870124
 
    IF cl_null(g_sgr.sgr01) OR cl_null(g_sgr.sgr02) OR cl_null(g_sgr.sgr03) 
      #OR cl_null(g_sgr.sgr012) #FUN-A50100  #TQC-B40011  
      #OR g_sgr.sgr012 IS NOT NULL #TQC-B40011 #TQC-B60264
     THEN      
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
#CHI-C30107 ------------ add ------------- begin
    IF g_sgr.sgr08="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sgr.sgracti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-222') THEN RETURN END IF
    SELECT * INTO g_sgr.* FROM sgr_file WHERE sgr01 = g_sgr.sgr01
                                          AND sgr02 = g_sgr.sgr02
                                          AND sgr03 = g_sgr.sgr03
                                          AND sgr012 = g_sgr.sgr012
#CHI-C30107 ------------ add -------------end
    #TQC-B60264 add--str--
    IF g_sma.sma541='Y' AND cl_null(g_sgr.sgr012) THEN
       CALL cl_err('','aec-317',1)
       RETURN
    END IF
    #TQC-B60264 add--end--

    IF g_sgr.sgr08="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN                                                                                     
    END IF
    IF g_sgr.sgracti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1) 
       RETURN                                                                                    
    END IF  
    SELECT ecu10 INTO l_ecu10
      FROM ecu_file
     WHERE ecu01 = g_sgr.sgr01
       AND ecu02 = g_sgr.sgr02
       AND ecu012 = g_sgr.sgr012   #FUN-A50100 
       AND ecuacti = 'Y'  #CHI-C90006
    IF l_ecu10 !='Y' THEN
       CALL cl_err('','aec-901',1)
       RETURN
    END IF
    SELECT count(*) INTO l_n
      FROM sgr_file
     WHERE sgr01 = g_sgr.sgr01
       AND sgr02 = g_sgr.sgr02
       AND sgr012 = g_sgr.sgr012  #FUN-A50100 
       AND sgr09 = 'N'
       AND sgr03 != g_sgr.sgr03
     IF l_n > 0 THEN
        CALL cl_err('','aec-107',0)
        RETURN
     END IF
     #FUN-B90141 --START--
     IF NOT i120_chk_umf() THEN
        RETURN 
     END IF
     #FUN-B90141 --END-- 
#   IF cl_confirm('aap-222') THEN  #CHI-C30107 mark                                                                                             
       BEGIN WORK                                                                                                              
       UPDATE sgr_file                                                                                                         
          SET sgr08="Y"                                                                                                       
        WHERE sgr01=g_sgr.sgr01
          AND sgr02=g_sgr.sgr02
          AND sgr03=g_sgr.sgr03
          AND sgr012 = g_sgr.sgr012 #FUN-A50100 
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err3("upd","sgr_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","sgr08",1)                                            
            ROLLBACK WORK                                                                                                           
        ELSE                                                                                                                        
            COMMIT WORK                                                                                                             
            LET g_sgr.sgr08="Y"                                                                                                 
            DISPLAY BY NAME g_sgr.sgr08
        END IF
#   END IF  #CHI-C30107 mark
END FUNCTION
 
FUNCTION i120_notconfirm()
    IF cl_null(g_sgr.sgr01) OR cl_null(g_sgr.sgr02) OR cl_null(g_sgr.sgr03) 
      #OR cl_null(g_sgr.sgr012) #FUN-A50100   #TQC-B60264
      THEN                                                                                                       
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF

    #TQC-B60264 add--str--
    IF g_sma.sma541='Y' AND cl_null(g_sgr.sgr012) THEN
       CALL cl_err('','aec-318',1)
       RETURN
    END IF
    #TQC-B60264 add--end--

    IF g_sgr.sgr08="N" OR g_sgr.sgracti="N" THEN                                                                                  
        CALL cl_err("",'atm-365',1) 
        RETURN                                                                                                
    END IF
    IF g_sgr.sgr09='Y' THEN
       CALL cl_err('','aec-108',0)
       RETURN
    END IF
    IF cl_confirm('aap-224') THEN                                                                                                
       BEGIN WORK                                                                                                                 
       UPDATE sgr_file                                                                                                            
           SET sgr08="N"                                                                                                        
         WHERE sgr01=g_sgr.sgr01
           AND sgr02=g_sgr.sgr02
           AND sgr03=g_sgr.sgr03
           AND sgr012=g_sgr.sgr012   #FUN-A50100 
        IF SQLCA.sqlcode THEN                                                                                                         
          CALL cl_err3("upd","sgr_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","sgr08",1)                                               
          ROLLBACK WORK
        ELSE                                                                                                                          
          COMMIT WORK                                                                                                                
          LET g_sgr.sgr08="N"                                                                                                    
          DISPLAY BY NAME g_sgr.sgr08
        END IF
    END IF
END FUNCTION
 
FUNCTION i120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY #No.FUN-680073 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重復用    #No.FUN-680073 SMALLINT
    l_n1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否    #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態      #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否      #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否      #No.FUN-680073 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sgr.sgr01) THEN RETURN END IF
    IF cl_null(g_sgr.sgr02) THEN RETURN END IF
    IF g_sgr.sgr012 IS NULL THEN RETURN END IF  #FUN-A50100 
    IF cl_null(g_sgr.sgr03) THEN RETURN END IF
    IF g_sgr.sgr08='Y' THEN RETURN END IF   
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT sgs05,sgs04,sgs06,sgs07,sgs08,sgs09,sgs10,sgs11,sgs12,sgs13,",
#       "       sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs20,sgs21,sgs22,sgsslk01,",     #FUN-A50100
#       "       sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,      sgs21,sgs052b,sgs22,sgs053b,sgsslk01,",     #FUN-A50100  #TQC-B80125  mark 
        "       sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs21,sgs22,sgs051b,sgs052b,sgs014b,sgs053b,sgsslk01,",        #TQC-B80125  add sgs051b,sgs014b 
        "       sgsslk02,sgsslk03,sgsslk04,sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,", 
#       "       sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38,",        #FUN-A50100
        "       sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,      sgs38,sgs39,sgs051a,sgs052a,",        #FUN-A50100   #TQC-B80125 add sgs39,sgs051a
#       "       sgs39,sgs053a,sgsslk05,sgsslk06,sgsslk07,sgsslk08",                           #FUN-A50100 add sgs053a     #TQC-B80125 mark
        "       sgs014a,sgs053a,sgsslk05,sgsslk06,sgsslk07,sgsslk08",                         #TQC-B80125 add sgs014a
        " FROM sgs_file ",
        "WHERE sgs01= ? AND sgs02= ? AND sgs03= ? AND sgs05= ? and sgs012 = ? FOR UPDATE "  #FUN-A50100 add sgs012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_sgs WITHOUT DEFAULTS FROM s_sgs.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i120_cl USING g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012  #No.TQC-9A0118 mod  #FUN-A50100 add sgr012
            IF STATUS THEN
               CALL cl_err("OPEN i120_cl_b:", STATUS, 1)
               CLOSE i120_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i120_cl INTO g_sgr.*               # 對DB鎖定
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock sgr:',SQLCA.sqlcode,0)
                  CLOSE i120_cl ROLLBACK WORK RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
 
                LET p_cmd='u'
                LET g_sgs_t.* = g_sgs[l_ac].*  #BACKUP
 
                OPEN i120_bcl USING g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgs_t.sgs05,g_sgr.sgr012  #FUN-A50100 add sgr012
                IF STATUS THEN
                   CALL cl_err("OPEN i120_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i120_bcl INTO g_sgs[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sgs_t.sgs05,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
                NEXT FIELD sgs05
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sgs[l_ac].* TO NULL      
            LET g_sgs_t.* = g_sgs[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD sgs05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO sgs_file(sgs01,sgs02,sgs03,sgs05,sgs04,sgs06,sgs07,sgs08,sgs09,sgs10,sgs11,sgs12,
#                                sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs20,sgs21,sgs22,sgsslk01, #FUN-A50100
#                                sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,      sgs21,sgs052b,sgs22,sgs053b,sgsslk01, #FUN-A50100  #TQC-B80125  mark
                                 sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs21,sgs22,sgs051b,sgs052b,sgs014b,sgs053b,sgsslk01,    #TQC-B80125
                                 sgsslk02,sgsslk03,sgsslk04,sgs23,sgs24,sgs25,sgs26,sgs27,
#                                sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,sgs37, #FUN-A50100
                                 sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,       #FUN-A50100
#                                sgs38,sgs052a,sgs39,sgs053a,sgsslk05,sgsslk06,sgsslk07,sgsslk08,sgs012)  #FUN-A50100 add sgs012,sgs052a,sgs053a    #TQC-B80125  mark  
                                 sgs38,sgs39,sgs051a,sgs052a,sgs014a,sgs053a,sgsslk05,sgsslk06,sgsslk07,sgsslk08,sgs012)     #TQC-B80125 
                          VALUES(g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgs[l_ac].sgs05,g_sgs[l_ac].sgs04,
                                 g_sgs[l_ac].sgs06,g_sgs[l_ac].sgs07,g_sgs[l_ac].sgs08,g_sgs[l_ac].sgs09,
                                 g_sgs[l_ac].sgs10,g_sgs[l_ac].sgs11,g_sgs[l_ac].sgs12,g_sgs[l_ac].sgs13,
                                 g_sgs[l_ac].sgs14,g_sgs[l_ac].sgs15,g_sgs[l_ac].sgs16,g_sgs[l_ac].sgs17,
#                                g_sgs[l_ac].sgs18,g_sgs[l_ac].sgs19,g_sgs[l_ac].sgs20,g_sgs[l_ac].sgs21,  #FUN-A50100
                                 g_sgs[l_ac].sgs18,g_sgs[l_ac].sgs19,                  g_sgs[l_ac].sgs21,  #FUN-A50100
                                 g_sgs[l_ac].sgs22,             #TQC-B80125
                                 g_sgs[l_ac].sgs051b,           #TQC-B80125 add sgs051b
                                 g_sgs[l_ac].sgs052b,           #FUN-A50100
                                 g_sgs[l_ac].sgs014b,           #TQC-B80125 add sgs014b 
#                                g_sgs[l_ac].sgs22,g_sgs[l_ac].sgs053b,g_sgs[l_ac].sgsslk01,g_sgs[l_ac].sgsslk02,g_sgs[l_ac].sgsslk03,  #FUN-A50100 add sgs053b
                                 g_sgs[l_ac].sgs053b,g_sgs[l_ac].sgsslk01,g_sgs[l_ac].sgsslk02,g_sgs[l_ac].sgsslk03,                    #TQC-B80125 mark sgs22          
                                 g_sgs[l_ac].sgsslk04,g_sgs[l_ac].sgs23,g_sgs[l_ac].sgs24,g_sgs[l_ac].sgs25,
                                 g_sgs[l_ac].sgs26,g_sgs[l_ac].sgs27,g_sgs[l_ac].sgs28,g_sgs[l_ac].sgs29,
                                 g_sgs[l_ac].sgs30,g_sgs[l_ac].sgs31,g_sgs[l_ac].sgs32,g_sgs[l_ac].sgs33,
#                                g_sgs[l_ac].sgs34,g_sgs[l_ac].sgs35,g_sgs[l_ac].sgs36,g_sgs[l_ac].sgs37, #FUN-A50100 
                                 g_sgs[l_ac].sgs34,g_sgs[l_ac].sgs35,g_sgs[l_ac].sgs36,                   #FUN-A50100 
#                                g_sgs[l_ac].sgs38,g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs39,g_sgs[l_ac].sgs053a,g_sgs[l_ac].sgsslk05,g_sgs[l_ac].sgsslk06, #FUN-A50100 add sgs052a,sgs053a           #TQC-B80125 mark
                                 g_sgs[l_ac].sgs38,g_sgs[l_ac].sgs39,g_sgs[l_ac].sgs051a,g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs014a,g_sgs[l_ac].sgs053a,g_sgs[l_ac].sgsslk05,g_sgs[l_ac].sgsslk06,   #TQC-B80125 add sgs051a,sgs014a
                                 g_sgs[l_ac].sgsslk07,g_sgs[l_ac].sgsslk08,g_sgr.sgr012) #FUN-A50100 add sgr012
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sgs_file",g_sgr.sgr01,g_sgr.sgr02,STATUS,"","ins sgs:",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
          AFTER FIELD sgs05
#FUN-A50100  --begin--
#&ifdef SLK
#            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,
#                                   sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38   
#                                    ,sgsslk05,sgsslk06,sgsslk07,sgsslk08",TRUE)
#&else
#            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,
#                                    sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38",TRUE)  
#&endif
            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,                                   sgs32,sgs33,sgs34,sgs35,sgs36,sgs38                                       ,sgsslk05,sgsslk06,sgsslk07,sgsslk08,sgs052a,sgs39,sgs051a,sgs014a,sgs053a",TRUE)  #FUN-A60092 add sgs052a,sgs39,sgs053a   #TQC-B80125 add sgs051a,sgs014a
#FUN-A50100 --end--
            IF NOT cl_null(g_sgs[l_ac].sgs05) THEN
                  CALL cl_set_comp_entry("sgs04",TRUE)
                  SELECT count(*) INTO l_n FROM ecb_file
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012       #FUN-A50100 
                  IF l_n = 0 THEN
                     LET g_sgs[l_ac].sgs04 = '1'
                     CALL cl_set_comp_entry("sgs04",FALSE)
                     LET g_sgs[l_ac].sgs06 = " "
                     LET g_sgs[l_ac].sgs07 = " "
                     LET g_sgs[l_ac].sgs08 = " "
                     LET g_sgs[l_ac].sgs09 = " "
                     LET g_sgs[l_ac].sgs10 = " "
                     LET g_sgs[l_ac].sgs11 = " "
                     LET g_sgs[l_ac].sgs12 = " "
                     LET g_sgs[l_ac].sgs13 = " "
                     LET g_sgs[l_ac].sgs14 = " "
                     LET g_sgs[l_ac].sgs15 = " "
                     LET g_sgs[l_ac].sgs16 = " "
                     LET g_sgs[l_ac].sgs17 = " "
                     LET g_sgs[l_ac].sgs18 = " "
                     LET g_sgs[l_ac].sgs19 = " "
#                    LET g_sgs[l_ac].sgs20 = " "   #FUN-A50100
                     LET g_sgs[l_ac].sgs21 = " "
                     LET g_sgs[l_ac].sgs052b= " "  #FUN-A50100
                     LET g_sgs[l_ac].sgs053b= " "  #FUN-A50100
                     LET g_sgs[l_ac].sgs22 = " "
                     LET g_sgs[l_ac].sgs051b = " " #TQC-B80125
                     LET g_sgs[l_ac].sgs014b = " " #TQC-B80125 
                     LET g_sgs[l_ac].sgsslk01 = " "
                     LET g_sgs[l_ac].sgsslk02 = " "
                     LET g_sgs[l_ac].sgsslk03 = " "
                     LET g_sgs[l_ac].sgsslk04 = " "
                     IF g_sgs_t.sgs05 IS NULL THEN
                     LET g_sgs[l_ac].sgsslk06 = 0   #No.FUN-870124
                     END IF
                     IF g_sgs_t.sgs05 IS NULL THEN
                     LET g_sgs[l_ac].sgs32 = 'N'
                     LET g_sgs[l_ac].sgs33 = 'N'
                     LET g_sgs[l_ac].sgs34 = 'N'
                     LET g_sgs[l_ac].sgs28 = 0
                     LET g_sgs[l_ac].sgs29 = 0
                     LET g_sgs[l_ac].sgs30 = 0
                     LET g_sgs[l_ac].sgs31 = 0
                     LET g_sgs[l_ac].sgs052a=0   #FUN-A50100
                     LET g_sgs[l_ac].sgs053a=1   #FUN-A50100                     
                     END IF
                     CALL i120_set_sgs04a()    #MOD-B60044 add
                  END IF
                  IF l_n >0 THEN
                     SELECT count(*) INTO l_n1
                       FROM sgv_file
                      WHERE sgv01 = g_sgr.sgr01
                        AND sgv02 = g_sgr.sgr02
                        AND sgv012= g_sgr.sgr012  #FUN-A50100 
                        AND sgv03 = g_sgs[l_ac].sgs05
                        AND sgv10 = 'N'
                     IF l_n1 > 0 THEN
                        CALL cl_err('','aec-105',0)
                        NEXT FIELD sgs05
                     ELSE
                        SELECT ecb06,ecb08,ecb07,ecb38,ecb04,ecb19,ecb18,ecb21,
#                              ecb20,ecb39,ecb40,ecb41,ecb42,ecb43,ecb44,ecb45,  #FUN-A50100 
                               ecb20,ecb39,ecb40,ecb41,ecb42,ecb43,      ecb45,  #FUN-A50100 
                               ecb46, #FUN-A50100    #TQC-B80125 remark 
                               ecb14  #FUN-A50100 
                              ,ecb51  #TQC-B80125   add ecb51
                               ,ecbslk01,ecbslk02,ecbslk04,ecbslk05
                               ,ecb52,ecb53                            #FUN-A50100                               
                          INTO g_sgs[l_ac].sgs06,g_sgs[l_ac].sgs07,g_sgs[l_ac].sgs08,
                               g_sgs[l_ac].sgs09,g_sgs[l_ac].sgs10,g_sgs[l_ac].sgs11,
                               g_sgs[l_ac].sgs12,g_sgs[l_ac].sgs13,g_sgs[l_ac].sgs14,
                               g_sgs[l_ac].sgs15,g_sgs[l_ac].sgs16,g_sgs[l_ac].sgs17,
#                              g_sgs[l_ac].sgs18,g_sgs[l_ac].sgs19,g_sgs[l_ac].sgs20,  #FUN-A50100 
                               g_sgs[l_ac].sgs18,g_sgs[l_ac].sgs19,                    #FUN-A50100 
                               g_sgs[l_ac].sgs21,g_sgs[l_ac].sgs22,
                               g_sgs[l_ac].sgs014b,g_sgs[l_ac].sgs051b  #TQC-B80125
                               ,g_sgs[l_ac].sgsslk01,g_sgs[l_ac].sgsslk02,
                                g_sgs[l_ac].sgsslk03,g_sgs[l_ac].sgsslk04                         
                               ,g_sgs[l_ac].sgs052b,g_sgs[l_ac].sgs053b          #FUN-A50100     
                          FROM ecb_file
                         WHERE ecb01 = g_sgr.sgr01
                           AND ecb02 = g_sgr.sgr02
                           AND ecb012= g_sgr.sgr012          #FUN-A50100 
                           AND ecb03 = g_sgs[l_ac].sgs05
                        DISPLAY BY NAME g_sgs[l_ac].sgs06
                        DISPLAY BY NAME g_sgs[l_ac].sgs07
                        DISPLAY BY NAME g_sgs[l_ac].sgs08
                        DISPLAY BY NAME g_sgs[l_ac].sgs09
                        DISPLAY BY NAME g_sgs[l_ac].sgs10
                        DISPLAY BY NAME g_sgs[l_ac].sgs11
                        DISPLAY BY NAME g_sgs[l_ac].sgs12
                        DISPLAY BY NAME g_sgs[l_ac].sgs13
                        DISPLAY BY NAME g_sgs[l_ac].sgs14
                        DISPLAY BY NAME g_sgs[l_ac].sgs15
                        DISPLAY BY NAME g_sgs[l_ac].sgs16
                        DISPLAY BY NAME g_sgs[l_ac].sgs17
                        DISPLAY BY NAME g_sgs[l_ac].sgs18
                        DISPLAY BY NAME g_sgs[l_ac].sgs19
#                       DISPLAY BY NAME g_sgs[l_ac].sgs20  #FUN-A50100 
                        DISPLAY BY NAME g_sgs[l_ac].sgs21
                        DISPLAY BY NAME g_sgs[l_ac].sgs22
                        DISPLAY BY NAME g_sgs[l_ac].sgs052b       #FUN-A50100
                        DISPLAY BY NAME g_sgs[l_ac].sgs053b       #FUN-A50100
                        DISPLAY BY NAME g_sgs[l_ac].sgs051b       #TQC-B80125
                        DISPLAY BY NAME g_sgs[l_ac].sgs014b       #TQC-B80125 
                        DISPLAY BY NAME g_sgs[l_ac].sgsslk01
                        DISPLAY BY NAME g_sgs[l_ac].sgsslk02
                        DISPLAY BY NAME g_sgs[l_ac].sgsslk03
                        DISPLAY BY NAME g_sgs[l_ac].sgsslk04
                        IF g_sgs_t.sgs05 IS NULL THEN
                        LET g_sgs[l_ac].sgsslk06 = NULL            #No.FUN-870124
                        END IF
                        IF g_sgs_t.sgs05 IS NULL THEN
                        LET g_sgs[l_ac].sgs32 = NULL
                        LET g_sgs[l_ac].sgs33 = NULL
                        LET g_sgs[l_ac].sgs34 = NULL
                        LET g_sgs[l_ac].sgs28 = NULL
                        LET g_sgs[l_ac].sgs29 = NULL
                        LET g_sgs[l_ac].sgs30 = NULL
                        LET g_sgs[l_ac].sgs31 = NULL
                        END IF
                        IF cl_null(g_sgs[l_ac].sgs04) OR g_sgs[l_ac].sgs04 = '1' THEN
                           LET g_sgs[l_ac].sgs04 = '3'
                        END IF
                     END IF
                  END IF
          END IF
        BEFORE FIELD sgs04
         CALL i120_set_sgs04()
 
 
        AFTER FIELD sgs04
         CALL i120_set_sgs04a()
         IF g_sgs[l_ac].sgs04 = '2' THEN
#FUN-A50100 --begin--         
#&ifdef SLK
#            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,
##                                   sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38  #FUN-A50100
#                                    sgs32,sgs33,sgs34,sgs35,sgs36,      sgs38  #FUN-A50100
#                                    ,sgsslk05,sgsslk06,sgsslk07,sgsslk08",FALSE)
#&else
#            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,
##                                   sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38",FALSE)  #FUN-A50100 
#                                    sgs32,sgs33,sgs34,sgs35,sgs36,      sgs38",FALSE)  #FUN-A50100 
#&endif
            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,                                    sgs32,sgs33,sgs34,sgs35,sgs36,sgs38                                      ,sgsslk05,sgsslk06,sgsslk07,sgsslk08,sgs052a,sgs39,sgs051a,sgs014a,sgs053a",FALSE)  #FUN-A60092 add sgs052a,sgs39,sgs053a    #TQC-B80125 add sgs051a,sgs014a
         END IF
#FUN-A50100 --end-- 
         
#FUN-A50100 --begin--           
         IF g_sgs[l_ac].sgs04 = '1' OR g_sgs[l_ac].sgs04 = '3' THEN
#&ifdef SLK
#            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,
##                                   sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38   #FUN-A50100 
#                                    sgs32,sgs33,sgs34,sgs35,sgs36,      sgs38   #FUN-A50100 
#                                    ,sgsslk05,sgsslk06,sgsslk07,sgsslk08",TRUE)
#&else
#            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,
##                                   sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,sgs38",TRUE)  #FUN-A50100
#                                    sgs32,sgs33,sgs34,sgs35,sgs36,      sgs38",TRUE)  #FUN-A50100
#&endif

            CALL cl_set_comp_entry("sgs23,sgs24,sgs25,sgs26,sgs27,sgs28,sgs29,sgs30,sgs31,                                    sgs32,sgs33,sgs34,sgs35,sgs36,      sgs38                                      ,sgsslk05,sgsslk06,sgsslk07,sgsslk08,sgs052a,sgs39,sgs051a,sgs014a,sgs053a",TRUE)  #FUN-A60092 add sgs052a,sgs39,sgs053a   #TQC-B80125 add sgs051a,sgs014a
         END IF
#FUN-A50100 --end--         
         IF g_sgs[l_ac].sgs04 != g_sgs_t.sgs04 OR g_sgs_t.sgs04 IS NULL THEN
            IF g_sgs[l_ac].sgs04 = '2' THEN
               LET g_sgs[l_ac].sgs23 = " "
               LET g_sgs[l_ac].sgs24 = " "
               LET g_sgs[l_ac].sgs25 = " "
               LET g_sgs[l_ac].sgs26 = " "
               LET g_sgs[l_ac].sgs27 = " "
               LET g_sgs[l_ac].sgs28 = NULL
               LET g_sgs[l_ac].sgs29 = NULL
               LET g_sgs[l_ac].sgs30 = NULL
               LET g_sgs[l_ac].sgs31 = NULL
               LET g_sgs[l_ac].sgs32 = " "
               LET g_sgs[l_ac].sgs33 = " "
               LET g_sgs[l_ac].sgs34 = " "
               LET g_sgs[l_ac].sgs35 = " "
               LET g_sgs[l_ac].sgs36 = " "
#              LET g_sgs[l_ac].sgs37 = " "   #FUN-A50100 
               LET g_sgs[l_ac].sgs38 = " "
               LET g_sgs[l_ac].sgs39 = " "
               LET g_sgs[l_ac].sgsslk05 = " "
               LET g_sgs[l_ac].sgsslk06 = NULL
               LET g_sgs[l_ac].sgsslk07 = " "
               LET g_sgs[l_ac].sgsslk08 = " "
            END IF
         END IF
         
#FUN-A50100 --begin--
        AFTER FIELD sgs052a
          IF NOT cl_null(g_sgs[l_ac].sgs052a) THEN 
             IF g_sgs[l_ac].sgs052a < 0 THEN 
                CALL cl_err('','aec-020',0)
                NEXT FIELD CURRENT 
             END IF 
         #FUN-910088--add--start--
          IF NOT cl_null(g_sgs[l_ac].sgs38) THEN
             LET g_sgs[l_ac].sgs052a = s_digqty(g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs38)
          ELSE 
             LET g_sgs[l_ac].sgs052a = s_digqty(g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs21)
          END IF
         #FUN-910088--add--end--
          ELSE
            IF g_sgs[l_ac].sgs04 <> 3 THEN  #MOD-D30118
               NEXT FIELD CURRENT 
            END IF  #MOD-D30118
          END IF 	
        
        AFTER FIELD sgs053a
          IF NOT cl_null(g_sgs[l_ac].sgs053a) THEN 
             IF g_sgs[l_ac].sgs053a <= 0 THEN 
                CALL cl_err('','alm-808',0)
                NEXT FIELD CURRENT 
             END IF 
          ELSE
             IF g_sgs[l_ac].sgs04 <> 3 THEN  #MOD-D30118
                NEXT FIELD CURRENT 
             END IF  #MOD-D30118  
          END IF 	        
#FUN-A50100 --end--
         
#TQC-B80125 --------------Begin---------------
       AFTER FIELD sgs39
         IF NOT cl_null(g_sgs[l_ac].sgs39) THEN
            IF g_sgs[l_ac].sgs39 <= 0 THEN
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT
            END IF
         END IF

       AFTER FIELD sgs051a
         IF NOT cl_null(g_sgs[l_ac].sgs051a) THEN
            IF g_sgs[l_ac].sgs051a <= 0 THEN
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT
            END IF
         END IF 

       AFTER FIELD sgs014a
         IF NOT cl_null(g_sgs[l_ac].sgs014a) THEN
            IF g_sgs[l_ac].sgs014a < 0 THEN
               CALL cl_err('','aim-223',0)
               NEXT FIELD CURRENT
            END IF
         END IF
#TQC-B80125 --------------End----------------
        AFTER FIELD sgs23
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs23 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs23
               END IF
            END IF
            IF NOT cl_null(g_sgs[l_ac].sgs23) THEN
               CALL i120_sgs23(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgs[l_ac].sgs23 = g_sgs_t.sgs23
                  DISPLAY BY NAME g_sgs[l_ac].sgs23
                  NEXT FIELD sgs23
               END IF
            END IF
 
        AFTER FIELD sgs24
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs24 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs24
               END IF
            END IF
 
        AFTER FIELD sgs25
            IF NOT cl_null(g_sgs[l_ac].sgs25) THEN
               SELECT eci01 INTO l_eci01 FROM eci_file
                WHERE eci01 =  g_sgs[l_ac].sgs25
               IF STATUS THEN
                  CALL cl_err3("sel","eci_file",g_sgs[l_ac].sgs25,"","aec-011","","",1) #FUN-660091
                  NEXT FIELD sgs25
               END IF
            END IF
 
        AFTER FIELD sgs27
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs27 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs27
               END IF
            END IF
            IF NOT cl_null(g_sgs[l_ac].sgs27) THEN
               IF g_sgs[l_ac].sgs27 < 0 THEN
                  CALL cl_err(g_sgs[l_ac].sgs27,'aec-991',0)     
                  NEXT FIELD sgs27
               END IF
            END IF
 
        AFTER FIELD sgs29
            IF NOT cl_null(g_sgs[l_ac].sgs29) THEN
               IF g_sgs[l_ac].sgs29 < 0 THEN
                  CALL cl_err(g_sgs[l_ac].sgs29,'anm-249',0)
                  NEXT FIELD sgs29
               END IF
            END IF
 
        AFTER FIELD sgs28
            IF NOT cl_null(g_sgs[l_ac].sgs28) THEN
               IF g_sgs[l_ac].sgs28 < 0 THEN
                  CALL cl_err(g_sgs[l_ac].sgs28,'anm-249',0)
                  NEXT FIELD sgs28
               END IF
            END IF
 
        AFTER FIELD sgs31
            IF NOT cl_null(g_sgs[l_ac].sgs31) THEN
               IF g_sgs[l_ac].sgs31 < 0 THEN
                  CALL cl_err(g_sgs[l_ac].sgs31,'anm-249',0)
                  NEXT FIELD sgs31
               END IF
            END IF
 
        AFTER FIELD sgs30
            IF NOT cl_null(g_sgs[l_ac].sgs30) THEN
               IF g_sgs[l_ac].sgs30 < 0 THEN
                  CALL cl_err(g_sgs[l_ac].sgs30,'anm-249',0)
                  NEXT FIELD sgs30
               END IF
            END IF
 
        AFTER FIELD sgs26
            IF NOT cl_null(g_sgs[l_ac].sgs26) THEN
               IF g_sgs[l_ac].sgs26 < 0 THEN
                  CALL cl_err(g_sgs[l_ac].sgs26,'anm-249',0)
                  NEXT FIELD sgs26
               END IF
            END IF
 
        AFTER FIELD sgs32
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs32 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs32
               END IF
            END IF
            IF NOT cl_null(g_sgs[l_ac].sgs32) THEN
               IF g_sgs[l_ac].sgs32 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgs32
               END IF
            END IF
 
        AFTER FIELD sgs33
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs33 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs33
               END IF
            END IF
            IF NOT cl_null(g_sgs[l_ac].sgs33) THEN
               IF g_sgs[l_ac].sgs33 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgs33
               END IF
            END IF
 
        AFTER FIELD sgsslk08
            IF NOT cl_null(g_sgs[l_ac].sgsslk08) THEN                                                                                  
               IF g_sgs[l_ac].sgsslk08 < 0 THEN                                                                                        
                  CALL cl_err(g_sgs[l_ac].sgsslk08,'anm-249',0)                                                                        
                  NEXT FIELD sgsslk08                                                                                                  
               END IF                                                                                                               
            END IF
 
       AFTER FIELD sgsslk07
             IF NOT cl_null(g_sgs[l_ac].sgsslk07) THEN                                                                                  
                IF g_sgs[l_ac].sgsslk07 < 0 THEN                                                                                        
                   CALL cl_err(g_sgs[l_ac].sgsslk07,'anm-249',0)                                                                        
                   NEXT FIELD sgsslk07                                                                                                  
                END IF                                                                                                               
             END IF
 
       AFTER FIELD sgsslk06
            IF NOT cl_null(g_sgs[l_ac].sgsslk06) THEN                                                                                  
               IF g_sgs[l_ac].sgsslk06 < 0 THEN                                                                                        
                  CALL cl_err(g_sgs[l_ac].sgsslk06,'anm-249',0)                                                                        
                  NEXT FIELD sgsslk06                                                                                                  
               END IF                                                                                                               
            END IF
        
        BEFORE FIELD sgs34
            CALL i120_set_entry_b(p_cmd)
 
        AFTER FIELD sgs34
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs34 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs34
               END IF
            END IF
            IF NOT cl_null(g_sgs[l_ac].sgs34) THEN
               IF g_sgs[l_ac].sgs34 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgs34
               END IF
               IF g_sgs[l_ac].sgs34 ='N' THEN
                  LET g_sgs[l_ac].sgs35 = ' '
                  DISPLAY BY NAME g_sgs[l_ac].sgs35
               END IF
 
               CALL i120_set_no_entry_b(p_cmd)
 
            END IF
            
 
        AFTER FIELD sgs35
           #IF NOT cl_null(g_sgs[l_ac].sgs35) THEN                                 #MOD-B80309 mark
            IF g_sgs[l_ac].sgs35 IS NOT NULL AND g_sgs[l_ac].sgs35 != '　'  THEN   #MOD-B80309 add
               CALL i120_sgg(g_sgs[l_ac].sgs35)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgs[l_ac].sgs35=g_sgs_t.sgs35
                  DISPLAY BY NAME g_sgs[l_ac].sgs35
                  NEXT FIELD sgs35
               END IF
            END IF
 
        AFTER FIELD sgs36
           #IF NOT cl_null(g_sgs[l_ac].sgs36) THEN                                 #MOD-B80309 mark
            IF g_sgs[l_ac].sgs36 IS NOT NULL AND g_sgs[l_ac].sgs36 != '　'  THEN   #MOD-B80309 add
               CALL i120_sgg(g_sgs[l_ac].sgs36)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgs[l_ac].sgs36=g_sgs_t.sgs36
                  DISPLAY BY NAME g_sgs[l_ac].sgs36
                  NEXT FIELD sgs36
               END IF
            END IF
 
 #FUN-A50100 --begin--
#        AFTER FIELD sgs37
#           IF NOT cl_null(g_sgs[l_ac].sgs37) THEN
#               SELECT COUNT(*) INTO g_cnt FROM gfe_file
#                WHERE gfe01=g_sgs[l_ac].sgs37
#               IF g_cnt=0 THEN
#                  CALL cl_err('','mfg2605',0)
#                  NEXT FIELD sgs37
#               END IF
#           END IF     
#            IF g_sgs[l_ac].sgs04 = '1' THEN
#               IF g_sgs[l_ac].sgs37 IS NULL THEN
#                  CALL cl_err('','agl-154',0)
#                  NEXT FIELD sgs37
#               END IF
#             IF NOT cl_null(g_sgs[l_ac].sgs37) THEN   #TQC-970169
#             
#               IF NOT cl_null(g_sgs[l_ac].sgs38) THEN
#                  IF g_sgs[l_ac].sgs37 = g_sgs[l_ac].sgs38 THEN
#                     LET g_sgs[l_ac].sgs39=1
#                  ELSE
#                     CALL s_umfchk(g_sgr.sgr01,g_sgs[l_ac].sgs38,g_sgs[l_ac].sgs37)
#                          RETURNING g_sw,g_sgs[l_ac].sgs39
#                     IF g_sw = '1' THEN
#                        CALL cl_err(g_sgs[l_ac].sgs38,'mfg1206',0)
#                        NEXT FIELD sgs38
#                     END IF
#                  END IF
#               END IF
#               DISPLAY BY NAME g_sgs[l_ac].sgs39
#            END IF
#           END IF    #No.FUN-870124
 #FUN-A50100 --end--
  
        AFTER FIELD sgs38
          #FUN-910088--add--start--
           IF NOT cl_null(g_sgs[l_ac].sgs38) THEN
             LET g_sgs[l_ac].sgs052a = s_digqty(g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs38)
          ELSE
             LET g_sgs[l_ac].sgs052a = s_digqty(g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs21)
          END IF
          #FUN-910088--add--end--
           IF NOT cl_null(g_sgs[l_ac].sgs38) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_sgs[l_ac].sgs38
               IF g_cnt=0 THEN
                  CALL cl_err('','mfg2605',0)
                  NEXT FIELD sgs38
               END IF
           END IF     
            IF g_sgs[l_ac].sgs04 = '1' THEN
               IF g_sgs[l_ac].sgs38 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgs38
               END IF
            IF NOT cl_null(g_sgs[l_ac].sgs38) THEN
           
#FUN-A50100 --begin--
#               IF g_sgs[l_ac].sgs37 = g_sgs[l_ac].sgs38 THEN
#                  LET g_sgs[l_ac].sgs39=1
#               ELSE
#                  CALL s_umfchk(g_sgr.sgr01,g_sgs[l_ac].sgs38,g_sgs[l_ac].sgs37)
#                       RETURNING g_sw,g_sgs[l_ac].sgs39
#                  IF g_sw = '1' THEN
#                     CALL cl_err(g_sgs[l_ac].sgs38,'mfg1206',0)
#                     NEXT FIELD sgs38
#                  END IF
#               END IF
#               DISPLAY BY NAME g_sgs[l_ac].sgs39
#FUN-A50100 --end--
            END IF
          END IF    #No.FUN-870124
 
        BEFORE DELETE                            #是否取消單身
            IF g_sgs_t.sgs05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM sgs_file
                 WHERE sgs01 = g_sgr.sgr01 
                   AND sgs02 = g_sgr.sgr02
                   AND sgs012= g_sgr.sgr012   #FUN-A50100 
                   AND sgs03 = g_sgr.sgr03
                   AND sgs05 = g_sgs_t.sgs05
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sgs_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
                   
        ON ROW CHANGE
           IF g_sgs[l_ac].sgs04 != g_sgs_t.sgs04 THEN 
              IF g_sgs[l_ac].sgs04 = 1 THEN
                 IF cl_null(g_sgs[l_ac].sgs23) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs23
                 END IF
                 IF cl_null(g_sgs[l_ac].sgs24) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs24
                 END IF
                 IF cl_null(g_sgs[l_ac].sgs27) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs27
                 END IF
                 IF cl_null(g_sgs[l_ac].sgs32) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs32
                 END IF
                 IF cl_null(g_sgs[l_ac].sgs33) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs33
                 END IF
                 IF cl_null(g_sgs[l_ac].sgs34) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs34
                 END IF
#FUN-A50100 --begin--
#                 IF cl_null(g_sgs[l_ac].sgs37) THEN
#                    CALL cl_err('','agl-154',0)
#                    NEXT FIELD sgs37
#                 END IF
#FUN-A50100 --end--                 
                 IF cl_null(g_sgs[l_ac].sgs38) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgs38
                 END IF
              END IF
           END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgs[l_ac].* = g_sgs_t.*
               CLOSE i120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgs[l_ac].sgs05,-263,1)
               LET g_sgs[l_ac].* = g_sgs_t.*
            ELSE
               UPDATE sgs_file SET sgs05=g_sgs[l_ac].sgs05,
                                   sgs04=g_sgs[l_ac].sgs04,
                                   sgs06=g_sgs[l_ac].sgs06,
                                   sgs07=g_sgs[l_ac].sgs07,
                                   sgs08=g_sgs[l_ac].sgs08,
                                   sgs09=g_sgs[l_ac].sgs09,
                                   sgs10=g_sgs[l_ac].sgs10,
                                   sgs11=g_sgs[l_ac].sgs11,
                                   sgs12=g_sgs[l_ac].sgs12,
                                   sgs13=g_sgs[l_ac].sgs13,
                                   sgs14=g_sgs[l_ac].sgs14,
                                   sgs15=g_sgs[l_ac].sgs15,
                                   sgs16=g_sgs[l_ac].sgs16,
                                   sgs17=g_sgs[l_ac].sgs17,
                                   sgs18=g_sgs[l_ac].sgs18,
                                   sgs19=g_sgs[l_ac].sgs19,
#                                  sgs20=g_sgs[l_ac].sgs20,  #FUN-A50100
                                   sgs21=g_sgs[l_ac].sgs21,
                                   sgs22=g_sgs[l_ac].sgs22,
                                   sgs051b = g_sgs[l_ac].sgs051b,  #TQC-B80125
                                   sgs014b = g_sgs[l_ac].sgs014b,  #TQC-B80125
                                   sgsslk04=g_sgs[l_ac].sgsslk04,   
                                   sgsslk03=g_sgs[l_ac].sgsslk03,   
                                   sgsslk02=g_sgs[l_ac].sgsslk02,   
                                   sgsslk01=g_sgs[l_ac].sgsslk01,
                                   sgs23=g_sgs[l_ac].sgs23,
                                   sgs24=g_sgs[l_ac].sgs24,
                                   sgs25=g_sgs[l_ac].sgs25,
                                   sgs26=g_sgs[l_ac].sgs26,
                                   sgs27=g_sgs[l_ac].sgs27,
                                   sgs28=g_sgs[l_ac].sgs28,
                                   sgs29=g_sgs[l_ac].sgs29,
                                   sgs30=g_sgs[l_ac].sgs30,
                                   sgs31=g_sgs[l_ac].sgs31,
                                   sgs32=g_sgs[l_ac].sgs32,
                                   sgs33=g_sgs[l_ac].sgs33,
                                   sgs34=g_sgs[l_ac].sgs34,
                                   sgs35=g_sgs[l_ac].sgs35,
                                   sgs36=g_sgs[l_ac].sgs36,
#                                  sgs37=g_sgs[l_ac].sgs37, #FUN-A50100 
                                   sgs38=g_sgs[l_ac].sgs38,
                                   sgs39=g_sgs[l_ac].sgs39 
                                  ,sgs052b=g_sgs[l_ac].sgs052b,  #FUN-A50100 
                                   sgs053b=g_sgs[l_ac].sgs053b,  #FUN-A50100 
                                   sgs052a=g_sgs[l_ac].sgs052a,  #FUN-A50100 
                                   sgs051a=g_sgs[l_ac].sgs051a,  #TQC-B80125
                                   sgs014a=g_sgs[l_ac].sgs014a,  #TQC-B80125 
                                   sgs053a=g_sgs[l_ac].sgs053a   #FUN-A50100                                                                                                       
                                  ,sgsslk08=g_sgs[l_ac].sgsslk08,   
                                   sgsslk07=g_sgs[l_ac].sgsslk07,   
                                   sgsslk06=g_sgs[l_ac].sgsslk06,   
                                   sgsslk05=g_sgs[l_ac].sgsslk05
                WHERE sgs01=g_sgr.sgr01
                  AND sgs02=g_sgr.sgr02
                  AND sgs012=g_sgr.sgr012    #FUN-A50100 
                  AND sgs03=g_sgr.sgr03
                  AND sgs05=g_sgs_t.sgs05
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sgs_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1) 
                  LET g_sgs[l_ac].* = g_sgs_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
             END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgs[l_ac].* = g_sgs_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgs.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               ROLLBACK WORK
               CLOSE i120_bcl
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i120_bcl
            COMMIT WORK
 
        ON ACTION controlp                        #
           CASE
              #MOD-D30088 add begin----------------------------------
              WHEN INFIELD(sgs05)                 #工藝序號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecb03_1"
                   LET g_qryparam.arg1 = g_sgr.sgr01
                   LET g_qryparam.arg2 = g_sgr.sgr02
                   LET g_qryparam.arg3 = g_sgr.sgr012
                   LET g_qryparam.default1 = g_sgs[l_ac].sgs05
                   CALL cl_create_qry() RETURNING g_sgs[l_ac].sgs05
                   DISPLAY BY NAME g_sgs[l_ac].sgs05
                   NEXT FIELD sgs05
              #MOD-D30088 add end------------------------------------
              WHEN INFIELD(sgs25)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.default1 = g_sgs[l_ac].sgs25
                   CALL cl_create_qry() RETURNING g_sgs[l_ac].sgs25
                   DISPLAY BY NAME g_sgs[l_ac].sgs25     
                   NEXT FIELD sgs25
              WHEN INFIELD(sgs24)
                   CALL q_eca(FALSE,FALSE,g_sgs[l_ac].sgs24)
                        RETURNING g_sgs[l_ac].sgs24
                   DISPLAY BY NAME  g_sgs[l_ac].sgs24    
                   NEXT FIELD sgs24
              WHEN INFIELD(sgs23)
                   CALL q_ecd(FALSE,TRUE,g_sgs[l_ac].sgs23)
                        RETURNING g_sgs[l_ac].sgs23
                    DISPLAY BY NAME g_sgs[l_ac].sgs23      
                    NEXT FIELD sgs23
              WHEN INFIELD(sgs35)
                   IF g_sgs[l_ac].sgs34='Y' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sgg"
                      LET g_qryparam.default1 = g_sgs[l_ac].sgs35
                      CALL cl_create_qry() RETURNING g_sgs[l_ac].sgs35
                   ELSE
                      LET g_sgs[l_ac].sgs35=''
                   END IF
                   DISPLAY BY NAME g_sgs[l_ac].sgs35      
                   NEXT FIELD sgs35
              WHEN INFIELD(sgs36)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_sgs[l_ac].sgs36
                   CALL cl_create_qry() RETURNING g_sgs[l_ac].sgs36
                   DISPLAY BY NAME g_sgs[l_ac].sgs36      
                   NEXT FIELD sgs36
#FUN-A50100 --begin--
#              WHEN INFIELD(sgs37)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gfe"
#                   LET g_qryparam.default1 = g_sgs[l_ac].sgs37
#                   CALL cl_create_qry() RETURNING g_sgs[l_ac].sgs37
#                   DISPLAY BY NAME g_sgs[l_ac].sgs37        
#                   NEXT FIELD sgs37
#FUN-A50100 --end--                   
              WHEN INFIELD(sgs38)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_sgs[l_ac].sgs38
                   CALL cl_create_qry() RETURNING g_sgs[l_ac].sgs38
                   DISPLAY BY NAME  g_sgs[l_ac].sgs38      
                   NEXT FIELD sgs38
           END CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sgs05) AND l_ac > 1 THEN
               LET g_sgs[l_ac].* = g_sgs[l_ac-1].*
               NEXT FIELD sgs05
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
    
    UPDATE sgr_file SET sgrmodu=g_user,
                        sgrdate=TODAY
     WHERE sgr01=g_sgr.sgr01 AND sgr02=g_sgr.sgr02 AND sgr03=g_sgr.sgr03
       AND sgr012 = g_sgr.sgr012            #FUN-A50100 
 
    CLOSE i120_bcl
    COMMIT WORK
#   CALL i120_delall()        #CHI-C30002 mark
    CALL i120_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i120_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM sgr_file
          WHERE sgr01 = g_sgr.sgr01
            AND sgr02 = g_sgr.sgr02
            AND sgr03 = g_sgr.sgr03
            AND sgr012= g_sgr.sgr012 
         INITIALIZE g_sgr.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i120_delall()
#
# SELECT COUNT(*) INTO g_cnt FROM sgs_file
#  WHERE sgs01 = g_sgr.sgr01
#    AND sgs02 = g_sgr.sgr02
#    AND sgs03 = g_sgr.sgr03
#    AND sgs012 = g_sgr.sgr012   #FUN-A50100 
#
# IF g_cnt = 0 THEN
#    CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#    ERROR g_msg CLIPPED
#    DELETE FROM sgr_file 
#     WHERE sgr01 = g_sgr.sgr01
#       AND sgr02 = g_sgr.sgr02
#       AND sgr03 = g_sgr.sgr03
#       AND sgr012= g_sgr.sgr012   #FUN-A50100 
# END IF
#
#END FUNCTION 
#CHI-C30002 -------- mark -------- end
FUNCTION i120_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
 
    IF INFIELD(sgs34) THEN
       CALL cl_set_comp_entry("sgs35",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i120_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
 
    IF INFIELD(sgs34) THEN
       IF g_sgs[l_ac].sgs34 ='N' THEN
          CALL cl_set_comp_entry("sgs35",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION  i120_sgg(p_key)
DEFINE
    p_key          LIKE sgg_file.sgg01,
    l_sgg01        LIKE sgg_file.sgg01,
    l_sggacti      LIKE sgg_file.sggacti
 
    LET g_errno = ' '
    SELECT sgg01,sggacti INTO l_sgg01,l_sggacti FROM sgg_file
     WHERE sgg01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-003'
                                   LET l_sggacti = NULL
         WHEN l_sggacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i120_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON sgs05,sgs04,sgs06,sgs07,sgs08,sgs09,sgs10,sgs11,sgs12,
#                      sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs20,sgs21,sgs22                   #FUN-A50100
#                      sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,      sgs21,sgs052b,sgs22,sgs053b   #FUN-A50100   #TQC-B80125 mark
                       sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs21,sgs22,sgs051b,sgs052b,sgs014,sgs053b  #TQC-B80125 add sgs051b,sgs014b
                       ,sgsslk01,
                       sgsslk02,sgsslk03,sgsslk04
                       ,sgs23,sgs24,sgs25,sgs26,sgs27,
#                      sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,sgs37, #FUN-A50100
                       sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,       #FUN-A50100
#                      sgs38,sgs052a,sgs39,sgs053a             #FUN-A50100 add sgs052a,sgs053a   #TQC-B80125 mark
                       sgs38,sgs39,sfs051a,sgs052a,sgs014a,sgs053a   #TQC-B80125 add sgs051a,sgs014a  
                       ,sgsslk05,sgsslk06,sgsslk07,sgsslk08
           FROM s_sgs[1].sgs05,s_sgs[1].sgs04,s_sgs[1].sgs06,s_sgs[1].sgs07,s_sgs[1].sgs08,s_sgs[1].sgs09,
                s_sgs[1].sgs10,s_sgs[1].sgs11,s_sgs[1].sgs12,s_sgs[1].sgs13,s_sgs[1].sgs14,s_sgs[1].sgs15,
#               s_sgs[1].sgs16,s_sgs[1].sgs17,s_sgs[1].sgs18,s_sgs[1].sgs19,s_sgs[1].sgs20,s_sgs[1].sgs21, #FUN-A50100
#               s_sgs[1].sgs16,s_sgs[1].sgs17,s_sgs[1].sgs18,s_sgs[1].sgs19,               s_sgs[1].sgs21,g_sgs[1].sgs052b, #FUN-A50100   #TQC-B80125 mark
                s_sgs[1].sgs16,s_sgs[1].sgs17,s_sgs[1].sgs18,s_sgs[1].sgs19,s_sgs[1].sgs21,s_sgs[1].sgs22,g_sgs[1].sgs051b,g_sgs[1].sgs052b,    #TQC-B80125 
#               s_sgs[1].sgs22,g_sgs[1].sgs053b,         #FUN-A50100 add sgs053b   #TQC-B80125
                s_sgs[1].sgs014b,g_sgs[1].sgs053b,       #TQC-B80125 
                s_sgs[1].sgsslk01,s_sgs[1].sgsslk02,s_sgs[1].sgsslk03,s_sgs[1].sgsslk04,
                s_sgs[1].sgs23,s_sgs[1].sgs24,s_sgs[1].sgs25,s_sgs[1].sgs26,s_sgs[1].sgs27,s_sgs[1].sgs28,
                s_sgs[1].sgs29,s_sgs[1].sgs30,s_sgs[1].sgs31,s_sgs[1].sgs32,s_sgs[1].sgs33,s_sgs[1].sgs34,
#               s_sgs[1].sgs35,s_sgs[1].sgs36,s_sgs[1].sgs37,s_sgs[1].sgs38,s_sgs[1].sgs39  #FUN-A50100 
#               s_sgs[1].sgs35,s_sgs[1].sgs36,               s_sgs[1].sgs38,s_sgs[1].sgs052a,s_sgs[1].sgs39,s_sgs[1].sgs053a  #FUN-A50100           #TQC-B80125  mark
                s_sgs[1].sgs35,s_sgs[1].sgs36,s_sgs[1].sgs38,s_sgs[1].sgs39,s_sgs[1].sgs051a,s_sgs[1].sgs052a,s_sgs[1].sgs014a,s_sgs[1].sgs053a     #TQC-B80125  
                ,s_sgs[1].sgsslk05,
                s_sgs[1].sgsslk06,s_sgs[1].sgsslk07,s_sgs[1].sgsslk08
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i120_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i120_b_fill(p_wc2)              #BODY FILL UP
DEFINE
     p_wc2         STRING      #NO.FUN-910082     
 
    LET g_sql =
        "SELECT sgs05,sgs04,sgs06,sgs07,sgs08,sgs09,sgs10,sgs11,sgs12,",
#       " sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs20,sgs21,sgs22,sgsslk01,",       #FUN-A50100
#       " sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,      sgs21,sgs052b,sgs22,sgs053b,sgsslk01,",       #FUN-A50100   #TQC-B80125
        " sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs21,sgs22,sgs051b,sgs052b,sgs014b,sgs053b,sgsslk01,",   #TQC-B80125 add sgs051b,sgs014b 
        " sgsslk02,sgsslk03,sgsslk04,sgs23,sgs24,sgs25,sgs26,sgs27,",    
#       " sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,",   #FUN-A50100 
        " sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,      ",   #FUN-A50100 
#       " sgs38,sgs052a,sgs39,sgs053a,sgsslk05,sgsslk06,sgsslk07,sgsslk08",  #FUN-A50100 add sgs052a,sgs053a,   #TQC-B80125  mark
        " sgs38,sgs39,sgs051a,sgs052a,sgs014a,sgs053a,sgsslk05,sgsslk06,sgsslk07,sgsslk08",     #TQC-B80125 add sgs051a,sgs014a
        " FROM sgs_file",
        " WHERE sgs01 ='",g_sgr.sgr01,"'",
        "   AND sgs02 ='",g_sgr.sgr02,"'",
        "   AND sgs03 ='",g_sgr.sgr03,"'",
        "   AND sgs012='",g_sgr.sgr012,"'",        #FUN-A50100 
        "   AND ",g_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE i120_pb FROM g_sql
    DECLARE sgs_curs CURSOR FOR i120_pb
 
    CALL g_sgs.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgs_curs INTO g_sgs[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sgs.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgs TO s_sgs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
        END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
        END IF
	      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
                                            
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION notconfirm
         LET g_action_choice="notconfirm"
         EXIT DISPLAY                                                                                        
 
      ON ACTION release  
         LET g_action_choice="release"  
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i120_sgs23(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,         #No.TQC-6A0065
    l_ecdacti       LIKE ecd_file.ecdacti
 
    LET g_errno = ' '
       SELECT ecd01,ecd07,ecdacti INTO
              g_sgs[l_ac].sgs23,g_sgs[l_ac].sgs24,l_ecdacti
         FROM ecd_file
        WHERE ecd01 = g_sgs[l_ac].sgs23
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-015'
                                      LET g_sgs[l_ac].sgs23 = NULL
                                      LET g_sgs[l_ac].sgs24 = NULL
            WHEN l_ecdacti='N' LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       DISPLAY BY NAME g_sgs[l_ac].sgs23
       DISPLAY BY NAME g_sgs[l_ac].sgs24
 
END FUNCTION
 
FUNCTION i120_g()
  DEFINE l_cmd         LIKE type_file.chr1000 
  DEFINE l_ecb03_min   LIKE ecb_file.ecb03
  DEFINE l_ecb03_max   LIKE ecb_file.ecb03
  DEFINE l_ecb17       LIKE ecb_file.ecb17    #No.FUN-870124
  DEFINE l_ecu10       LIKE ecu_file.ecu10    #No.FUN-870124
  DEFINE l_cnt         LIKE type_file.num5    #FUN-A50066
 
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_sgr.sgr01) THEN CALL cl_err('','-400',0) RETURN END IF  
  IF g_sgr.sgr08 = 'N' THEN CALL cl_err('','aap-717',0) RETURN END IF
  IF g_sgr.sgracti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF 
  IF NOT i120_chk_umf() THEN RETURN END IF #FUN-B90141 
  IF g_sgr.sgr09 = 'Y' THEN CALL cl_err(g_sgr.sgr09,'abm-003',0) RETURN END IF
      SELECT ecu10 INTO l_ecu10
        FROM ecu_file
       WHERE ecu01 = g_sgr.sgr01
         AND ecu02 = g_sgr.sgr02
         AND ecu012= g_sgr.sgr012   #FUN-A50100 
         AND ecuacti = 'Y'  #CHI-C90006
      IF l_ecu10 != 'Y' THEN
         CALL  cl_err('','aec-902',1)
         RETURN
      END IF
 
  BEGIN WORK                                                                                                                      
                                                                                                                                    
    OPEN i120_cl USING g_sgr.sgr01,g_sgr.sgr02,g_sgr.sgr03,g_sgr.sgr012  #No.TQC-9A0118 mod   #FUN-A50100 add sgr012              
    IF STATUS THEN                                                                                                                  
       CALL cl_err("OPEN i120_cl:", STATUS, 1)                                                                                      
       CLOSE i120_cl                                                                                                                
       ROLLBACK WORK                                                                                                                
       RETURN                                                                                                                       
    END IF                                                                                                                          
    FETCH i120_cl INTO g_sgr.*                                                                                                      
    IF SQLCA.sqlcode THEN                                                                                                           
       CALL cl_err(g_sgr.sgr01,SQLCA.sqlcode,0) RETURN                                                                              
    END IF                                                                                                                          
    CALL i120_show()                                                                                                                
    IF NOT cl_confirm('abm-004') THEN RETURN END IF                                                                                 
    LET g_sgr.sgr07=g_today                                                                                                         
    CALL cl_set_head_visible("","YES")
    INPUT BY NAME g_sgr.sgr07 WITHOUT DEFAULTS                                                                                      
                                                                                                                                    
      AFTER FIELD sgr07                                                                                                           
        IF cl_null(g_sgr.sgr07) THEN NEXT FIELD sgr07 END IF                                                                        
        IF g_sgr.sgr07 < g_sgr.sgr06 THEN
           CALL cl_err('','apm-055',0)
           NEXT FIELD sgr07
        END IF
                                                                                                                                    
      AFTER INPUT                                                                                                                   
        IF INT_FLAG THEN EXIT INPUT END IF                                                                                          
        IF cl_null(g_sgr.sgr07) THEN NEXT FIELD sgr07 END IF
 
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
         LET g_sgr.sgr07=NULL                                                                                                         
         DISPLAY BY NAME g_sgr.sgr07                                                                                                  
         LET INT_FLAG=0                                                                                                               
         ROLLBACK WORK                                                                                                                
         RETURN                                                                                                                       
      END IF                                                                                                                          
      
     LET g_success = 'Y'
     DECLARE sgs_cury CURSOR FOR
             SELECT sgs05,sgs04,sgs06,sgs07,sgs08,sgs09,sgs10,sgs11,sgs12,
#                   sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs20,sgs21,sgs22,  #FUN-A50100
#                   sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,      sgs21,sgs052b,sgs22,sgs053b,  #FUN-A50100    #TQC-B80125 mark
                    sgs13,sgs14,sgs15,sgs16,sgs17,sgs18,sgs19,sgs21,sgs22,sgs051b,sgs052b,sgs014b,sgs053b,       #TQC-B80125
                    sgsslk01,
                    sgsslk02,sgsslk03,sgsslk04,
                    sgs23,sgs24,sgs25,sgs26,sgs27,
#                   sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,sgs37,  #FUN-A50100 
                    sgs28,sgs29,sgs30,sgs31,sgs32,sgs33,sgs34,sgs35,sgs36,        #FUN-A50100 
#                   sgs38,sgs052a,sgs39,sgs053a                   #FUN-A50100 add sgs052a,sgs053a   #TQC-B80125
                    sgs38,sgs39,sgs051a,sgs052a,sgs014a,sgs053a   #TQC-B80125 
                    ,sgsslk05,sgsslk06,sgsslk07,sgsslk08
               FROM sgs_file 
              WHERE sgs01 = g_sgr.sgr01
                AND sgs02 = g_sgr.sgr02
                AND sgs03 = g_sgr.sgr03
                AND sgs012= g_sgr.sgr012   #FUN-A50100 add 
     FOREACH sgs_cury INTO g_sgs[l_ac].*
       SELECT ecd02 INTO l_ecb17
         FROM ecd_file
        WHERE ecd01 = g_sgs[l_ac].sgs23
       CASE g_sgs[l_ac].sgs04
         WHEN '1' 
          INSERT INTO ecb_file(ecb01,ecb02,ecb03,ecb06,ecb08,ecb07,ecb38,ecb04,ecb19,
#                              ecb18,ecb21,ecb20,ecb39,ecb40,ecb41,ecb42,ecb43,ecb44,   #FUN-A50100
                               ecb18,ecb21,ecb20,ecb39,ecb40,ecb41,ecb42,ecb43,         #FUN-A50100
                              #ecb45,ecb14,ecbslk01,ecbslk02,ecbslk04,ecbslk05,ecb17,ecbacti,ecboriu,ecborig,ecb012,ecb14,ecb52,ecb53)         #No.FUN-870124 add ecb17,ecbacti #FUN-A50100  add ecb012,ecb14,ecb52,ecb53,ecb46->ecb14 #MOD-B80118 mark                                                            
                               ecb45,ecb46,ecbslk01,ecbslk02,ecbslk04,ecbslk05,ecb17,ecbacti,ecboriu,ecborig,ecb012,ecb52,ecb53,ecb51,ecb14)   #MOD-B80118 add #TQC-B80125 add ecb14
          VALUES(g_sgr.sgr01,g_sgr.sgr02,g_sgs[l_ac].sgs05,g_sgs[l_ac].sgs23,
                 g_sgs[l_ac].sgs24,g_sgs[l_ac].sgs25,g_sgs[l_ac].sgs26,g_sgs[l_ac].sgs27,
                 g_sgs[l_ac].sgs28,g_sgs[l_ac].sgs29,g_sgs[l_ac].sgs30,g_sgs[l_ac].sgs31,
                 g_sgs[l_ac].sgs32,g_sgs[l_ac].sgs33,g_sgs[l_ac].sgs34,g_sgs[l_ac].sgs35,
#                g_sgs[l_ac].sgs36,g_sgs[l_ac].sgs37,g_sgs[l_ac].sgs38,g_sgs[l_ac].sgs39,  #FUN-A50100
                 g_sgs[l_ac].sgs36,                  g_sgs[l_ac].sgs38,g_sgs[l_ac].sgs39,  #FUN-A50100
                 g_sgs[l_ac].sgsslk05,g_sgs[l_ac].sgsslk06,
                 g_sgs[l_ac].sgsslk07,g_sgs[l_ac].sgsslk08,l_ecb17,'Y', g_user, g_grup,g_sgr.sgr012,  #No.FUN-870124 add l_ecb17      #No.FUN-980030 10/01/04  insert columns oriu, orig #FUN-A50100 add sgr012
#                g_sgs[l_ac].sgs39,g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs053a)  #FUN-A50100 add          #TQC-B80125 mark
                 g_sgs[l_ac].sgs052a,g_sgs[l_ac].sgs053a,g_sgs[l_ac].sgs051a,g_sgs[l_ac].sgs014a)     #TQC-B80125 mark sgs39  add sgs51a,sgs014a
          IF SQLCA.sqlcode  THEN                                                                                                  
             CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1)                                             
             LET g_success = 'N'                                                                                                      
             EXIT FOREACH                                                                                                             
          END IF
         WHEN '2' 
               DELETE FROM ecb_file
                WHERE ecb01 = g_sgr.sgr01
                  AND ecb02 = g_sgr.sgr02
                  AND ecb03 = g_sgs[l_ac].sgs05
                  AND ecb012= g_sgr.sgr012         #FUN-A50100  
               IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               DELETE FROM sgc_file
                WHERE sgc01 = g_sgr.sgr01
                  AND sgc02 = g_sgr.sgr02
                  AND sgc03 = g_sgs[l_ac].sgs05
                  AND sgc012= g_sgr.sgr012         #FUN-A50100  
               IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","sgc_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF   
         WHEN '3' 
#FUN-A50100 --begin--
               IF NOT cl_null(g_sgs[l_ac].sgs052a) THEN 
                  UPDATE ecb_file SET ecb52 = g_sgs[l_ac].sgs052a
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012                       
               END IF 
               IF NOT cl_null(g_sgs[l_ac].sgs053a) THEN 
                  UPDATE ecb_file SET ecb53 = g_sgs[l_ac].sgs053a
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012                   
               END IF                               
#FUN-A50100 --end--         
#TQC-B80125 ----------------Begin-----------------
               IF NOT cl_null(g_sgs[l_ac].sgs051a) THEN
                  UPDATE ecb_file SET ecb51 = g_sgs[l_ac].sgs051a
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs014a) THEN
                  UPDATE ecb_file SET ecb14 = g_sgs[l_ac].sgs014a
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012
               END IF
#TQC-B80125 ----------------End-------------------
               IF NOT cl_null(g_sgs[l_ac].sgs23) THEN
                  UPDATE ecb_file SET ecb06 = g_sgs[l_ac].sgs23
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012         #FUN-A50100  
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb06",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
                  UPDATE ecb_file SET ecb17 = l_ecb17
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012         #FUN-A50100 
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb17",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs24) THEN
                  UPDATE ecb_file SET ecb08 = g_sgs[l_ac].sgs24
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012        #FUN-A50100 
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb08",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs25) THEN
                  UPDATE ecb_file SET ecb07 = g_sgs[l_ac].sgs25
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012              #FUN-A50100 
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb07",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs26) THEN
                  UPDATE ecb_file SET ecb38 = g_sgs[l_ac].sgs26
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100 
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb38",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs27) THEN
                  UPDATE ecb_file SET ecb04 = g_sgs[l_ac].sgs27
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012         #FUN-A50100 
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb04",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs28) THEN
                  UPDATE ecb_file SET ecb19 = g_sgs[l_ac].sgs28
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100 
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb19",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs29) THEN
                  UPDATE ecb_file SET ecb18 = g_sgs[l_ac].sgs29
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb18",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs30) THEN
                  UPDATE ecb_file SET ecb21 = g_sgs[l_ac].sgs30
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb21",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs31) THEN
                  UPDATE ecb_file SET ecb20 = g_sgs[l_ac].sgs31
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb20",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs32) THEN
                  UPDATE ecb_file SET ecb39 = g_sgs[l_ac].sgs32
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb29",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs33) THEN
                  UPDATE ecb_file SET ecb40 = g_sgs[l_ac].sgs33
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb40",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs34) THEN
                  UPDATE ecb_file SET ecb41 = g_sgs[l_ac].sgs34
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb41",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
              #IF NOT cl_null(g_sgs[l_ac].sgs35) THEN                                  #MOD-B80309 mark
               IF g_sgs[l_ac].sgs35 IS NOT NULL OR g_sgs[l_ac].sgs35 = '　'  THEN      #MOD-B80309 add
                  IF g_sgs[l_ac].sgs35 = '　' THEN LET g_sgs[l_ac].sgs35 = '' END IF   #MOD-B80309 add
                  UPDATE ecb_file SET ecb42 = g_sgs[l_ac].sgs35
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb42",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
              #IF NOT cl_null(g_sgs[l_ac].sgs36) THEN                                  #MOD-B80309 mark
               IF g_sgs[l_ac].sgs36 IS NOT NULL OR g_sgs[l_ac].sgs36 = '　'  THEN      #MOD-B80309 add
                  IF g_sgs[l_ac].sgs36 = '　' THEN LET g_sgs[l_ac].sgs36 = '' END IF   #MOD-B80309 add
                  UPDATE ecb_file SET ecb43 = g_sgs[l_ac].sgs36
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb43",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
#FUN-A50100 --begin--
#               IF NOT cl_null(g_sgs[l_ac].sgs37) THEN
#                  UPDATE ecb_file SET ecb44 = g_sgs[l_ac].sgs37
#                   WHERE ecb01 = g_sgr.sgr01
#                     AND ecb02 = g_sgr.sgr02
#                     AND ecb03 = g_sgs[l_ac].sgs05
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb44",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#FUN-A50100 --end--
               IF NOT cl_null(g_sgs[l_ac].sgs38) THEN
                  UPDATE ecb_file SET ecb45 = g_sgs[l_ac].sgs38
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb45",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgs39) THEN
                   UPDATE ecb_file SET ecb46 = g_sgs[l_ac].sgs39   #FUN-A50100   #TQC-B80125 remark
#                  UPDATE ecb_file SET ecb14 = g_sgs[l_ac].sgs39   #FUN-A50100   #TQC-B80125 mark
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecb14",1)          #FUN-A50100 ecb46->ecb14                                     
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgsslk05) THEN
                  UPDATE ecb_file SET ecbslk01 = g_sgs[l_ac].sgsslk05
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecbslk01",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgsslk06) THEN
                  UPDATE ecb_file SET ecbslk02 = g_sgs[l_ac].sgsslk06
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecbslk02",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgsslk07) THEN
                  UPDATE ecb_file SET ecbslk04 = g_sgs[l_ac].sgsslk07
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecbslk04",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_sgs[l_ac].sgsslk08) THEN
                  UPDATE ecb_file SET ecbslk05 = g_sgs[l_ac].sgsslk08
                   WHERE ecb01 = g_sgr.sgr01
                     AND ecb02 = g_sgr.sgr02
                     AND ecb03 = g_sgs[l_ac].sgs05
                     AND ecb012= g_sgr.sgr012          #FUN-A50100                      
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecb_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","ecbslk05",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
       END CASE
     LET l_ac=l_ac+1
     END FOREACH
     SELECT min(ecb03) INTO l_ecb03_min
       FROM ecb_file
      WHERE ecb01 = g_sgr.sgr01
        AND ecb02 = g_sgr.sgr02
        AND ecb012= g_sgr.sgr012          #FUN-A50100         
     SELECT max(ecb03) INTO l_ecb03_max
       FROM ecb_file
      WHERE ecb01 = g_sgr.sgr01
        AND ecb02 = g_sgr.sgr02
        AND ecb012= g_sgr.sgr012          #FUN-A50100         
     UPDATE ecu_file SET ecu04 = l_ecb03_min,
                         ecu05 = l_ecb03_max,
                         ecudate = g_today     #FUN-C40008 add
      WHERE ecu01 = g_sgr.sgr01
        AND ecu02 = g_sgr.sgr02
        AND ecu012= g_sgr.sgr012          #FUN-A50100 
     IF SQLCA.sqlcode  THEN                                                                                                  
        CALL cl_err3("sql","ecu_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","up ecu",1)                                             
        LET g_success = 'N'
     END IF
     UPDATE ecu_file SET ecu11 = g_sgr.sgr03,
                         ecudate = g_today     #FUN-C40008 add
      WHERE ecu01 = g_sgr.sgr01
        AND ecu02 = g_sgr.sgr02
        AND ecu012= g_sgr.sgr012          #FUN-A50100         
     IF SQLCA.sqlcode  THEN                                                                                                  
        CALL cl_err3("sql","ecu_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","up ecu",1)                                             
        LET g_success = 'N'
     END IF   
     UPDATE sgr_file SET sgr07=g_sgr.sgr07,                                                                                          
                         sgr09='Y'                                                                                                   
                      WHERE sgr01=g_sgr.sgr01
                        AND sgr02=g_sgr.sgr02
                        AND sgr03=g_sgr.sgr03   
                        AND sgr012=g_sgr.sgr012        #FUN-A50100                                                                                        
     IF SQLCA.SQLERRD[3]=0 THEN                                                                                                      
        LET g_sgr.sgr07=NULL                                                                                                         
        DISPLAY BY NAME g_sgr.sgr07                                                                                                  
        CALL cl_err3("upd","sgr_file",g_sgr.sgr01,g_sgr.sgr02,SQLCA.sqlcode,"","up sgr07",1)                                                  
        LET g_success = 'N'                                                                                                                
        RETURN                                                                                                                       
     END IF
 
    IF g_success = 'N' THEN                                                                                                         
       ROLLBACK WORK                                                                                                                
    ELSE                                                                                                                            
       COMMIT WORK  
    END IF
    #FUN-A50066--begin--add-----------
    IF g_sma.sma541='Y' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM sfb_file
       WHERE sfb05=g_sgr.sgr01
         AND sfb06=g_sgr.sgr02
         AND sfb04 in('1','2','3') 
         AND sfbacti='Y'
         AND sfb93='Y'
      IF l_cnt > 0 THEN
         IF cl_confirm('aec-110') THEN 
            CALL i120_upd_ecm()
         END IF
      END IF
    END IF
    #FUN-A50066--end--add------------
    
    SELECT sgr09 INTO g_sgr.sgr09
      FROM sgr_file
     WHERE sgr01=g_sgr.sgr01
       AND sgr02=g_sgr.sgr02
       AND sgr03=g_sgr.sgr03
       AND sgr012= g_sgr.sgr012   #FUN-A50100 
    DISPLAY BY NAME g_sgr.sgr07
    DISPLAY BY NAME g_sgr.sgr09
END FUNCTION                                                         
 
FUNCTION i120_set_sgs04()
DEFINE lcbo_target ui.ComboBox                                                                                                   
 
   LET lcbo_target = ui.ComboBox.forName("sgs04")   
      CALL lcbo_target.RemoveItem("1") 
END FUNCTION        
 
FUNCTION i120_set_sgs04a()
   DEFINE lcbo_target ui.ComboBox
   DEFINE l_str       STRING
   DEFINE l_ze03 LIKE ze_file.ze03
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-115'
     AND ze02=g_lang
   
   LET lcbo_target = ui.ComboBox.forName("sgs04")
   LET l_str = l_ze03
   CALL lcbo_target.AddItem("1",l_str)
END FUNCTION

#FUN-A50066--begin--add-----------------
FUNCTION i120_upd_ecm()
DEFINE l_cnt,l_rec_b,i,l_n,l_ac  LIKE type_file.num5
DEFINE l_sfb     DYNAMIC ARRAY OF RECORD 
                 sel    LIKE type_file.chr1, 
                 sfb01  LIKE sfb_file.sfb01,
                 sfb05  LIKE sfb_file.sfb05,
                 ima55  LIKE ima_file.ima55,
                 sfb08  LIKE sfb_file.sfb08,
                 sfb13  LIKE sfb_file.sfb13,
                 sfb04  LIKE sfb_file.sfb04
                 END RECORD
DEFINE l_sfb15   LIKE sfb_file.sfb15
DEFINE l_sfb071  LIKE sfb_file.sfb071
DEFINE l_sfb06   LIKE sfb_file.sfb06
DEFINE l_sfb02   LIKE sfb_file.sfb02
DEFINE l_sfb95   LIKE sfb_file.sfb95
DEFINE l_sfb32   LIKE sfb_file.sfb32
DEFINE l_sfb24   LIKE sfb_file.sfb24
DEFINE l_minopseq  LIKE type_file.num5
DEFINE l_btflg   LIKE type_file.chr1

   LET p_row = 1 LET p_col = 3
   OPEN WINDOW i120_a_w AT p_row,p_col WITH FORM "aec/42f/aeci120_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aeci120_2")
    
   DECLARE i120_sfb CURSOR FOR
      SELECT 'N',sfb01,sfb05,'',sfb08,sfb13,sfb04 FROM sfb_file
       WHERE sfb05=g_sgr.sgr01
         AND sfb06=g_sgr.sgr02
         AND sfb04 in('1','2','3') 
         AND sfbacti='Y'
         AND sfb93='Y'
   
   CALL l_sfb.clear()
   
   LET l_cnt = 1
   LET l_rec_b = 0
   FOREACH i120_sfb INTO l_sfb[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima55 INTO l_sfb[l_cnt].ima55 FROM ima_file WHERE ima01=l_sfb[l_cnt].sfb05
      LET l_cnt=l_cnt + 1
      IF l_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL l_sfb.deleteElement(l_cnt)
   LET l_rec_b=l_cnt -1
   
   WHILE TRUE
      INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF l_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
          LET l_ac = ARR_CURR()

        AFTER ROW
            LET l_ac = ARR_CURR()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION controlg 
            CALL cl_cmdask() 
      END INPUT
      LET l_rec_b=ARR_COUNT()
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         CLOSE WINDOW i120_a_w 
         RETURN
      END IF
      EXIT WHILE
   END WHILE
   CLOSE WINDOW i120_a_w 
   
   FOR i=1 TO l_rec_b
        IF l_sfb[i].sel<>'Y' THEN 
           CONTINUE FOR 
        END IF
        DELETE FROM ecm_file WHERE ecm01=l_sfb[i].sfb01
        SELECT sfb15,sfb071,sfb06,sfb02,sfb95
          INTO l_sfb15,l_sfb071,l_sfb06,l_sfb02,l_sfb95
          FROM sfb_file
         WHERE sfb01=l_sfb[i].sfb01
         CALL s_schdat(0,l_sfb[i].sfb13,l_sfb15,l_sfb071,l_sfb[i].sfb01,
                      l_sfb06,l_sfb02,l_sfb[i].sfb05,l_sfb[i].sfb08,2)                  
          RETURNING l_n,l_sfb[i].sfb13,l_sfb15,l_sfb32,l_sfb24
        SELECT count(*) INTO l_n FROM ecm_file WHERE ecm01 = l_sfb[i].sfb01
        IF l_n > 0 THEN
           UPDATE sfb_file SET sfb24='Y' WHERE sfb01=l_sfb[i].sfb01 
        END IF
        IF g_sma.sma542='Y' THEN 
            DELETE FROM sfa_file WHERE sfa01=l_sfb[i].sfb01 
            IF NOT s_industry('std') THEN
               IF NOT s_del_sfai(l_sfb[i].sfb01,'','','','','','','') THEN
                  RETURN                                                                                                                        
               END IF
            END IF
            CALL s_minopseq(l_sfb[i].sfb05,l_sfb06,l_sfb071) RETURNING l_minopseq
            CASE                                                                                                                             
              WHEN l_sfb02='13'     #預測工單展至尾階                                                                                   
                CALL s_cralc2(l_sfb[i].sfb01,l_sfb02,l_sfb[i].sfb05,'Y',                                                                   
                              l_sfb[i].sfb08,l_sfb071,'Y',g_sma.sma71,l_minopseq,                                                       
                              ' 1=1',l_sfb95)                                                                        
                RETURNING l_n                                                         
              OTHERWISE                 #一般工單展單階                                                                                     
                 IF l_sfb02 = 11 THEN                                                                                                  
                    LET l_btflg = 'N'                                                                                                      
                 ELSE                                                                                                                    
                    LET l_btflg = 'Y'                                                                                                      
                 END IF
                 CALL s_cralc(l_sfb[i].sfb01,l_sfb02,l_sfb[i].sfb05,l_btflg,                                                                 
                             #l_sfb[i].sfb08,l_sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb95)                              
                              l_sfb[i].sfb08,l_sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb95)      #FUN-BC0008 mod
                 RETURNING l_n
             END CASE
        END IF
   END FOR
             
   CLOSE WINDOW i120_a_w 
END FUNCTION
#FUN-A50066--end--add--------------------------------
#FUN-B90141 --START--
#單位轉換率檢查
FUNCTION i120_chk_umf()
DEFINE l_sql     STRING
DEFINE l_sgs05   LIKE sgs_file.sgs05
DEFINE l_sgs21   LIKE sgs_file.sgs21
DEFINE l_sgs22   LIKE sgs_file.sgs22
DEFINE l_sgs051b LIKE sgs_file.sgs051b
DEFINE l_sgs38   LIKE sgs_file.sgs38
DEFINE l_sgs39   LIKE sgs_file.sgs39
DEFINE l_sgs051a LIKE sgs_file.sgs051a
DEFINE l_flag    LIKE type_file.chr1
DEFINE l_fac     LIKE type_file.num26_10
DEFINE l_fac2    LIKE type_file.num26_10
DEFINE l_ima55   LIKE ima_file.ima55
DEFINE l_showmsg STRING

   LET g_success = 'Y'

   CALL s_showmsg_init()
   
   SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=g_sgr.sgr01 

   LET l_sql = "SELECT sgs05,sgs21,sgs22,sgs051b,sgs38,sgs39,sgs051a",
                " FROM sgs_file" ,
                "  WHERE sgs01 = '", g_sgr.sgr01, "'",
                "  AND sgs02 = '", g_sgr.sgr02, "'",
                "  AND sgs03 = ", g_sgr.sgr03, " ",
                "  AND sgs012= '", g_sgr.sgr012, "'"
   DECLARE sgs_cs1 CURSOR FROM l_sql 
   FOREACH sgs_cs1 INTO l_sgs05,l_sgs21,l_sgs22,l_sgs051b,l_sgs38,l_sgs39,l_sgs051a
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('sgs05',l_sgs05,'FOREACH sgs_cs1',SQLCA.sqlcode,1)         
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF    
      
      #若無變更帶舊值
      IF cl_null(l_sgs38) THEN LET l_sgs38 = l_sgs21 END IF
      IF cl_null(l_sgs39) THEN LET l_sgs39 = l_sgs22 END IF 
      IF cl_null(l_sgs051a) THEN LET l_sgs051a = l_sgs051b END IF
      
      LET l_showmsg = l_sgs05 CLIPPED  , '/', l_sgs38 CLIPPED,
                       '/', l_sgs39 CLIPPED, '/', l_sgs051a CLIPPED
      
      CALL s_umfchk(g_sgr.sgr01,l_sgs38,l_ima55)
                            RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL s_errmsg('sgs05,sgs38,sgs39,sgs051a',l_showmsg,'s_umfchk',"abm-731",1)
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF
      LET l_fac2 = l_sgs051a / l_sgs39
      IF l_fac != l_fac2 THEN 
         CALL s_errmsg('sgs05,sgs38,sgs39,sgs051a',l_showmsg,' ',"aec-069",1)
         LET g_success = 'N'         
         CONTINUE FOREACH 
      END IF    
   END FOREACH 

   IF g_success = 'N' THEN 
      CALL s_showmsg()
      RETURN FALSE 
   END IF 
   RETURN TRUE   
END FUNCTION 
#FUN-B90141 --END--
#No.FUN-9C0077 程式精簡 

