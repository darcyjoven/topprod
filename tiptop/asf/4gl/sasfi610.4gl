# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sasfi610.4gl
# Descriptions...: 工單備置/退備置維護作業
# Date & Author..: 10/02/28 Liuxqa
# Modify.........: No.FUN-A20048 10/02/25 By liuxqa  
# Modify.........: No.FUN-A50023 10/05/12 By liuxqa 
# Modify.........: No.FUN-A90035 10/09/20 bY vealxu sia07的開窗和欄位檢查，加上sfd.確認碼='Y'
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.MOD-AC0385 10/12/29 By jan g_sql --> l_sql
# Modify.........: No.FUN-B20009 11/03/31 By lixh1 新增製程段號,製程序,製程段說明欄位
# Modify.........: No.FUN-AC0074 11/04/08 By lixh1 新增雜發備置,調撥備置,訂單備置功能
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.TQC-B50052 11/06/02 By lixh1 修改調撥單備置條件
# Modify.........: No.FUN-B50064 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60244 11/06/21 By jan 單身出現重複資料
# Modify.........: No.TQC-B60298 11/06/23 By jan 修改订单备置供外部呼叫的方式
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-BA0091 11/10/27 By Vampire 換算率(sic07)未自動給default
# Modify.........: No:FUN-BB0086 11/12/07 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20068 12/02/14 By fengrui 數量欄位小數取位處理
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: NO.TQC-C50082 12/05/10 By fengrui 把必要字段controlz換成controlr
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:TQC-C60207 12/06/28 By lixh1 審核時控管廠商是否可用
# Modify.........: No:TQC-C70014 12/07/03 By zhuhao 訂單結案時不可備置
# Modify.........: No:TQC-C70020 12/07/03 By zhuhao 已留置的訂單應不能進行備置
# Modify.........: No:TQC-C60211 12/07/31 By zhuhao 錄入訂單單號開窗控管
# Modify.........: No:TQC-CB0042 12/11/14 By xuxz sic05開窗可以抓到ust的取替代料件
# Modify.........: No:TQC-CB0044 12/11/15 By xuxz sic03開窗修改，sic03欄位檢查修改
# Modify.........: No:TQC-D10061 13/01/16 By fengmy 單身應顯示料件編號的品名及規格資料
# Modify.........: No:MOD-CC0185 13/01/31 By Elise 1.目前BOM料號、發料料號、備置量、倉庫有CALL i610_img10_count檢查可備置量,請增加儲位、批號的控卡,比照倉庫控卡
#                                                  2.FUNCTION i610_img10_count中請增加判斷倉庫為空白直接RETURN,並請測試確認時倉庫為空要不能確認
# Modify.........: No:FUN-D20060 13/02/22 By nanbing 設限倉庫控卡
# Modify.........: No:FUN-D20059 13/03/26 By xumm 畫面及時顯示確認異動時間
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D60230 13/06/27 By suncx 管控備置量不能大於庫存量時應該對工單同一單身料件的所有備料數量之和與庫存量-已備料量對比
# Modify.........: No:TQC-DB0048 13/11/20 By wangrr 查詢時'儲位'增加開窗,修改'批號'開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasfi610.global"
 
DEFINE g_ima918  LIKE ima_file.ima918  
DEFINE g_ima921  LIKE ima_file.ima921  
DEFINE l_r       LIKE type_file.chr1   
DEFINE l_fac     LIKE img_file.img34   
DEFINE li_where  LIKE type_file.chr1000 
DEFINE g_sic04   LIKE sic_file.sic04   
DEFINE g_ima23   LIKE ima_file.ima23  
DEFINE g_sic07_t LIKE sic_file.sic07   #No.FUN-BB0086 
 
FUNCTION i610(p_argv1,p_argv2,p_argv3)
   DEFINE p_argv1       LIKE type_file.chr1         #No.FUN-A20048 VARCHAR(1)# 1.備置 2.退備置
   DEFINE p_argv2       LIKE sia_file.sia01         #備置單號 
   DEFINE p_argv3       STRING           
   DEFINE l_i           LIKE type_file.num5          
    WHENEVER ERROR CONTINUE                         #忽略一切錯誤
    	     
    LET g_wc2 =' 1=1'
    LET g_wc3 =' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM sia_file WHERE sia01 = ? FOR UPDATE"            
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i610_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = p_argv1 
    LET g_argv2 = p_argv2 
    LET g_argv3 = p_argv3
#FUN-B20009 --------------------Begin-------------------
    IF g_sma.sma541='Y' THEN
       CALL cl_set_comp_visible("sic012,ecm014,sic013",TRUE)
    ELSE
       CALL cl_set_comp_visible("sic012,ecm014,sic013",FALSE)
    END IF 
#FUN-B20009 --------------------End---------------------
#FUN-AC0074 --------------------Begin-------------------
    IF g_argv1 = '2' OR g_argv1 = '3' THEN
       CALL cl_set_comp_visible("page3,sia07",FALSE)
    END IF
    IF g_argv1 = '2' THEN
       CALL cl_set_comp_visible("sic05,sic012,ecm014,sic11,sic013",FALSE)
       CALL cl_getmsg('asf-175',g_lang) RETURNING g_msg    
       CALL cl_set_comp_att_text("sic03",g_msg CLIPPED)
       CALL cl_getmsg('asf-176',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sic04",g_msg CLIPPED)
       CALL cl_getmsg('asf-177',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfa05",g_msg CLIPPED)
       CALL cl_getmsg('asf-178',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfa06",g_msg CLIPPED)
       CALL cl_set_comp_entry("sfa05,sfa06,sia05,sic07,sic07_fac",FALSE) 
       CALL cl_getmsg('asf-181',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sic15",g_msg CLIPPED)
       CALL i610_sia05()
    END IF
    IF g_argv1 = '3' THEN
       CALL cl_set_comp_visible("sic05,sic012,ecm014,sic11,sic013,sfa06",FALSE)
       CALL cl_set_comp_entry("sfa05,sic04,sic06,sic07,sic07_fac,sic08,sic09,sic10",FALSE)
       CALL cl_getmsg('asf-179',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sic03",g_msg CLIPPED)
       CALL cl_getmsg('asf-180',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfa05",g_msg CLIPPED) 
       CALL cl_getmsg('asf-176',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sic04",g_msg CLIPPED)
       CALL cl_getmsg('asf-182',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sic15",g_msg CLIPPED)
       CALL i610_sia05()
    END IF
    IF g_argv1 = '1' THEN
       CALL i610_sia05()
       CALL cl_set_comp_visible("sic15",FALSE)
    END IF
#FUN-AC0074 --------------------End----------------------
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0' 
 
    IF NOT cl_null(g_argv2) THEN
       CASE g_argv3
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i610_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i610_a()
             END IF
          OTHERWISE
             CALL i610_q()
       END CASE
    END IF
 
    CALL i610_menu()
 
END FUNCTION
 
FUNCTION i610_cs()
DEFINE l_buf   LIKE type_file.chr1000 
DEFINE l_length,l_i LIKE type_file.num5    
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    
DEFINE m_sia05      LIKE sia_file.sia05  #FUN-AC0074

   IF cl_null(g_argv3) THEN 
    CLEAR FORM                             #清除畫面
    CALL g_sib.clear()
    CALL g_sic.clear()
    CALL cl_set_head_visible("","YES")  
   INITIALIZE g_sia.* TO NULL    
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
       sia01,sia02,sia03,sia04,sia06,sia07,sia08,siaconf, 
       siauser,siagrup,siamodu,siadate ,siaacti,siaorig,siaoriu
       ,sia05    #FUN-AC0074 add sia05
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
          CASE WHEN INFIELD(sia01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
               #FUN-AC0074 ---------Begin------------------
                    IF g_argv1 = '1' THEN
                       LET g_qryparam.where = "sia05 IN ('1','2')"
                    END IF   
                    IF g_argv1 = '2' THEN
                       LET g_qryparam.where = "sia05 ='3'"
                    END IF
                    IF g_argv1 = '3' THEN
                       LET g_qryparam.where = "sia05 IN ('4','5')"
                    END IF
               #FUN-AC0074 ---------End-------------------- 
                    LET g_qryparam.form   = "q_sia"
                    #LET g_qryparam.arg1 = g_argv1 CLIPPED
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sia01
                    NEXT FIELD sia01
               WHEN INFIELD(sia06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sia06
                    NEXT FIELD sia06
               WHEN INFIELD(sia07)   #料表批號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form ="q_sfc"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sia07
                    NEXT FIELD sia07
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
		              CALL cl_qbe_list() RETURNING lc_qbe_sn
		              CALL cl_qbe_display_condition(lc_qbe_sn)
       CALL GET_FLDBUF(sia05) RETURNING m_sia05    #FUN-AC0074
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('siauser', 'siagrup')
 
 
   #IF g_argv1='1' THEN        #FUN-AC0074
    IF g_sia.sia04 = '1' THEN  #FUN-AC0074
       LET g_wc = g_wc clipped," AND sia04 = '1' " 
    END IF
   #IF g_argv1='2' THEN        #FUN-AC0074
    IF g_sia.sia04 = '2' THEN  #FUN-AC0074
      LET g_wc = g_wc clipped," AND sia04 = '2' "
    END IF
 
#FUN-AC0074 -----------------Begin-------------------------
    IF cl_null(m_sia05) THEN
       IF g_argv1='1' THEN
          LET g_wc = g_wc clipped," AND sia05 IN ('1','2')"
       END IF
       IF g_argv1='2' THEN
          LET g_wc = g_wc clipped," AND sia05 = '3'"
       END IF 
       IF g_argv1='3' THEN
          LET g_wc = g_wc clipped," AND sia05 IN ('4','5')"
       END IF
    END IF
#FUN-AC0074 -----------------End---------------------------
 
    CONSTRUCT g_wc2 ON sib02,sib04,sib03  
         FROM s_sib[1].sib02,s_sib[1].sib04,s_sib[1].sib03 
  
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION controlp
            CASE WHEN INFIELD(sib02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sfb" 
                      LET g_qryparam.state    = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sib02
                      NEXT FIELD sib02
                 WHEN INFIELD(sib04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_eci"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sib04
                      NEXT FIELD sib04
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
 
#   CONSTRUCT g_wc3 ON sic02,sic03,sic04,sic05,sic11,sic06,                  #FUN-B20009      
#   CONSTRUCT g_wc3 ON sic02,sic03,sic04,sic05,sic012,sic11,sic013,sic06,    #FUN-B20009  #FUN-AC0074
    CONSTRUCT g_wc3 ON sic02,sic03,sic15,sic05,sic04,sic012,sic11,sic013,sic06,           #FUN-AC0074   
              #        sic07,sic08,sic09,sic10                   #FUN-AC0074
                       sic07,sic07_fac,sic08,sic09,sic10,sic16   #FUN-AC0074  
              #   FROM s_sic[1].sic02,s_sic[1].sic03,s_sic[1].sic04,                    #FUN-AC0074
                  FROM s_sic[1].sic02,s_sic[1].sic03,s_sic[1].sic15,s_sic[1].sic04,     #FUN-AC0074
                  #    s_sic[1].sic05,s_sic[1].sic11,s_sic[1].sic06,s_sic[1].sic07,     #FUN-B20009
                       s_sic[1].sic05,s_sic[1].sic012,s_sic[1].sic11,s_sic[1].sic013,   #FUN-B20009
                       s_sic[1].sic06,s_sic[1].sic07,                                   #FUN-B20009      
                       s_sic[1].sic07_fac,             #FUN-AC0074
                       s_sic[1].sic08,s_sic[1].sic09,
                       s_sic[1].sic10,s_sic[1].sic16   #FUN-AC0074  add sic16
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp
           CASE WHEN INFIELD(sic05)
#FUN-AA0059---------mod------------str-----------------           
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state  = "c"
#                     LET g_qryparam.form ="q_ima"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO sic05
                     NEXT FIELD sic05
                WHEN INFIELD(sic04)
#FUN-AA0059---------mod------------str-----------------                  
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state  = "c"
#                     LET g_qryparam.form ="q_ima"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO sic04
                     NEXT FIELD sic04
                WHEN INFIELD(sic03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                    #FUN-AC0074 ----------Begin-------------
                    #LET g_qryparam.form ="q_sfb"
                     IF g_argv1 = '2 ' THEN
                        LET g_qryparam.form ="q_oeb01"
                     END IF 
                     IF g_argv1 = '3' THEN
                        IF g_sia.sia05 = '5' THEN
                           LET g_qryparam.form ="q_imn01"
                        ELSE
                           LET g_qryparam.form ="q_inb02"
                        END IF
                     END IF
                     IF g_argv1 = '1' THEN
                        LET g_qryparam.form ="q_sfb"
                     END IF
                    #FUN-AC0074 ----------End----------------
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sic03
                     NEXT FIELD sic03
                WHEN INFIELD(sic08)
                    #Mod No.FUN-AB0046
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_imd"
                    #LET g_qryparam.state    = "c"
                    #LET g_qryparam.arg1     = "SW"   
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                          RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AB0046
                     DISPLAY g_qryparam.multiret TO sic08
                     NEXT FIELD sic08
                #TQC-DB0048--add--str--
                WHEN INFIELD(sic09)
                   CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sic09
                   NEXT FIELD sic09
                #TQC-DB0048--add--end
                WHEN INFIELD(sic10)
                    #Mod No.FUN-AB0046
                    CALL cl_init_qry_var()             #TQC-DB0048 unmark
                    #LET g_qryparam.form     = "q_ime"
                    LET g_qryparam.form='q_sic10'      #TQC-DB0048
                    LET g_qryparam.state="c"           #TQC-DB0048 unmark
                    CALL cl_create_qry() RETURNING g_qryparam.multiret #TQC-DB0048 unmark
                    #CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") #TQC-DB0048 mark
                    #     RETURNING g_qryparam.multiret                #TQC-DB0048 mark
                    #End Mod No.FUN-AB0046
                     DISPLAY g_qryparam.multiret TO sic10 
                     NEXT FIELD sic10 
                WHEN INFIELD(sic07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sic07  
                     NEXT FIELD sic07
#FUN-B20009 --------------------------Begin--------------------------------------
               WHEN INFIELD(sic012)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   = "q_sic"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sic012
                    NEXT FIELD sic012
               WHEN INFIELD(sic013)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   = "q_sic01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sic013
                    NEXT FIELD sic013
#FUN-B20009 --------------------------End----------------------------------------
               WHEN INFIELD(sic11)
                  CALL q_ecd(TRUE,TRUE,g_sic[1].sic11)
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sic11
                  NEXT FIELD sic11
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    LET l_length = LENGTH(g_wc3)
   ELSE 
    #TQC-B60298(S)
    IF g_argv1 = '2' THEN
       LET g_wc = " 1=1 AND sia05 = '3'"
       LET g_wc2 = " 1=1"
       LET g_wc3 = " sic03 = '",g_argv2,"'"
    ELSE
    #TQC-B60298(E)
       LET g_wc = " sia01 = '",g_argv3,"'"
       LET g_wc2 = " 1=1"
       LET g_wc3 = " 1=1"
    END IF #TQC-B60298
   
   END IF 
  CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT sia01 FROM sia_file",                        
                          " WHERE ", g_wc CLIPPED,
                          " ORDER BY sia01"
         WHEN g_wc2 <> " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT UNIQUE sia01 ",                             
                          "  FROM sia_file, sib_file",
                          " WHERE sia01 = sib01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                          " ORDER BY sia01"
         WHEN g_wc2 = " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE sia01 ",                              
                          "  FROM sia_file, sic_file",
                          " WHERE sia01 = sic01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY sia01 "
                          #--
         WHEN g_wc2 <> " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE sia01 ",                              
                          "  FROM sia_file, sic_file, sib_file",
                          " WHERE sia01 = sic01 AND sia01=sib01",
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY sia01 "
                          #--
    END CASE
    PREPARE i610_prepare FROM g_sql
    DECLARE i610_cs                         
        SCROLL CURSOR WITH HOLD FOR i610_prepare
    DISPLAY "g_sql",g_sql
    CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT UNIQUE sia01 FROM sia_file WHERE ",g_wc CLIPPED
         WHEN g_wc2 != " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT UNIQUE sia01 FROM sia_file,sib_file WHERE ",
                        "sib01=sia01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         WHEN g_wc2 = " 1=1" AND g_wc3 != " 1=1"
              LET g_sql = "SELECT UNIQUE sia01 ",
                          "  FROM sia_file, sic_file",
                          " WHERE sia01 = sic01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
                          #--
         WHEN g_wc2 != " 1=1" AND g_wc3 != " 1=1"
              LET g_sql = "SELECT UNIQUE sia01 ",
                          "  FROM sia_file, sic_file, sib_file ",
                          " WHERE sia01 = sic01 AND sia01=sib01",
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED
        OTHERWISE
              LET g_sql="SELECT UNIQUE sia01 FROM sia_file WHERE ",g_wc CLIPPED
        EXIT CASE
    END CASE
    PREPARE i610_precount FROM g_sql
    DECLARE i610_count CURSOR FOR i610_precount
END FUNCTION
 
FUNCTION i610_menu()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_fac   LIKE ima_file.ima31_fac  
   WHILE TRUE
      CALL i610_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i610_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i610_q()
            END IF
         WHEN "delete"   
            IF cl_chk_act_auth() THEN
               CALL i610_r()
            END IF
         WHEN "modify"   
            IF cl_chk_act_auth() THEN
               CALL i610_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i610_b()
            ELSE
               LET g_action_choice = ""
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i610_y_chk()
               IF g_success = "Y" THEN
                  CALL i610_y_upd()
                  IF g_sia.siaconf='X' THEN  
                     LET g_chr='Y' 
                  ELSE 
                     LET g_chr='N' 
                  END IF  
                  DISPLAY BY NAME g_sia.siaconf
                  DISPLAY BY NAME g_sia.sia03    #FUN-D20059 Add
                  CALL i610_pic() #圖形顯示
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
            #  CALL i610sub_w(g_sia.sia01,g_action_choice,TRUE)            #FUN-AC0074
               CALL i610sub_w(g_sia.sia01,g_action_choice,TRUE,g_argv1)    #FUN-AC0074   
               CALL i610sub_refresh(g_sia.sia01) RETURNING g_sia.*  
               CALL i610_show()  
            END IF
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_sib),
                                      base.TypeInfo.create(g_sic),'')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_sia.sia01 IS NOT NULL THEN
                 LET g_doc.column1 = "sia01"
                 LET g_doc.value1 = g_sia.sia01
                 CALL cl_doc()
               END IF
              END IF
                           
      END CASE
 
 END WHILE
 CLOSE i610_cs
 
END FUNCTION
 
FUNCTION i610_a()
    DEFINE li_result   LIKE type_file.num5         
    DEFINE l_cnt1      LIKE type_file.num5  
    IF s_shut(0) THEN RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_sib.clear()
    CALL g_sic.clear()
    INITIALIZE g_sia.* TO NULL
    LET g_sia_o.* = g_sia.*
    LET g_sia_t.* = g_sia.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sia.sia02  =g_today
        LET g_sia.sia03  =g_today  
        LET g_sia.siaconf='N' 
        LET g_sia.sia08  = ' ' 
        LET g_sia.sia09  =''
        LET g_sia.siaacti = 'Y' 
        LET g_sia.siauser=g_user  
        LET g_sia.siaoriu = g_user 
        LET g_sia.siaorig = g_grup 
        LET g_data_plant = g_plant 
        LET g_sia.siagrup=g_grup  
        LET g_sia.siadate=g_today 
        LET g_sia.sia06  =g_grup
 
        LET g_sia.siaplant = g_plant 
        LET g_sia.sialegal = g_legal
        #FUN-AC0074 ------Begin----------
        LET g_sia.sia04 = '1'
        IF g_argv1 = '2' THEN
           LET g_sia.sia05 = '3'
           DISPLAY BY NAME g_sia.sia05
        END IF
        IF g_argv1 = '3' THEN
           LET g_sia.sia05 = '4'
           DISPLAY BY NAME g_sia.sia05
        END IF
        IF g_argv1 = '1' THEN
           LET g_sia.sia05 = '1'
           DISPLAY BY NAME g_sia.sia05
        END IF
        #FUN-AC0074 ------End------------

       #IF g_argv1<>' ' AND NOT cl_null(g_argv1) THEN LET g_sia.sia04 = g_argv1  END IF   #FUN-AC0074
        IF g_argv1 = '1' AND g_sia.sia04 = '2' THEN LET g_sia.sia05 = '2' END IF 
        CALL i610_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_sia.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_sia.sia01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK     
        CALL s_auto_assign_no("asf",g_sia.sia01,g_sia.sia02,"","sia_file","sia01","","","")
        RETURNING li_result,g_sia.sia01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sia.sia01,g_sia.sia06  
 
        INSERT INTO sia_file VALUES (g_sia.*)
        IF STATUS THEN
           CALL cl_err3("ins","sia_file",g_sia.sia01,"",STATUS,"","",1)  
           ROLLBACK WORK   
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_sia.sia01,'I')
 
        LET g_sia_t.* = g_sia.*
        LET g_rec_d = 0
        CALL g_sib.clear()
        CALL i610_d()                   #輸入單身-sib
 
        IF g_success = "N" THEN
           EXIT WHILE
        END IF
 
        LET g_rec_b =0
        CALL g_sic.clear()
        CALL i610_b_fill(" 1=1")
        CALL i610_b()  #輸入單身-sic 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i610_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sia.sia01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sia.* FROM sia_file WHERE sia01=g_sia.sia01
    IF g_sia.siaconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF 
    IF g_sia.siaconf = 'X'   THEN CALL cl_err('','9024',1) RETURN END IF 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sia_o.* = g_sia.*

    CALL cl_set_comp_entry("sia05",FALSE) #FUN-AC0074
 
    BEGIN WORK
 
    OPEN i610_cl USING g_sia.sia01                 
    IF STATUS THEN
       CALL cl_err("OPEN i610_cl:", STATUS, 1)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i610_cl INTO g_sia.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sia.sia01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i610_cl ROLLBACK WORK RETURN
    END IF
    CALL i610_show()
    WHILE TRUE
        LET g_sia.siamodu=g_user              
        LET g_sia.siadate=g_today             
        CALL i610_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sia.*=g_sia_t.*
            CALL i610_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE sia_file SET * = g_sia.* WHERE sia01 = g_sia_o.sia01      
        IF STATUS THEN 
           CALL cl_err3("upd","sia_file",g_sia_t.sia01,"",STATUS,"","",1)  
           CONTINUE WHILE END IF
        IF g_sia.sia01 != g_sia_t.sia01 THEN CALL i610_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i610_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sia.sia01,'U')
 
END FUNCTION
 
FUNCTION i610_chkkey()
    UPDATE sic_file SET sic01=g_sia.sia01 WHERE sic01=g_sia_t.sia01
    IF STATUS THEN
       CALL cl_err3("upd","sic_file",g_sia_t.sia01,"",STATUS,"","upd sic01",1)  
       LET g_sia.*=g_sia_t.* CALL i610_show() ROLLBACK WORK RETURN
    END IF
    UPDATE sib_file SET sib01=g_sia.sia01 WHERE sib01=g_sia_t.sia01
    IF STATUS THEN
       CALL cl_err3("upd","sib_file",g_sia_t.sia01,"",STATUS,"","upd sib01",1) 
       LET g_sia.*=g_sia_t.* CALL i610_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION i610_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改  
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  
  DEFINE li_result       LIKE type_file.num5                
  DEFINE l_azf03         LIKE azf_file.azf03  
  DEFINE l_azfacti       LIKE azf_file.azfacti 
  DEFINE l_n             LIKE type_file.num5   
  DEFINE l_azf09         LIKE azf_file.azf09   
  DEFINE l_slip          LIKE smy_file.smyslip
  DEFINE l_sia04         LIKE sia_file.sia06   
  DEFINE l_smy72         LIKE smy_file.smy72   
  DEFINE l_gem02         LIKE gem_file.gem02
  DEFINE l_count         LIKE type_file.num5   #FUN-A90035 ADD
  DEFINE l_sql           STRING  #MOD-AC0385
  
    CALL cl_set_head_visible("","YES")  
    INPUT BY NAME  g_sia.sia01,g_sia.sia02,g_sia.sia03,g_sia.sia05, g_sia.siaconf,
        g_sia.sia04,g_sia.sia06,g_sia.sia07,g_sia.sia08,
        g_sia.siauser,g_sia.siagrup,g_sia.siaacti,    
        g_sia.siamodu,g_sia.siadate,                 
        g_sia.siaoriu,g_sia.siaorig

        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i610_set_entry(p_cmd)
            CALL i610_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("sia01")
 
        AFTER FIELD sia01
            IF NOT cl_null(g_sia.sia01) THEN
            #FUN-AC0074 -------------Begin---------------
            #  CASE WHEN g_argv1 = "1" LET g_chr='5'
            #       WHEN g_argv1 = "2" LET g_chr='6'
               CASE WHEN g_sia.sia04 = '1' LET g_chr='5'
                    WHEN g_sia.sia04 = '2' LET g_chr='5'
            #FUN-AC0074 -------------End---------------- 
                  #OTHERWISE
                         #      LET g_chr='5' 
               END CASE
               IF g_sia.sia01 != g_sia_t.sia01 OR g_sia_t.sia01 IS NULL THEN
            CALL s_check_no("asf",g_sia.sia01,g_sia_t.sia01,g_chr,"sia_file","sia01","")
            RETURNING li_result,g_sia.sia01
            DISPLAY BY NAME g_sia.sia01
            IF (NOT li_result) THEN
               LET g_sia.sia01=g_sia_o.sia01
               NEXT FIELD sia01
            END IF
               END IF
            END IF
{            IF cl_null(g_sia_t.sia01) THEN
               CALL s_get_doc_no(g_sia.sia01) RETURNING l_slip                                                                 
                    SELECT smy72 INTO l_sia04 FROM smy_file                                                                     
                     WHERE smyslip = l_slip                                                                                         
               IF cl_null(l_sia04) THEN
                  LET l_sia04 = ' '
               END IF
               IF l_sia04 <> g_sia.sia04 THEN
                  CALL cl_err('','asm-145',1)
                  NEXT FIELD sia01
               END IF
            END IF
}
        AFTER FIELD sia02
            IF  cl_null(g_sia.sia02) THEN
              	 NEXT FIELD g_sia.sia02
            END IF

        AFTER FIELD sia04 
            IF NOT cl_null(g_sia.sia04) THEN
               IF g_argv1 = '1' THEN        #FUN-AC0074
                  IF g_sia.sia04 = '2' THEN
                     LET g_sia.sia05 ='2' 
                     CALL cl_set_comp_entry("sia05",FALSE)
                     DISPLAY g_sia.sia05 TO sia05
                  ELSE                                      #FUN-AC0074 
                     CALL cl_set_comp_entry("sia05",TRUE)   #FUN-AC0074
                  END IF    
               ELSE      #FUN-AC0074
                  DISPLAY g_sia.sia05 TO sia05   #FUN-AC0074 
               END IF    #FUN-AC0074
            END IF 

        AFTER FIELD sia05
           IF NOT cl_null(g_sia.sia05) THEN
           #  IF g_sia.sia05 NOT MATCHES '[12]' THEN      #FUN-AC0074
              IF  g_sia.sia05 NOT MATCHES '[12345]' THEN   #FUN-AC0074 
                  NEXT FIELD sia05
              END IF
           ELSE
              NEXT FIELD sia05               
           END IF
   
          AFTER FIELD sia06 
            IF NOT cl_null(g_sia.sia06) THEN
               SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_sia.sia06
                   AND gemacti = 'Y'
          #TQC-C60207 -----------Begin----------
               IF STATUS THEN
                  CALL cl_err(g_sia.sia06,'asf-683',0)
                  NEXT FIELD sia06
               END IF
          #TQC-C60207 -----------End------------
               DISPLAY l_gem02 TO gem02
            END IF
 
        #FUN-A90035 ----------------add start-------------------
        AFTER FIELD sia07
          IF NOT cl_null(g_sia.sia07) THEN
             SELECT count(*) INTO l_count FROM sfd_file WHERE sfd01 = g_sia.sia07 AND sfdconf = 'Y' 
             IF cl_null(l_count) OR l_count = 0 THEN
                CALL cl_err('','asf-772',0) 
                NEXT FIELD sia07
             END IF
          END IF 
        #FUN-A90035 --------------add end------------------------   
        AFTER INPUT 
           LET g_sia.siauser = s_get_data_owner("sia_file") #FUN-C10039
           LET g_sia.siagrup = s_get_data_group("sia_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT      
         END IF

        ON ACTION controlp
           CASE WHEN INFIELD(sia01) #查詢單据
                    LET l_sql=''  #MOD-AC0385
                    LET g_t1=s_get_doc_no(g_sia.sia01)     
                    #FUN-AC0074 ---------------Begin----------------
		    #       CASE WHEN g_argv1 = "1" LET g_chr='5'
		    #            WHEN g_argv1 = "2" LET g_chr='6'
                            CASE WHEN g_sia.sia04 = '1' LET g_chr='5'
                                 WHEN g_sia.sia04 = '2' LET g_chr='5'
                    #FUN-AC0074 ---------------End------------------
                            OTHERWISE  
                              LET l_sql= "(smykind='5' OR smykind='6')"   #MOD-AC0385
		            END CASE
                    IF l_sql IS NULL OR l_sql=' ' THEN                    #MOD-AC0385
                        LET l_sql = " (smy73 <> 'Y' OR smy73 is null)"    #MOD-AC0385
                    ELSE
                        LET l_sql = l_sql,"AND (smy73 <> 'Y' OR smy73 is null)"  #MOD-AC0385
                    END IF  
                    CALL smy_qry_set_par_where(l_sql)   #MOD-AC0385
                    CALL q_smy( FALSE, TRUE,g_t1,'ASF',g_chr) RETURNING g_t1   
                    LET g_sia.sia01 = g_t1                
                    DISPLAY BY NAME g_sia.sia01
                    NEXT FIELD sia01
               WHEN INFIELD(sia06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_sia.sia06
                    CALL cl_create_qry() RETURNING g_sia.sia06  
                    DISPLAY BY NAME g_sia.sia06  
                    NEXT FIELD sia06
               WHEN INFIELD(sia07)   #料表批號
                    CALL cl_init_qry_var()
                  # LET g_qryparam.form ="q_sfc"       #FUN-A90035 mark
                    LET g_qryparam.form ="q_sfd"       #FUN-A90035 add
                    LET g_qryparam.default1 = g_sia.sia07
                    CALL cl_create_qry() RETURNING g_sia.sia07 
                    DISPLAY BY NAME g_sia.sia07  
                    NEXT FIELD sia07
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
	#ON ACTION CONTROLZ  #TQC-C50082 mark
        ON ACTION CONTROLR   #TQC-C50082 add
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION

#FUN-AC0074 ---------------Begin-------------------
FUNCTION i610_sia05()
   DEFINE lcbo_target ui.ComboBox
   IF g_argv1 = '1' THEN
      LET lcbo_target = ui.ComboBox.forName("sia05")
      CALL lcbo_target.RemoveItem("3")
      CALL lcbo_target.RemoveItem("4")
      CALL lcbo_target.RemoveItem("5")
   END IF
   IF g_argv1 = '2' THEN
      LET lcbo_target = ui.ComboBox.forName("sia05")
      CALL lcbo_target.RemoveItem("1")
      CALL lcbo_target.RemoveItem("2")
      CALL lcbo_target.RemoveItem("4")
      CALL lcbo_target.RemoveItem("5")
   END IF
   IF g_argv1 = '3' THEN
      LET lcbo_target = ui.ComboBox.forName("sia05")
      CALL lcbo_target.RemoveItem("1")
      CALL lcbo_target.RemoveItem("2")
      CALL lcbo_target.RemoveItem("3")
   END IF 
    
END FUNCTION
#FUN-AC0074 ---------------End---------------------
 
FUNCTION i610_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sia01",TRUE)
       CALL cl_set_comp_entry("sia04",TRUE)    #FUN-AC0074
    END IF
   
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfa04",TRUE)
    END IF 
END FUNCTION
 
FUNCTION i610_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("sia01",FALSE)
    END IF
   
    IF INFIELD(sia04) OR (NOT g_before_input_done) THEN
    #  IF g_argv1<>' ' OR (NOT cl_null(g_argv1))  OR p_cmd = 'u' THEN   #FUN-AC0074
       IF p_cmd = 'u' THEN                        #FUN-AC0074       
          CALL cl_set_comp_entry("sia04",FALSE)
       END IF
    END IF
   
   #IF g_argv1 = '2' THEN       #FUN-AC0074
    IF g_sia.sia04 = '2' THEN   #FUN-AC0074
       LET g_sia.sia05 = '2'
       CALL cl_set_comp_entry("sia05",FALSE)
    END IF 
END FUNCTION
 
FUNCTION i610_q()
 
  DEFINE  l_sia01     LIKE sia_file.sia01
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sia.* to NULL              
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
    INITIALIZE g_sia.* to NULL              
    CALL i610_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_sia.* TO NULL RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sia.* TO NULL
    ELSE
        LET g_row_count=0
        FOREACH i610_count INTO l_sia01
            LET g_row_count=g_row_count +1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
 
        CALL i610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  
    l_abso          LIKE type_file.num10                 #絕對的筆數  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i610_cs INTO g_sia.sia01                  
        WHEN 'P' FETCH PREVIOUS i610_cs INTO g_sia.sia01                 
        WHEN 'F' FETCH FIRST    i610_cs INTO g_sia.sia01                 
        WHEN 'L' FETCH LAST     i610_cs INTO g_sia.sia01                 
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i610_cs INTO g_sia.sia01               
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        INITIALIZE g_sia.* TO NULL
        CALL cl_err(g_sia.sia01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_sia.* FROM sia_file WHERE sia01 = g_sia.sia01           

    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sia_file",g_sia.sia01,"",SQLCA.sqlcode,"","",1)  
       INITIALIZE g_sia.* TO NULL
    ELSE
       LET g_data_owner = g_sia.siauser      
       LET g_data_group = g_sia.siagrup      
       LET g_data_plant = g_sia.siaplant 
       CALL i610_show()
    END IF
 
END FUNCTION
 
FUNCTION i610_show()
    DEFINE l_gem02 LIKE gem_file.gem02
    DEFINE l_smydesc LIKE smy_file.smydesc  
    DEFINE l_azf03 LIKE azf_file.azf03 
 
    LET g_sia_t.* = g_sia.*                #保存單頭舊值
    DISPLAY BY NAME g_sia.siaoriu,g_sia.siaorig,
        g_sia.sia01,g_sia.sia02,
        g_sia.sia03,g_sia.sia05,g_sia.sia04,
        g_sia.sia06,g_sia.sia07,g_sia.siaconf,g_sia.sia08,  
        g_sia.siauser,g_sia.siagrup,    
        g_sia.siamodu,g_sia.siadate,g_sia.siaacti                
 
    LET g_buf = s_get_doc_no(g_sia.sia01)     
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf 
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_sia.sia06
    DISPLAY l_gem02 TO gem02
    CALL i610_pic() #圖形顯示
    CALL i610_d_fill(g_wc2)
 
    CALL i610_b_fill(g_wc3)
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i610_r()
  DEFINE l_chr,l_sure LIKE type_file.chr1,    
         l_sic        RECORD LIKE sic_file.*
  DEFINE l_imm03  LIKE imm_file.imm03
  DEFINE l_sia01  LIKE sia_file.sia01,
         l_cnt    LIKE type_file.num10        
  DEFINE l_i      LIKE type_file.num5         
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sia.sia01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sia.* FROM sia_file WHERE sia01=g_sia.sia01
    IF g_sia.siaconf = 'Y'   THEN CALL cl_err('','9023',0) RETURN END IF 
    IF g_sia.siaconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF 
 
    BEGIN WORK
 
    OPEN i610_cl USING g_sia.sia01                     
    IF STATUS THEN
       CALL cl_err("OPEN i610_cl:", STATUS, 1)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i610_cl INTO g_sia.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sia.sia01,SQLCA.sqlcode,0)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL i610_show()
 
    IF cl_delh(20,16) THEN
        MESSAGE "Delete sia,sic!"
        DELETE FROM sia_file WHERE sia01 = g_sia.sia01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","sia_file",g_sia.sia01,"",SQLCA.SQLCODE,"","No sia deleted",1)  
           ROLLBACK WORK RETURN
        END IF
 
        DELETE FROM sib_file WHERE sib01 = g_sia.sia01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","sib_file",g_sia.sia01,"",STATUS,"","del sib",1)  
           ROLLBACK WORK RETURN
        END IF

        DELETE FROM sic_file WHERE sic01 = g_sia.sia01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","sic_file",g_sia.sia01,"",STATUS,"","del sic",1)  
           ROLLBACK WORK RETURN
        END IF
  
        CLEAR FORM
        CALL g_sib.clear()
        CALL g_sic.clear()
 
    	INITIALIZE g_sia.* TO NULL
        MESSAGE ""
        LET g_row_count=0
        FOREACH i610_count INTO l_sia01
            LET g_row_count=g_row_count +1
        END FOREACH
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i610_cs
           CLOSE i610_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        OPEN i610_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i610_fetch('L')
        ELSE
           IF g_curs_index>0 THEN 
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i610_fetch('/')
           ELSE
              CALL cl_err('','asf-079',0) 
           END IF
        END IF
 
    END IF
 
    CLOSE i610_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sia.sia01,'D')
 
END FUNCTION
 
FUNCTION i610_d()
   DEFINE l_cnt,l_cnt_1  LIKE type_file.num5    
 
   IF  cl_null(g_sia.sia01) THEN RETURN END IF   
   LET g_success = 'Y'  
   IF g_sia.sia04 NOT MATCHES '[12]' THEN RETURN END IF
   IF g_sia.sia05 NOT MATCHES '[1]' THEN RETURN END IF  
   IF g_sia.siaconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF 
   IF g_sia.siaconf = 'X' THEN CALL cl_err('','9024',1) RETURN END IF 
 
  WHILE TRUE
   CALL i610_d_i()
   CALL i610_d_fill(' 1=1')
 
   LET l_cnt = 0
   LET l_cnt_1 = 0
   SELECT COUNT(*) INTO l_cnt FROM sib_file
    WHERE sib01 = g_sia.sia01
   SELECT COUNT(*) INTO l_cnt_1 FROM sic_file
    WHERE sic01 = g_sia.sia01
  #IF g_argv1 = '1' AND l_cnt=0 THEN      #FUN-AC0074
   IF g_sia.sia04 = '1' AND l_cnt=0 THEN  #FUN-AC0074 
      IF NOT cl_confirm('sia-001') THEN
         #未輸入單身資料,則取消單頭資料
      #  IF g_argv1 = '1' AND l_cnt=0 AND l_cnt_1 = 0 THEN      #FUN-AC0074
         IF g_sia.sia04 = '1' AND l_cnt=0 AND l_cnt_1 = 0 THEN  #FUN-AC0074
            IF cl_confirm('9042') THEN
               DELETE FROM sia_file WHERE sia01 = g_sia.sia01
               LET g_cnt=0
               CLEAR FORM
               CALL g_sib.clear()
               CALL g_sic.clear()
               LET g_success = 'N'
            END IF
         END IF
         LET g_success = 'N'
         EXIT WHILE
      END IF
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
END FUNCTION
 
FUNCTION i610_d_i()
   DEFINE i,j           LIKE type_file.num5    
   DEFINE l_cnt         LIKE type_file.num5    
   DEFINE qty1,qty2	LIKE sib_file.sib03    
   DEFINE unissue_qty	LIKE sfb_file.sfb08,   
          l_qty         LIKE sre_file.sre07,   
          l_tot         LIKE img_file.img10    
   DEFINE l_sfb08 	LIKE sfb_file.sfb08    
   DEFINE l_sfb23 	LIKE type_file.chr1    
   DEFINE l_sfb04	LIKE type_file.chr1    
   DEFINE l_sfb02	LIKE sfb_file.sfb02
   DEFINE l_sfb06	LIKE sfb_file.sfb06,
          l_sfb09       LIKE sfb_file.sfb09,
          l_sfb81       LIKE sfb_file.sfb81,
          l_sib03       LIKE sib_file.sib03,
          l_sib02_t     LIKE sib_file.sib02,
          l_sib03_t     LIKE sib_file.sib03,
          l_sib03_o     LIKE sib_file.sib03,   
          l_sib03_r     LIKE sib_file.sib03,
          l_allow_insert   LIKE type_file.num5,                #可新增否  
          l_allow_delete   LIKE type_file.num5                 #可刪除否  
   DEFINE l_str         STRING 
   DEFINE l_sfa062      LIKE sfa_file.sfa062 
   DEFINE l_sfa03       LIKE sfa_file.sfa03
   DEFINE l_sfa08       LIKE sfa_file.sfa08
   DEFINE l_sfa12       LIKE sfa_file.sfa12
   DEFINE l_sfa27       LIKE sfa_file.sfa27
   DEFINE l_sfa05       LIKE sfa_file.sfa05   
   DEFINE l_pmm01       LIKE pmm_file.pmm01    
   DEFINE l_ima56       LIKE ima_file.ima56   
   DEFINE l_faqty       LIKE ima_file.ima56   
   DEFINE l_per         LIKE type_file.num5   
   DEFINE l_qty1        LIKE sib_file.sib03   
   DEFINE l_qty2        LIKE sib_file.sib03   
   DEFINE l_sfb081 	    LIKE sfb_file.sfb081  
  
   LET g_flag_sib03=0     
 
   SELECT COUNT(*) INTO i FROM sib_file WHERE sib01=g_sia.sia01
   IF NOT cl_null(g_sia.sia07) THEN
      IF i=0 THEN
         DECLARE i610_s_sib_c CURSOR FOR         
           SELECT sfd03,'',sfb05,'','',0    
              FROM sfd_file,sfb_file 
             WHERE sfd01=g_sia.sia07 AND sfd03=sfb01
              AND sfb87 = 'Y'           
         CALL g_sib.clear()
         LET i=1
        FOREACH i610_s_sib_c INTO g_sib[i].sib02,
                                  g_sib[i].sib04,
                                  g_sib[i].sfb05,
                                  g_sib[i].ima02,
                                  g_sib[i].ima021,
                                  g_sib[i].sib03
           IF STATUS THEN
             CALL cl_err('fore sfd:',STATUS,1)  
              EXIT FOREACH
           END IF
           SELECT ima02,ima021 INTO g_sib[i].ima02, g_sib[i].ima021
             FROM ima_file WHERE ima01=g_sib[i].sfb05
           LET i=i+1
         END FOREACH
         CALL g_sib.deleteElement(i)
         LET i = i - 1
      END IF
   END IF

 
   BEGIN WORK
 
   OPEN i610_cl USING g_sia.sia01                     
   IF STATUS THEN
      CALL cl_err("OPEN i610_cl:", STATUS, 1)
      CLOSE i610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i610_cl INTO g_sia.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sia.sia01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i610_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_sia.siamodu=g_user              
   LET g_sia.siadate=g_today             
   DISPLAY BY NAME g_sia.siamodu         
   DISPLAY BY NAME g_sia.siadate         
 
 
   LET g_success='Y'
   LET l_sib02_t = NULL
 
   DISPLAY ARRAY g_sib TO s_sib.* ATTRIBUTE(COUNT=i,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
   END DISPLAY
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_sib WITHOUT DEFAULTS FROM s_sib.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
 
      BEFORE ROW
         LET i = ARR_CURR()
         LET l_sib02_t = g_sib[i].sib02   
         NEXT FIELD sib02
 
      BEFORE DELETE
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM sic_file  
               WHERE sic01 = g_sia.sia01
                 AND sic03 = g_sib[i].sib02
 
       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       IF l_cnt > 0 THEN
          CALL cl_err (g_sib[i].sib02,'sib-001',1)
          CANCEL DELETE
          NEXT FIELD sib02
       END IF

      AFTER FIELD sib02
         IF NOT cl_null(g_sib[i].sib02) THEN
          IF g_sia.sia04 = '2' THEN
             SELECT COUNT(*) INTO l_cnt FROM sie_file WHERE sie05 = g_sib[i].sib02 AND sie11 > 0 
             IF l_cnt <= 0 THEN 
                CALL cl_err(g_sib[i].sib02,'sib-010',0)
                NEXT FIELD sib02
             END IF 
          END IF 
            CALL i610_sfb01(g_sib[i].sib02)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sib[i].sib02,g_errno,0)
               NEXT FIELD sib02
            END IF
            SELECT sfb02 INTO l_sfb02 FROM sfb_file
             WHERE sfb01=g_sib[i].sib02
            IF l_sfb02 = '15' THEN
               CALL cl_err(g_sib[i].sib02,'asr-047',1)   #所輸入之工單型態
               NEXT FIELD sib02
            END IF
 
            SELECT sfb02 INTO l_sfb02 FROM sfb_file
             WHERE sfb01 = g_sib[i].sib02
            IF l_sfb02 = '7' OR l_sfb02 = '8' THEN 
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM pmm_file,pmn_file
                WHERE pmm01 = pmn01
                  AND pmn41 = g_sib[i].sib02
                  AND pmm18 = 'Y'
                  AND (pmm25 != '6' OR pmm25 != '9')
               IF cl_null(l_cnt)  OR l_cnt = 0 THEN 
                  CALL cl_err('','sib-002',0)
                  NEXT FIELD sib02
               END IF    
            END IF 
 
            SELECT sfb05,sfb04,sfb23,sfb08,sfb06,sfb81,sfb02
              INTO g_sib[i].sfb05, l_sfb04, l_sfb23, l_sfb08,
                   l_sfb06,l_sfb81,l_sfb02
              FROM sfb_file
             WHERE sfb01 = g_sib[i].sib02
               AND sfb87 ='Y'
 
            IF STATUS THEN
               CALL cl_err3("sel","sfb_file",g_sib[i].sib02,"",STATUS,"","sel sfb",1)  
               NEXT FIELD sib02
            END IF
            
            #工單狀態為2時，才可備置
            IF l_sfb04 !='2' THEN
               CALL cl_err('sfb04!=2','sia-002',0) NEXT FIELD sib02
            END IF
 
            IF l_sfb81 > g_sia.sia02 THEN      
               CALL cl_err(g_sib[i].sib02,'sia-004',0) NEXT FIELD sib02
            END IF                             
 
            IF l_sfb02=13 THEN  
               CALL cl_err('sfb02=13','asf-346',0) NEXT FIELD sib02
            END IF
 
            SELECT ima02,ima021 INTO g_sib[i].ima02, g_sib[i].ima021 
              FROM ima_file
             WHERE ima01=g_sib[i].sfb05
 
            IF g_sia.sia05 = '1' THEN   #成套  
               LET l_sib03 = 0
               LET l_sib03_r = 0 
               IF g_sia.sia04 = '1' THEN
               DECLARE i610_cs1 CURSOR FOR
                SELECT SUM(sib03) FROM sia_file,sib_file
                 WHERE sia04='1' AND sia05 = '1' 
                   AND sia01=sib01
                   AND siaconf = 'Y'
                   AND sib02=g_sib[i].sib02
                 GROUP BY sib04
                 ORDER BY sib03 DESC
 
               FOREACH i610_cs1 INTO l_sib03
                 IF STATUS THEN LET l_sib03=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sib03) THEN LET l_sib03 = 0 END IF   #成套備置數
              ELSE 
               DECLARE i610_cs0 CURSOR FOR
                SELECT SUM(sib03) FROM sia_file,sib_file
                 WHERE sia04='2' AND sia01=sib01 AND sia05 = '1'
                   AND siaconf = 'Y'
                   AND sib02= g_sib[i].sib02
                 GROUP BY sib04
                 ORDER BY sib03 DESC
 
               FOREACH i610_cs0 INTO l_sib03_r
                 IF STATUS THEN LET l_sib03_r=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sib03_r) THEN LET l_sib03_r = 0 END IF #成套退備置數  
               END IF  
               LET l_sib03 = l_sib03 - l_sib03_r    #成套備置-成套退備置

               IF l_sib03 > l_sfb08 THEN
                  CALL cl_err(g_sib[i].sib02,'sia-005',0)
                  NEXT FIELD sib02
               END IF
            END IF
         END IF
 
      AFTER FIELD sib04
         IF cl_null(g_sib[i].sib04) THEN
            LET g_sib[i].sib04 = ' '
         ELSE                                      
            CALL i610_sib04(g_sib[i].sib04) RETURNING g_errno
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sib[i].sib04,g_errno,1)
               NEXT FIELD sib04
            END IF
         END IF
 
         IF g_sia.sia04 MATCHES '[1]' THEN 
               
               SELECT SUM(sib03) INTO qty1 FROM sib_file, sia_file
                WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                  AND sib01=sia01 AND sia04='1' AND sia05='1' AND siaconf='Y'
               
               SELECT SUM(sib03) INTO qty2 FROM sib_file, sia_file
                WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                  AND sib01=sia01 AND sia04='2' AND sia05 ='1' AND siaconf='Y'
               
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
               
               LET unissue_qty = l_sfb08-(qty1-qty2)
 
            IF g_sib[i].sib03 IS NULL OR
               (l_sib02_t IS NULL OR l_sib02_t != g_sib[i].sib02) THEN
               IF g_sia.sia04='1' THEN
                  LET g_sib[i].sib03 = unissue_qty
               ELSE
                  LET g_sib[i].sib03 = qty1-qty2
               END IF
            END IF
            IF g_sib[i].sib03 = 0 THEN
               IF g_sia.sia04='1' THEN 
                  LET g_sib[i].sib03 = unissue_qty 
               ELSE
                  LET g_sib[i].sib03 = qty1-qty2              
               END IF
            END IF   
         END IF
                
      BEFORE FIELD sib03
         IF g_sia.sia04 MATCHES '[1]' THEN 
            LET qty1 = 0
            LET qty2 = 0
            IF cl_null(g_sib[i].sib04) THEN
               LET g_sib[i].sib04 = ' '
            END IF
            
               SELECT SUM(sib03) INTO qty1 FROM sib_file, sia_file
                WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                  AND sib01=sia01 AND sia04='1' AND sia05='1' AND siaconf='Y'
               
               SELECT SUM(sib03) INTO qty2 FROM sib_file, sia_file
                WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                  AND sib01=sia01 AND sia04='2' AND sia05='1' AND siaconf='Y'
               
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
               
               LET unissue_qty = l_sfb08-(qty1-qty2)

            IF g_sib[i].sib03 IS NULL OR
               (l_sib02_t IS NULL OR l_sib02_t != g_sib[i].sib02) THEN
               IF g_sia.sia04='1' THEN
                  LET g_sib[i].sib03 = unissue_qty
               ELSE
                  LET g_sib[i].sib03 = qty1-qty2
               END IF
            END IF
            IF g_sib[i].sib03 = 0 THEN
               IF g_sia.sia04='1' THEN
                  LET g_sib[i].sib03 = unissue_qty  
               ELSE  
                  LET g_sib[i].sib03 = qty1-qty2
               END IF
            END IF
         END IF
         IF cl_null(l_sib03_o) THEN     
            LET l_sib03_o =0
         END IF     
  
      AFTER FIELD sib03 
         IF NOT cl_null(g_sib[i].sib03) THEN 
            SELECT ima56 INTO l_ima56 FROM ima_file where ima01 = g_sib[i].sfb05
            IF l_ima56 <> 1 THEN
               LET l_faqty = g_sib[i].sib03 MOD l_ima56
               IF  l_faqty <> 0 THEN
                   CALL CL_err(g_sib[i].sib03,'sia-006',0)
                   NEXT FIELD sib03
               END IF
            ELSE
               LET l_per = g_sib[i].sib03/ l_ima56
               LET l_faqty = l_per *  l_ima56
               IF l_faqty <> g_sib[i].sib03 THEN
                  CALL CL_err(g_sib[i].sib03,'sia-006',0)
                   NEXT FIELD sib03
               END IF
            END IF
          
            IF cl_null(g_sib[i].sib03) OR g_sib[i].sib03 = 0 THEN NEXT FIELD sib03 END IF 
            IF cl_null(l_sib03_t) THEN LET l_sib03_t = 0 END IF                      
            IF g_sia.sia04 ='1' AND g_sib[i].sib03 <> l_sib03_t THEN   
               LET g_flag_sib03 = 1 
            END IF

            IF g_sia.sia04 = '2' AND g_sia.sia05='1' THEN    #成套退備置
               IF g_sib[i].sib03 <= 0 THEN NEXT FIELD sib03 END IF
               SELECT sib03 INTO l_qty FROM sib_file,sia_file 
                WHERE sib02 = g_sib[i].sib02 AND sib01 = sia01
                      AND siaconf = 'Y' and sia04='1' AND sia05 = '1'  
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               IF g_sib[i].sib03 > l_qty THEN
                  CALL cl_err(g_sib[i].sib03,'sia-008',0)
                  NEXT FIELD sib03
               END IF
            END IF
 
            IF g_sia.sia04 = '1' AND g_sia.sia05='1' THEN    #成套備置
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = g_sib[i].sib02
               LET l_sib03 = 0
               LET l_sib03_r = 0
 
               DECLARE i610_cs2 CURSOR FOR
                   SELECT SUM(sib03) FROM sia_file,sib_file
                    WHERE sia04='1' 
                      AND sia05='1'
                      AND sia01=sib01
                      AND sib02=g_sib[i].sib02
                      AND siaconf ='Y'     
                    GROUP BY sib04
                    ORDER BY sib03 DESC
 
               FOREACH i610_cs2 INTO l_sib03
                  IF STATUS THEN LET l_sib03=0 END IF
                  EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sib03) THEN
                  LET l_sib03 = 0
               END IF
 
               DECLARE i610_cs13 CURSOR FOR
                SELECT SUM(sib03) FROM sia_file,sib_file
                 WHERE sia04='2' AND sia01=sib01
                   AND sia05='1'
                   AND sib02= g_sib[i].sib02
                   AND siaconf ='Y'    
                 GROUP BY sib04
                 ORDER BY sib03 DESC
 
               FOREACH i610_cs13 INTO l_sib03_r
                  IF STATUS THEN LET l_sib03_r=0 END IF
                  EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sib03_r) THEN LET l_sib03_r = 0 END IF
               LET l_sib03 = l_sib03 - l_sib03_r          #成套備置-成套退備置 
               IF g_sib[i].sib04 IS NOT NULL THEN
                  SELECT SUM(sib03) INTO l_qty1 FROM sib_file, sia_file
                   WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                     AND sib01=sia01 AND sia04='1' AND sia05='1' AND siaconf !='X'
                  SELECT SUM(sib03) INTO l_qty2 FROM sib_file, sia_file
                   WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                     AND sib01=sia01 AND sia04='2' AND sia05='1' AND siaconf !='X'
                  IF l_qty1 IS NULL THEN LET l_qty1=0 END IF
                  IF l_qty2 IS NULL THEN LET l_qty2=0 END IF
                  LET l_sib03 = l_qty1 - l_qty2
               END IF
            END IF
          END IF
       
      AFTER INSERT
         IF INT_FLAG THEN
            CANCEL INSERT
            CALL g_sib.deleteElement(i)
            EXIT INPUT
         END IF
 
      AFTER INPUT
         LET l_sib02_t = g_sib[i].sib02
 
         IF INT_FLAG THEN
            LET INT_FLAG=0
            LET g_flag_sib03 = 0
            EXIT INPUT  
                
         END IF
 
         IF g_sib[i].sib02 IS NOT NULL THEN 
        
            IF g_sia.sia04 MATCHES '[12]' THEN
               SELECT SUM(sib03) INTO qty1 FROM sib_file, sia_file
                 WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                   AND sib01=sia01 AND sia04='1' AND siaconf='Y' AND sia05='1'
 
                SELECT SUM(sib03) INTO qty2 FROM sib_file, sia_file
                 WHERE sib02=g_sib[i].sib02 AND sib04=g_sib[i].sib04
                   AND sib01=sia01 AND sia04='2' AND siaconf='Y' AND sia05='1'
 
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
 
               LET unissue_qty = l_sfb08-(qty1-qty2)
               IF g_sib[i].sib03 IS NULL THEN
               #  IF g_argv1='1' THEN        #FUN-AC0074
                  IF g_sia.sia04 = '1' THEN  #FUN-AC0074
                     LET g_sib[i].sib03 = unissue_qty
                  ELSE LET g_sib[i].sib03 = qty1-qty2
                  END IF
               END IF
               IF g_sib[i].sib03 = 0 THEN
               #  IF g_argv1 ='1' THEN       #FUN-AC0074      	
                  IF g_sia.sia04 = '1' THEN  #FUN-AC0074
                     LET g_sib[i].sib03 = unissue_qty 
                  ELSE
                     LET g_sib[i].sib03 = qty1-qty2
                  END IF 
               END IF
            END IF
  
            IF g_sia.sia04 = '1' AND g_sia.sia05='1'THEN   #成套備置
               LET l_sib03 = 0
               DECLARE i610_cs3 CURSOR FOR
                SELECT SUM(sib03) FROM sia_file,sib_file
                 WHERE sia04='1'
                   AND sia01=sib01
                   AND sia05='1'
                   AND sib02=g_sib[i].sib02
                   AND siaconf !='X' 
                 GROUP BY sib04
                 ORDER BY sib03 DESC
 
               FOREACH i610_cs3 INTO l_sib03
                 IF STATUS THEN LET l_sib03=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sib03) THEN LET l_sib03 = 0 END IF
               IF g_sib[i].sib03 > l_sfb08 THEN
                  CALL cl_err(g_sib[i].sib02,'sia-005',0)
                  IF FGL_LASTKEY() = 2016 THEN    
                     LET g_sib[i].sib03 = null
                  END IF
                  NEXT FIELD sib02
               END IF
            END IF
 
            IF g_sia.sia04 = '2' AND g_sia.sia05='1' THEN    #成套退備置
               IF g_sib[i].sib03 <= 0 THEN NEXT FIELD sib03 END IF
               SELECT sib03 INTO l_qty FROM sib_file,sia_file 
                WHERE sib02 = g_sib[i].sib02 AND sib01 = sia01
                      AND siaconf = 'Y' and sia04='1' AND sia05 = '1'  
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               IF g_sib[i].sib03 > l_qty THEN
                  CALL cl_err(g_sib[i].sib03,'sia-008',0)
                  NEXT FIELD sib03
               END IF
            END IF
 
         END IF
 
      ON ACTION controlp 
        CASE 
            WHEN INFIELD(sib02) 
            	 IF g_sia.sia04 MATCHES '[1]' THEN
                                CALL cl_init_qry_var()
                                LET g_qryparam.form = "q_sfb20"       
                                LET g_qryparam.arg1 = 234567
                                LET g_qryparam.default1 = g_sib[i].sib02
                         ##組合拆解的工單不顯示出來!
                        #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                         LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file  WHERE smy69 IS NOT NULL) "         #FUN-B40029
                       CALL cl_create_qry() RETURNING g_sib[i].sib02
                        DISPLAY BY NAME g_sib[i].sib02   
                       NEXT FIELD sib02
               ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sie05"
                      #LET g_qryparam.arg1 = 234567
                      LET g_qryparam.default1 = g_sib[i].sib02
                      CALL cl_create_qry() RETURNING g_sib[i].sib02
                      DISPLAY BY NAME g_sib[i].sib02
                      NEXT FIELD sib02
               END IF
             WHEN INFIELD(sib04)
                      CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfa15"   
                     LET g_qryparam.arg1= g_sib[i].sib02  
                     LET g_qryparam.default1 = g_sib[i].sib04
                     CALL cl_create_qry() RETURNING g_sib[i].sib04
                      DISPLAY BY NAME g_sib[i].sib04    
                     NEXT FIELD sib04
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END INPUT
 
    LET g_sia.siamodu = g_user
    LET g_sia.siadate = g_today
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
 
   UPDATE sia_file SET siamodu=g_sia.siamodu,
                       siadate=g_sia.siadate
    WHERE sia01=g_sia.sia01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","sia_file",g_sia.sia01,"",SQLCA.sqlcode,"","upd siamodu",1)  #No.FUN-660128
       LET g_sia.siamodu=g_sia_t.siamodu
       LET g_sia.siadate=g_sia_t.siadate
       DISPLAY BY NAME g_sia.siamodu
       DISPLAY BY NAME g_sia.siadate
       ROLLBACK WORK
   END IF
  
   FOR i = 1 TO g_sib.getLength()
       IF g_sib[i].sib02 IS NULL THEN CONTINUE FOR END IF
       IF g_sib[i].sib04 IS NULL THEN LET g_sib[i].sib04=' ' END IF
       CALL i610_b_i_move_back(i)     
       INSERT INTO sib_file VALUES (b_sib.*)
       IF STATUS THEN
          CALL cl_err3("ins","sib_file",g_sia.sia01,g_sib[i].sib02,STATUS,"","ins sib",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
   END FOR
 
   IF g_flag_sib03 = 1 THEN
    IF g_sia.sia05='1' THEN
         CALL i610_g_b()
         CALL i610_b_fill(" 1=1") 
    END IF 
   END IF 
   COMMIT WORK
 
END FUNCTION

FUNCTION i610_sib04(p_sib04)
DEFINE p_sib04    LIKE sib_file.sib04
DEFINE l_eciacti  LIKE eci_file.eciacti
DEFINE l_ecdacti  LIKE ecd_file.ecdacti
DEFINE l_errno    LIKE type_file.chr10
    
    LET l_errno = ''
       SELECT ecdacti INTO l_ecdacti FROM ecd_file
        WHERE ecd01 = p_sib04
    CASE
      WHEN SQLCA.sqlcode = 100  LET l_errno = 'mfg4009'
      WHEN l_eciacti     = 'N'  LET l_errno = 'ams-106'
      OTHERWISE LET l_errno = SQLCA.sqlcode USING '-----'
    END CASE
 
    RETURN l_errno
 
END FUNCTION


FUNCTION i610_g_b()
  DEFINE l_gen02         LIKE gen_file.gen02    
  DEFINE qty1,qty2	     LIKE sib_file.sib03    
  DEFINE l_n             LIKE type_file.num5    
  DEFINE l_cnt           LIKE type_file.num5    
  DEFINE l_sia02         LIKE sia_file.sia02
  DEFINE l_sql           STRING 
  DEFINE l_date          LIKE type_file.dat    
      
#FUN-A50023 --add --begin
  LET issue_type = '1'  
  LET b_part = '0'
  LET e_part = 'Z'
  LET ware_no = NULL 
  LET loc_no = NULL  
  LET lot_no = NULL  
  LET gen_no = NULL  


     OPEN WINDOW i610_g_b_w WITH FORM "asf/42f/asfi610a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
     CALL cl_ui_locale("asfi610a")
     
     CALL cl_set_comp_entry("lot_no",TRUE)
     
     INPUT BY NAME b_part,e_part,issue_type
                                    
                WITHOUT DEFAULTS
 
     AFTER FIELD b_part
        IF b_part IS NULL THEN LET b_part = '0' DISPLAY BY NAME b_part END IF
     AFTER FIELD e_part
        IF e_part IS NULL THEN LET e_part = 'Z' DISPLAY BY NAME e_part END IF
 
     BEFORE FIELD issue_type
     #  IF g_argv1='2' THEN       #FUN-AC0074
        IF g_sia.sia04 = '2' THEN #FUN-AC0074
           LET issue_type = '1'
           DISPLAY BY NAME issue_type
        END IF
 
      ON CHANGE issue_type   
 
        IF NOT cl_null(issue_type) THEN
           IF issue_type NOT MATCHES '[012345]' THEN
              NEXT FIELD issue_type
           END IF
           IF issue_type ='0' THEN EXIT INPUT END IF
        END IF
   
     AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT 
        END IF
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT 
 
  END INPUT
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW i610_g_b_w
     CALL i610_b_fill(' 1=1')
     RETURN
  END IF
  
  IF issue_type='0' THEN
     DELETE FROM sic_file WHERE sic01=g_sia.sia01
     LET g_rec_b = 0
     CLOSE WINDOW i610_g_b_w
     RETURN
  END IF
  
  
  IF issue_type = '2' THEN  
        INPUT BY NAME ware_no,loc_no,lot_no,gen_no WITHOUT DEFAULTS
       
        BEFORE INPUT
           IF issue_type = '2' THEN   
              CALL cl_set_comp_entry("gen_no",FALSE)
           ELSE
              CALL cl_set_comp_entry("gen_no",TRUE)
           END IF
 
        AFTER FIELD ware_no
           IF NOT cl_null(ware_no) THEN             
              SELECT imd02 INTO g_buf FROM imd_file   
               WHERE imd01=ware_no
                  AND imdacti = 'Y' 
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",ware_no,"",STATUS,"","sel imd",1)  
                 NEXT FIELD ware_no
              END IF
              #Add No.FUN-AB0046
              IF NOT s_chk_ware(ware_no) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD ware_no
              END IF
              #End Add No.FUN-AB0046
              DISPLAY g_buf TO imd02
           END IF
        
        AFTER FIELD gen_no 
           IF NOT cl_null(gen_no) THEN
              SELECT gen02 INTO l_gen02 FROM gen_file
               WHERE gen01 = gen_no
                 AND genacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gen_file",gen_no,"",STATUS,"","sel gen",1)
                 NEXT FIELD gen_no
              END IF
              DISPLAY l_gen02 TO gen02
           END IF
          
 
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT 
           END IF
           IF issue_type ='2' AND cl_null(ware_no) THEN NEXT FIELD ware_no END IF
           IF ware_no IS NULL THEN LET ware_no =' ' END IF
           IF loc_no IS NULL THEN LET loc_no =' ' END IF
           IF lot_no IS NULL THEN LET lot_no =' ' END IF
           IF gen_no IS NULL THEN LET gen_no =' ' END IF   
           
        ON ACTION controlp
           CASE WHEN INFIELD(ware_no)
                    #Mod No.FUN-AB0046
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.default1 = ware_no
                    #LET g_qryparam.arg1    = 'SW'        #倉庫類別 
                    #CALL cl_create_qry() RETURNING ware_no
                     CALL q_imd_1(FALSE,TRUE,ware_no,"",g_plant,"","")  #只能开当前门店的
                          RETURNING ware_no
                    #End Mod No.FUN-AB0046
                     DISPLAY BY NAME ware_no
                     NEXT FIELD ware_no
                WHEN INFIELD(loc_no)
                    #Mod No.FUN-AB0046
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_ime"
                    #LET g_qryparam.default1 = loc_no
                    #LET g_qryparam.arg1    = ware_no     #倉庫編號 
                    #LET g_qryparam.arg2    = 'SW'        #倉庫類別 
                    #CALL cl_create_qry() RETURNING loc_no
                     CALL q_ime_1(FALSE,TRUE,loc_no,ware_no,"",g_plant,"","","")
                          RETURNING loc_no
                    #End Mod No.FUN-AB0046
                     DISPLAY BY NAME loc_no
                     NEXT FIELD loc_no
                WHEN INFIELD(gen_no)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen4"
                     LET g_qryparam.default1 = gen_no
                     CALL cl_create_qry() RETURNING gen_no
                     DISPLAY BY NAME gen_no
                     NEXT FIELD gen_no
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
     END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i610_g_b_w
         CALL i610_b_fill(' 1=1')
         RETURN
      END IF
  END IF      

   LET g_wc4 = ' 1=1'
   IF issue_type MATCHES '[1345]' THEN  
     CONSTRUCT BY NAME  g_wc4 ON ware_no,loc_no,gen_no
     
     BEFORE CONSTRUCT
       CALL cl_qbe_init()
       CALL cl_set_comp_entry("lot_no",FALSE)  
      
       ON ACTION controlp
          CASE WHEN INFIELD(ware_no)
                   #Mod No.FUN-AB0046
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_imd"
                   #LET g_qryparam.state= "c"
                   #LET g_qryparam.arg1    = 'SW'        #倉庫類別 
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                         RETURNING g_qryparam.multiret
                   #End Mod No.FUN-AB0046
                    DISPLAY g_qryparam.multiret TO ware_no
                    NEXT FIELD ware_no
               WHEN INFIELD(loc_no)
                   #Mod zLyn
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_ime"
                   #LET g_qryparam.state= "c"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                   #End Mod zLyn
                    DISPLAY g_qryparam.multiret TO loc_no
                    NEXT FIELD loc_no
               WHEN INFIELD(gen_no)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen4"
                    LET g_qryparam.state= "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO gen_no
                    NEXT FIELD gen_no
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i610_g_b_w
         CALL i610_b_fill(' 1=1')
         RETURN
      END IF
 
   END IF
 
   IF cl_null(g_wc4) THEN
      LET g_wc4 = ' 1=1'
   END IF

   IF issue_type = '1' OR issue_type = '4' OR issue_type = '5' THEN   
      CALL cl_replace_str(g_wc4,"ware_no","ima35") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"loc_no","ima36") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"gen_no","ima23") RETURNING g_wc4
   END IF
   IF issue_type ='3' THEN
      CALL cl_replace_str(g_wc4,"ware_no","sfa30") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"loc_no", "sfa31") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"gen_no", "ima23") RETURNING g_wc4
   END IF
   
  IF NOT cl_sure(0,0) THEN
     LET g_rec_b = 0
     CLOSE WINDOW i610_g_b_w
     RETURN
  END IF
 
  INITIALIZE b_sic.* TO NULL
  LET b_sic.sic02=0
  DELETE FROM sic_file WHERE sic01=g_sia.sia01
  
#FUN-A50023 --add --end    
     
      DECLARE i610_g_b_c CURSOR FOR
         SELECT sib_file.* FROM sib_file,sia_file WHERE sib01=g_sia.sia01 AND sib01 = sia01
                   AND sia04 = g_sia.sia04 
      FOREACH i610_g_b_c INTO b_sib.*
        SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=b_sib.sib02
        IF STATUS THEN 
           CALL cl_err3("sel","sfb_file",b_sib.sib02,"",STATUS,"","sel sfb:",1) 
           RETURN 
        END IF  
        IF cl_null(b_sib.sib04) THEN
           SELECT SUM(sib03) INTO qty1 FROM sib_file, sia_file
            WHERE sib02=b_sib.sib02 
              AND sib01=sia01 AND sia04='1' AND siaconf='Y'
           SELECT SUM(sib03) INTO qty2 FROM sib_file, sia_file
            WHERE sib02=b_sib.sib02 
              AND sib01=sia01 AND sia04='2' AND siaconf='Y'
        ELSE
           SELECT SUM(sib03) INTO qty1 FROM sib_file, sia_file
            WHERE sib02=b_sib.sib02 AND sib04=b_sib.sib04
              AND sib01=sia01 AND sia04='1' AND siaconf='Y'
           SELECT SUM(sib03) INTO qty2 FROM sib_file, sia_file
            WHERE sib02=b_sib.sib02 AND sib04=b_sib.sib04
              AND sib01=sia01 AND sia04='2' AND siaconf='Y'
        END IF
 
        IF qty1 IS NULL THEN LET qty1=0 END IF
        IF qty2 IS NULL THEN LET qty2=0 END IF
 
        CASE 
           WHEN g_sia.sia04='1' 
              IF g_sfb.sfb08<=(qty1-qty2+b_sib.sib03) THEN
                 CALL i610_g_b0()  #全數備置
              ELSE
                 CALL i610_g_b1()  #依套數
              END IF
             WHEN g_sia.sia04='2' 
                IF (qty1-qty2-b_sib.sib03)<=0 THEN
                   CALL i610_g_b5()  #全數退備置
                ELSE
                   CALL i610_g_b1()  #依套數
                END IF
        END CASE
 
      END FOREACH 
  CALL i610_sort_by_partno()
  LET g_rec_b = g_i
  CLOSE WINDOW i610_g_b_w   #FUN-A50023 add
  DISPLAY ARRAY g_sic TO s_sic.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
       EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
 
 
FUNCTION i610_sort_by_partno() 		
  DEFINE l_sic	RECORD LIKE sic_file.*
 
  SELECT COUNT(*) INTO g_i FROM sib_file WHERE sib01=g_sia.sia01
  IF g_i<=1 THEN RETURN END IF
 
  UPDATE sic_file SET sic02=sic02+1000 WHERE sic01=g_sia.sia01
 
  DECLARE i610_sort_c CURSOR FOR
    SELECT * FROM sic_file
     WHERE sic01=g_sia.sia01
     ORDER BY sic05,sic03
 
  LET g_i=0
  FOREACH i610_sort_c INTO l_sic.*
     LET g_i=g_i+1
     UPDATE sic_file SET sic02=g_i
      WHERE sic01=l_sic.sic01
        AND sic02=l_sic.sic02
  END FOREACH
 
END FUNCTION

FUNCTION i610_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10   
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
 
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN
     LET i=p_qty / l_ima64 + 0.999999
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION

FUNCTION i610_g_b0() 		# 全數備置
  DEFINE l_sql     LIKE type_file.chr1000 
 
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sib.sib02,"'",
              "   AND sfa05>sfa06",
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X','S') OR sfa11 IS NULL)", #CHI-980013 #FUN-9C0040
              "   AND (sfa05-sfa065)>0",  #應發-委外代買量>0
              "   AND ",g_wc4 CLIPPED     #FUN-A50023
 
  IF NOT cl_null(b_sib.sib04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sib.sib04,"'"
  END IF
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i610_g_b0_pre FROM l_sql
  DECLARE i610_g_b0_c CURSOR FOR i610_g_b0_pre
 
  FOREACH i610_g_b0_c INTO g_sfa2.*,g_ima108
    LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
 
    LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)
    CALL i610_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
    CALL i610_chk_img()		# 依 issue_qty1 尋找 img_file可用資料
 
  END FOREACH
 
END FUNCTION

FUNCTION i610_g_b1() 		# 依套數備置/退备置(When sia04=1/2)
  DEFINE l_sql		LIKE type_file.chr1000 
  DEFINE s_u_flag	LIKE type_file.chr1    
 
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sib.sib02,"'",
              "   AND sfa26 IN ('0','1','2','3','4','5','T')",    
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)",
              "   AND (sfa05-sfa065)>=0",    #應發-委外代買量>0
              "   AND ",g_wc4 CLIPPED      #FUN-A50023   
                             
  IF g_sia.sia04 = '1' THEN 
     LET l_sql = l_sql CLIPPED," AND sfa11 <> 'S' " 
  END IF   
    
 
  IF NOT cl_null(b_sib.sib04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sib.sib04,"'"
  END IF
  LET l_sql = l_sql CLIPPED," ORDER BY sfa03"
  PREPARE i610_g_b1_pre FROM l_sql
  DECLARE i610_g_b1_c CURSOR FOR i610_g_b1_pre
 
  FOREACH i610_g_b1_c INTO g_sfa.*,g_ima108	#原始料件(g_sfa)
  
    
    LET g_sfa.sfa05=g_sfa.sfa05-g_sfa.sfa065   #扣除委外代買量
 
    IF STATUS THEN CALL cl_err('fore sfa',STATUS,1) RETURN END IF
 
 
    LET issue_qty  =b_sib.sib03*g_sfa.sfa161		#原始料件應備置
 
    IF g_sfa.sfa26 MATCHES '[01257]' THEN
       #若是全數代買時則不允許做退備置
       IF g_sfa.sfa05 = 0 THEN 
          CONTINUE FOREACH
       END IF
    #  IF g_argv1='1' AND issue_qty>(g_sfa.sfa05-g_sfa.sfa06) THEN        #FUN-AC0074
       IF g_sia.sia04 = '1' AND issue_qty>(g_sfa.sfa05-g_sfa.sfa06) THEN  #FUN-AC0074
          LET issue_qty=(g_sfa.sfa05-g_sfa.sfa06)
       END IF
 
    #  IF g_argv1='2' AND issue_qty>(b_sib.sib03) THEN        #FUN-AC0074
       IF g_sia.sia04 = '2' AND issue_qty>(b_sib.sib03) THEN  #FUN-AC0074
          LET issue_qty=b_sib.sib03
       END IF
 
       LET g_sfa2.* = g_sfa.*
 
       LET issue_qty1=issue_qty
       CALL i610_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
 
       CALL i610_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
 
       CONTINUE FOREACH
 
    END IF
 
    # 當有替代狀況時, 須作以下處理:
    LET l_sql="SELECT * FROM sfa_file",
              " WHERE sfa01='",g_sfa.sfa01,"' AND sfa27='",g_sfa.sfa03,"'",
              "   AND sfa08='",g_sfa.sfa08,"' AND sfa12='",g_sfa.sfa12,"'"
    IF g_sia.sia04='2' THEN
       LET l_sql = l_sql CLIPPED," AND sfa05 > 0 "  CLIPPED
    END IF
 
    SELECT MAX(sfa26) INTO s_u_flag FROM sfa_file	# 到底是 S 或 U ?
                WHERE sfa01=g_sfa.sfa01 AND sfa27=g_sfa.sfa03
                  AND sfa08=g_sfa.sfa08 AND sfa12=g_sfa.sfa12
    # U:先備置取代件,再備置原料件 S:先備置原料件,再備置替代件
    IF s_u_flag='U' OR s_u_flag = 'T' THEN     #bungo:711l add 'T'
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26 DESC, sfa03"
    ELSE
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26     , sfa03"
    END IF
    PREPARE g_b1_p2 FROM l_sql
    DECLARE g_b1_c2 CURSOR FOR g_b1_p2
    FOREACH g_b1_c2 INTO g_sfa2.*	             #應備料(含替代)料件(g_sfa2
       LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
       IF STATUS THEN CALL cl_err('f sfa2',STATUS,1) RETURN END IF
       LET issue_qty=issue_qty*g_sfa2.sfa28
 # issue_qty的計算應以sib03* sfa161來計算才不會被改變,影響後續欠料數量的計算
    #  IF g_argv1='1' THEN	# 備置料時   #FUN-AC0074
       IF g_sia.sia04 = '1' THEN  #備置料時  #FUN-AC0074
         IF g_sfa2.sfa05<=g_sfa2.sfa06 THEN CONTINUE FOREACH END IF
         IF issue_qty<=(g_sfa2.sfa05-g_sfa2.sfa06) THEN
            LET issue_qty1=issue_qty
            CALL i610_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
            EXIT FOREACH
         ELSE
            LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)
            CALL i610_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
            LET issue_qty=(issue_qty-img_qty)/g_sfa2.sfa28
         END IF
       END IF
      #IF g_argv1='2' THEN	# 退備置時      #FUN-AC0074
       IF g_sia.sia04 = '2' THEN   # 退備置時   #FUN-AC0074   
         IF issue_qty<=b_sib.sib03 THEN
            LET issue_qty1=issue_qty
            CALL i610_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
            EXIT FOREACH
          ELSE
            LET issue_qty1=b_sib.sib03
            CALL i610_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
 
            LET issue_qty=(issue_qty-img_qty)/g_sfa2.sfa28
 
         END IF
       END IF       
    END FOREACH
  END FOREACH
END FUNCTION

FUNCTION i610_g_b5() 		# 全部退備置料
  DEFINE l_sql      LIKE type_file.chr1000
  DEFINE l_sic      RECORD LIKE  sic_file.* 
  DEFINE l_sie11    LIKE sie_file.sie11  
 
  LET l_sql = "SELECT sic_file.* FROM sia_file,sic_file ", 
              " WHERE sic03='",b_sib.sib02,"'",
              "   AND sia01 = sic01 AND sia04='1' and siaconf='Y' " 
  IF NOT cl_null(b_sib.sib04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sic11 = '",b_sib.sib04,"'"
  END IF
  LET l_sql = l_sql CLIPPED," ORDER BY sic04,sic05"
 
  PREPARE i610_g_b5_pre FROM l_sql
  DECLARE i610_g_b5_c CURSOR FOR i610_g_b5_pre
 
  FOREACH i610_g_b5_c INTO l_sic.* 
    LET b_sic.sic01=g_sia.sia01
    LET b_sic.sic02=b_sic.sic02+1
    LET b_sic.sic03=b_sib.sib02
    LET b_sic.sic04=l_sic.sic04
    LET b_sic.sic05=l_sic.sic05
    LET b_sic.sic07=l_sic.sic07
    LET b_sic.sic08=l_sic.sic08
    LET b_sic.sic09=l_sic.sic09
 
    LET b_sic.sic11=l_sic.sic11
    LET b_sic.sic10=l_sic.sic10
    IF b_sic.sic10 IS NULL THEN LET b_sic.sic10 = ' ' END IF
    IF b_sic.sic08 IS NULL THEN LET b_sic.sic08 = ' ' END IF
    IF b_sic.sic09 IS NULL THEN LET b_sic.sic09 = ' ' END IF
    LET b_sic.sic16 = l_sic.sic16  #FUN-AC0074
    SELECT sie11 INTO l_sie11 FROM sie_file WHERE sie01 = l_sic.sic05 AND sie02 = l_sic.sic08 AND sie03 = l_sic.sic09
              AND sie04 = l_sic.sic10 AND sie05 = l_sic.sic03 AND sie06 = l_sic.sic11 
              AND sie07 = l_sic.sic07 AND sie08 = l_sic.sic04	
    IF l_sie11 IS NULL OR l_sie11 = 0 THEN
       LET b_sic.sic06 = l_sic.sic06
    ELSE 
       LET b_sic.sic06 = l_sie11
       LET b_sic.sic06 = s_digqty(b_sic.sic06,b_sic.sic07)   #No.FUN-BB0086
    END IF  
    LET b_sic.sicplant = g_plant 
    LET b_sic.siclegal = g_legal 
#FUN-B20009 -----------------Begin-----------------------
    LET b_sic.sic012 = l_sic.sic012
    LET b_sic.sic013 = l_sic.sic013
    IF cl_null(b_sic.sic012) THEN
       LET b_sic.sic012 =  '0'
    END IF
    IF cl_null(b_sic.sic013) THEN
       LET b_sic.sic013 = 0
    END IF
#FUN-B20009 -----------------End-------------------------
    LET b_sic.sic07_fac = l_sic.sic07_fac   #FUN-AC0074 
    IF cl_null(b_sic.sic15) THEN  #FUN-AC0074
       LET b_sic.sic15 = 0        #FUN-AC0074
    END IF                        #FUN-AC0074
    INSERT INTO sic_file VALUES(b_sic.*)
    IF STATUS THEN 
       CALL cl_err3("ins","sic_file",b_sic.sic01,b_sic.sic02,STATUS,"","ins sic:",1)  #No.FUN-660128
    END IF        
  END FOREACH
 
END FUNCTION

FUNCTION i610_set_entry_d(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("sib03",TRUE)
    END IF
END FUNCTION
 
FUNCTION i610_set_no_entry_d(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF g_sia.sia04 NOT MATCHES '[12]' THEN 
       CALL cl_set_comp_entry("sib03",FALSE)
    END IF
   
END FUNCTION
  
FUNCTION i610_b()
DEFINE
    l_ac_t              LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_row,l_col         LIKE type_file.num5,                      #分段輸入之行,列數
    l_n,l_cnt           LIKE type_file.num5,                #檢查重複用  
    l_lock_sw           LIKE type_file.chr1,                 #單身鎖住否 
    p_cmd               LIKE type_file.chr1,                 #處理狀態 
    l_b2      		LIKE type_file.chr50,   
    l_b3      		LIKE sfa_file.sfa08,
    l_sfa06             LIKE sfa_file.sfa06,
    l_sfa062            LIKE sfa_file.sfa062, 
    l_sfa05             LIKE sfa_file.sfa05, 
    l_sfb08             LIKE sfb_file.sfb08,  
    l_sfa100            LIKE sfa_file.sfa100,  
    l_sfa100_t          LIKE sfa_file.sfa100, 
    l_sfa161            LIKE sfa_file.sfa161,
    l_sfb09             LIKE sfb_file.sfb09,
    l_sfb11             LIKE sfb_file.sfb11,  
    l_ima35	        LIKE ima_file.ima35,
    l_ima36	        LIKE ima_file.ima36, 
    l_sib               RECORD LIKE sib_file.*,
    l_qty		LIKE sfa_file.sfa06,  
    l_sub_qty		LIKE sfa_file.sfa06,  
    l_sub_qty1          LIKE sfa_file.sfa06,  
    t_sfa05             LIKE sfa_file.sfa05,
    t_sfa06             LIKE sfa_file.sfa06,
    t_short_qty         LIKE sfa_file.sfa07,
    s_sfa05             LIKE sfa_file.sfa05,
    s_sfa06             LIKE sfa_file.sfa06,
    l_ima108            LIKE ima_file.ima108,
    l_ima70             LIKE ima_file.ima70,
    l_sfa11             LIKE sfa_file.sfa11,    
    l_sic05x            LIKE sic_file.sic05,   
    l_msg               LIKE type_file.chr1000, 
    no1		        LIKE type_file.num10,   
    l_factor            LIKE ima_file.ima31_fac,
    l_flag              LIKE type_file.num10,   
    l_allow_insert      LIKE type_file.num5,                #可新增否  
    l_sfa06_t           LIKE sfa_file.sfa06,
    l_sfa161_t          LIKE sfa_file.sfa161,
    l_sfa26             LIKE sfa_file.sfa26,
    l_sfa27             LIKE sfa_file.sfa27,
    l_sfa28             LIKE sfa_file.sfa28,
    l_sfa28_t           LIKE sfa_file.sfa28,
    l_sic05             LIKE sic_file.sic05,
    l_allow_delete      LIKE type_file.num5,                #可刪除否  
    l_sfb02             LIKE sfb_file.sfb02     
DEFINE l_i     LIKE type_file.num5
DEFINE l_fac   LIKE ima_file.ima31_fac  
 
DEFINE l_sfa29          LIKE sfa_file.sfa29
DEFINE l_totsic05       LIKE sic_file.sic05   
DEFINE l_sfa27_a        LIKE sfa_file.sfa27   
DEFINE l_cn             LIKE type_file.num5  
DEFINE l_sfa08_tmp      LIKE sfa_file.sfa08
DEFINE l_sfa12_tmp      LIKE sfa_file.sfa12
DEFINE l_sfa27_tmp      LIKE sfa_file.sfa27
DEFINE l_sfa36          LIKE sfa_file.sfa36  
DEFINE l_sfb05          LIKE sfb_file.sfb05   
DEFINE l_img10          LIKE img_file.img10
DEFINE g_img09          LIKE img_file.img09
DEFINE l_sic06x         LIKE sic_file.sic06
DEFINE l_sig05          LIKE sig_file.sig05
DEFINE l_totsic06       LIKE sic_file.sic06 
DEFINE l_sic06          LIKE sic_file.sic06
DEFINE l_sfa012         LIKE sfa_file.sfa012  #FUN-A90035 add
DEFINE l_sfa013         LIKE sfa_file.sfa013  #FUN-A90035 add  
DEFINE l_sic013         LIKE sic_file.sic013  #FUN-B20009 add
DEFINE l_ecm014         LIKE ecm_file.ecm014  #FUN-B20009 add 
DEFINE l_sfa08          LIKE sfa_file.sfa08   #FUN-B20009 add  
DEFINE m_img10          LIKE img_file.img10   #FUN-AC0074 add
DEFINE m_sic06          LIKE sic_file.sic06   #FUN-AC0074 add
DEFINE m_sig05          LIKE sig_file.sig05   #FUN-AC0074 add
DEFINE l_oeb04          LIKE oeb_file.oeb04   #FUN-AC0074 add
DEFINE l_ima25          LIKE ima_file.ima25   #FUN-AC0074 add
DEFINE l_sie09          LIKE sie_file.sie09   #FUN-AC0074 add
DEFINE l_oeb12x         LIKE oeb_file.oeb12   #FUN-AC0074 add
DEFINE l_sql            STRING                #FUN-AC0074 add
DEFINE l_oeaconf        LIKE oea_file.oeaconf #FUN-AC0074 add
DEFINE l_inaconf        LIKE ina_file.inaconf #FUN-AC0074 add
DEFINE l_sfb04          LIKE sfb_file.sfb04   #FUN-AC0074 add
DEFINE l_immconf        LIKE imm_file.immconf #FUN-AC0074 add
DEFINE l_inapost        LIKE ina_file.inapost #FUN-AC0074 add 
DEFINE l_imm10          LIKE imm_file.imm10   #TQC-B50052    
DEFINE l_imm04          LIKE imm_file.imm04   #TQC-B50052
DEFINE l_tf             LIKE type_file.chr1               #No.FUN-BB0086
DEFINE l_case           STRING                #No.FUN-BB0086
DEFINE l_oea49          LIKE oea_file.oea49   #TQC-C70014
DEFINE l_oeahold        LIKE oea_file.oeahold #TQC-C70020
DEFINE l_imm03          LIKE imm_file.imm03   #TQC-CB0044

    LET g_action_choice = ""
    IF g_sia.sia01 IS NULL THEN RETURN END IF
    SELECT * INTO g_sia.* FROM sia_file WHERE sia01=g_sia.sia01
    IF g_sia.siaconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM sic_file ",
                       " WHERE sic01= ? AND sic02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i610_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_sic.clear() END IF
    IF g_rec_b > 0  THEN LET l_ac = 1  END IF
 
    INPUT ARRAY g_sic WITHOUT DEFAULTS FROM s_sic.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
	    BEGIN WORK
            DISPLAY "begin work"
            OPEN i610_cl USING g_sia.sia01                     
            IF STATUS THEN
               CALL cl_err("OPEN i610_cl:", STATUS, 1)
               CLOSE i610_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i610_cl INTO g_sia.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_sia.sia01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE i610_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sic_t.* = g_sic[l_ac].*  #BACKUP
               LET g_sic07_t = g_sic[l_ac].sic07   #No.FUN-BB0086
               LET g_sia.siamodu=g_user             
               LET g_sia.siadate=g_today             
               DISPLAY BY NAME g_sia.siamodu         
               DISPLAY BY NAME g_sia.siadate         
 
               OPEN i610_bcl USING g_sia.sia01,g_sic_t.sic02
               IF STATUS THEN
                  CALL cl_err("OPEN i610_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i610_bcl INTO b_sic.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock sic',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i610_b_move_to()
                  END IF
               END IF 
              #FUN-AC0074 ----------Begin------------------
              #IF g_sma.sma115 = 'Y' THEN
              #   IF NOT cl_null(b_sic.sic05) THEN
              #      SELECT ima55,ima31 INTO g_ima55,g_ima31
              #        FROM ima_file WHERE ima01=b_sic.sic05
 
              #      CALL s_chk_va_setting(b_sic.sic05)
              #           RETURNING g_flag,g_ima906,g_ima907
              #   END IF
              #END IF
              #FUN-AC0074 ----------End--------------------

            END IF
 
        BEFORE INSERT
            INITIALIZE g_sic_t.* TO NULL
            INITIALIZE b_sic.* TO NULL     
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sic[l_ac].* TO NULL     
            LET g_sic07_t = NULL    #No.FUN-BB0086
            LET b_sic.sic01=g_sia.sia01 
            LET g_sic[l_ac].sic06=0
            LET g_sic[l_ac].sic11=' '
            #FUN-AC0074 -------Begin--------------
            IF g_argv1 = '1' THEN
               LET g_sic[l_ac].sic15 = 0
            END IF
            #FUN-AC0074 -------End---------------- 
            CALL cl_show_fld_cont()     
            NEXT FIELD sic02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               ROLLBACK WORK 
                CANCEL INSERT 
            END IF
           #FUN-AC0074 ---------------Begin---------------------- 
           #IF g_sma.sma115 = 'Y' THEN
           #   CALL s_chk_va_setting(g_sic[l_ac].sic05)
           #        RETURNING g_flag,g_ima906,g_ima907
           #   IF g_flag=1 THEN
           #      NEXT FIELD sic05
           #   END IF 
 
           #   IF cl_null(g_sic[l_ac].sic10) THEN LET g_sic[l_ac].sic10 = ' ' END IF
           #   IF cl_null(g_sic[l_ac].sic09) THEN LET g_sic[l_ac].sic09 = ' ' END IF
           #  SELECT img09 INTO g_img09 FROM img_file
           #    WHERE img01=g_sic[l_ac].sic05
           #      AND img02=g_sic[l_ac].sic08
           #      AND img03=g_sic[l_ac].sic09
           #      AND img04=g_sic[l_ac].sic10
           #   IF cl_null(g_img09) THEN
           #      CALL cl_err(g_sic[l_ac].sic05,'mfg6069',0)
           #      NEXT FIELD sic05
           #   END IF
           #END IF
           #FUN-AC0074 ---------------End--------------------------  
             
            CALL i610_b_move_back()
            CALL i610_b_else()
            IF g_sic[l_ac].sic05 IS NULL AND g_sic[l_ac].sic06 = 0 THEN
               DISPLAY 'import field is null OR blank '
               INITIALIZE g_sic[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_sic[l_ac].* TO s_sic[l_ac].*
               CANCEL INSERT
            END IF

            IF NOT cl_null(l_sfa27_a) THEN LET b_sic.sic04=l_sfa27_a END IF 
            IF cl_null(b_sic.sic04) THEN
               LET b_sic.sic04=b_sic.sic05
            END IF
            IF cl_null(b_sic.sic04) THEN
               LET b_sic.sic04 = ' '
            END IF
           #FUN-AC0074 ---------------Begin--------------
            IF cl_null(b_sic.sic15) THEN
               LET b_sic.sic15 = 0
            END IF
           #FUN-AC0074 ---------------End----------------  
            INSERT INTO sic_file VALUES(b_sic.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sic_file",b_sic.sic01,b_sic.sic02,SQLCA.sqlcode,"","ins sic",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD sic02                            #default 序號
            IF g_sic[l_ac].sic02 IS NULL OR g_sic[l_ac].sic02 = 0 THEN
                SELECT MAX(sic02)+1 INTO g_sic[l_ac].sic02
                   FROM sic_file WHERE sic01 = g_sia.sia01
                IF g_sic[l_ac].sic02 IS NULL THEN LET g_sic[l_ac].sic02=1 END IF
            END IF
 
        AFTER FIELD sic02                        #check 序號是否重複
            IF NOT cl_null(g_sic[l_ac].sic02) THEN
               IF g_sic[l_ac].sic02 != g_sic_t.sic02 OR
                  g_sic_t.sic02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM sic_file
                       WHERE sic01 = g_sia.sia01
                         AND sic02 = g_sic[l_ac].sic02
                   IF l_n > 0 THEN
                       LET g_sic[l_ac].sic02 = g_sic_t.sic02
                       CALL cl_err('',-239,0) NEXT FIELD sic02
                   END IF
               END IF
            END IF
  
        AFTER FIELD sic03
           #FUN-AC0074-------------------Begin---------------------
           IF NOT cl_null(g_sic[l_ac].sic03) THEN
             #TQC-C70014 -- add -- begin
              SELECT oea49 INTO l_oea49 FROM oea_file
               WHERE oea01 = g_sic[l_ac].sic03
              IF l_oea49 = '2' THEN
                 CALL cl_err(g_sic[l_ac].sic03,'asf1030',0)
                 NEXT FIELD sic03
              END IF
             #TQC-C70014 -- add -- end
             #TQC-C70020 -- add -- begin
              SELECT oeahold INTO l_oeahold FROM oea_file
               WHERE oea01 = g_sic[l_ac].sic03
              IF NOT cl_null(l_oeahold) THEN
                 CALL cl_err(g_sic[l_ac].sic03,'asf1031',0)
                 NEXT FIELD sic03
              END IF
             #TQC-C70020 -- add -- end
              LET l_cnt = 0
              IF g_argv1 = '2' THEN
                 SELECT COUNT(*) INTO l_cnt FROM oeb_file
                  WHERE oeb01 = g_sic[l_ac].sic03
                 IF SQLCA.SQLCODE OR l_cnt < 1 THEN
                    CALL cl_err(g_sic[l_ac].sic03,SQLCA.SQLCODE,0)
                    NEXT FIELD sic03
                 END IF
                 SELECT oeaconf INTO l_oeaconf FROM oea_file
                  WHERE oea01 = g_sic[l_ac].sic03
                 IF l_oeaconf <> 'Y'THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-191',0)
                    NEXT FIELD sic03
                  END IF
                 IF NOT cl_null(g_sic[l_ac].sic15) THEN  
                    SELECT COUNT(*) INTO l_cnt FROM oeb_file
                     WHERE oeb01 = g_sic[l_ac].sic03
                       AND oeb03 = g_sic[l_ac].sic15
                    IF l_cnt <= 0 THEN
                       CALL cl_err(g_sic[l_ac].sic03,'asf-189',0)
                       NEXT FIELD sic03
                    END IF
                    #TQC-BA0091 ----- start -----
                    #SELECT oeb12,oeb24,oeb05 INTO g_sic[l_ac].sfa05,g_sic[l_ac].sfa06,g_sic[l_ac].sic07 FROM oeb_file
                    SELECT oeb12,oeb24,oeb05,oeb05_fac
                      INTO g_sic[l_ac].sfa05,g_sic[l_ac].sfa06,g_sic[l_ac].sic07,g_sic[l_ac].sic07_fac
                      FROM oeb_file
                    #TQC-BA0091 -----  end  -----
                     WHERE oeb01 = g_sic[l_ac].sic03
                       AND oeb03 = g_sic[l_ac].sic15
                    DISPLAY BY NAME g_sic[l_ac].sfa05
                    DISPLAY BY NAME g_sic[l_ac].sfa06
                    DISPLAY BY NAME g_sic[l_ac].sic07
                    DISPLAY BY NAME g_sic[l_ac].sic15
                    DISPLAY BY NAME g_sic[l_ac].sic07_fac   #TQC-BA0091 add
                 END IF   
              END IF
              LET l_cnt = 0
              IF g_argv1 = '3' AND g_sia.sia05 = '4' THEN
                 IF NOT cl_null(g_sic[l_ac].sic15) AND NOT cl_null(g_sic[l_ac].sic03) THEN
                    IF p_cmd = 'a' OR (p_cmd = 'u' AND g_sic[l_ac].sic03 <> g_sic_t.sic03) THEN 
                       SELECT COUNT(*) INTO l_cnt FROM sic_file
                        WHERE sic03 = g_sic[l_ac].sic03
                          AND sic15 = g_sic[l_ac].sic15
                       IF cl_null(l_cnt) THEN
                          LET l_cnt = 0
                       END IF
                       IF l_cnt > 0 THEN
                          CALL cl_err(g_sic[l_ac].sic03,'asf-192',0) 
                          NEXT FIELD sic03
                       END IF
                    END IF
                 END IF
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM inb_file 
                  WHERE inb01 = g_sic[l_ac].sic03
                 IF SQLCA.SQLCODE OR l_cnt < 1 THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-185',0)
                    NEXT FIELD sic03
                 END IF
                 SELECT inaconf,inapost INTO l_inaconf,l_inapost FROM ina_file
                  WHERE ina01 = g_sic[l_ac].sic03
                 IF l_inaconf <> 'Y' THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-191',0)
                    NEXT FIELD sic03  
                 END IF  
                 IF l_inapost  = 'Y' THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-297',0)#TQC-CB0044 mod asf-191===asf-297
                    NEXT FIELD sic03
                 END IF   
                 IF NOT cl_null(g_sic[l_ac].sic15) THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM inb_file
                     WHERE inb01 = g_sic[l_ac].sic03
                       AND inb03 = g_sic[l_ac].sic15
                    IF l_cnt < 1 THEN
                       CALL cl_err(g_sic[l_ac].sic03,'asf-185',0)
                       NEXT FIELD sic03
                    END IF 
                 END IF
              END IF
              IF g_argv1 = '3' AND g_sia.sia05 = '5' THEN
                 LET l_cnt = 0 
                 IF NOT cl_null(g_sic[l_ac].sic15) AND NOT cl_null(g_sic[l_ac].sic03) THEN
                    IF p_cmd = 'a' OR (p_cmd = 'u' AND g_sic[l_ac].sic03 <> g_sic_t.sic03) THEN
                       SELECT COUNT(*) INTO l_cnt FROM sic_file
                        WHERE sic03 = g_sic[l_ac].sic03
                          AND sic15 = g_sic[l_ac].sic15
                       IF cl_null(l_cnt) THEN
                          LET l_cnt = 0
                       END IF 
                       IF l_cnt > 0 THEN
                          CALL cl_err(g_sic[l_ac].sic03,'asf-192',0) 
                          NEXT FIELD sic03
                       END IF
                    END IF
                 END IF
                 SELECT COUNT(*) INTO l_cnt FROM imn_file
                  WHERE imn01 = g_sic[l_ac].sic03
                 IF SQLCA.SQLCODE OR l_cnt < 1 THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-187',0)
                    NEXT FIELD sic03
                 END IF     
                #SELECT immconf INTO l_immconf FROM imm_file    #TQC-B50052   
                 SELECT imm04,imm10,immconf INTO l_imm04,l_imm10,l_immconf FROM imm_file   #TQC-B50052
                  WHERE imm01 = g_sic[l_ac].sic03
                #IF l_immconf = 'Y' THEN                       #TQC-B50052
                #   CALL cl_err(g_sic[l_ac].sic03,'asf-191',0) #TQC-B50052
                 IF l_imm10 = '1' AND l_immconf <> 'Y' THEN    #TQC-B50052
                    CALL cl_err(g_sic[l_ac].sic03,'asf-191',0) #TQC-B50052
                    NEXT FIELD sic03
                 END IF
                 IF l_imm10 = '2' AND l_imm04 = 'Y' THEN       #TQC-B50052
                    CALL cl_err(g_sic[l_ac].sic03,'asf-169',0) #TQC-B50052 
                    NEXT FIELD sic03                           #TQC-B50052
                 END IF                                        #TQC-B50052 
                #TQC-CB0044--add--str
                 SELECT imm04 INTO l_imm03 FROM imm_file
                  WHERE imm01 = g_sic[l_ac].sic03
                 IF l_imm03 = 'Y' THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-297',0)
                    NEXT FIELD sic03
                 END IF
                #TQC-CB0044--add--end
                 LET l_cnt = 0
                 IF NOT cl_null(g_sic[l_ac].sic15) THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM imn_file
                     WHERE imn01 = g_sic[l_ac].sic03
                       AND imn02 = g_sic[l_ac].sic15
                    IF l_cnt < 1 THEN
                       CALL cl_err(g_sic[l_ac].sic03,'asf-187',0)
                       NEXT FIELD sic03
                    END IF
                 END IF
                 CALL i610_show_imn() 
                 IF g_success = 'N' THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-187',0)
                    NEXT FIELD sic03
                 END IF  
              END IF
           END IF
           #FUN-AC0074-------------------End---------------------- 
           IF NOT cl_null(g_sic[l_ac].sic03) THEN 
              IF g_argv1 = '1' THEN     #FUN-AC0074
                 CALL i610_sfb01(g_sic[l_ac].sic03)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_sic[l_ac].sic03,g_errno,0)
                    NEXT FIELD sic03
                 END IF
                 SELECT sfb02 INTO l_sfb02 FROM sfb_file
                  WHERE sfb01=g_sic[l_ac].sic03
                 IF l_sfb02 = '15' THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asr-047',1)   #所輸入之工單型態
                    NEXT FIELD sic03
                 END IF
           #FUN-AC0074 -----------------Begin---------------------
                 SELECT sfb04 INTO l_sfb04 FROM sfb_file
                  WHERE sfb01 = g_sic[l_ac].sic03
                 IF l_sfb04 NOT MATCHES'[1237]' THEN
                    CALL cl_err(g_sic[l_ac].sic03,'asf-194',0)
                    NEXT FIELD sic03
                 END IF
           #FUN-AC0074 -----------------End-----------------------
                 
                 IF g_sia.sia04 = '2' THEN  
                   SELECT COUNT(*) INTO l_n FROM sie_file
                      WHERE sie11 > 0 
                      AND sie05 = g_sic[l_ac].sic03
                   IF l_n = 0 THEN
                       CALL cl_err(g_sic[l_ac].sic03,'asf-999',1)
                       NEXT FIELD sic03
                   END IF
                 END IF 
                 SELECT * INTO g_sfb.* FROM sfb_file
                  WHERE sfb01=g_sic[l_ac].sic03 AND sfbacti='Y' AND sfb87!='X'
                 IF STATUS THEN
                    CALL cl_err3("sel","sfb_file",g_sic[l_ac].sic03,"",STATUS,"","sel sfb",1)  #No.FUN-660128
                    NEXT FIELD sic03  
                 END IF
 
                 IF g_sfb.sfb81 > g_sia.sia02 THEN
                    CALL cl_err(g_sic[l_ac].sic03,'sia-004',0) NEXT FIELD sic03
                 END IF
                 IF g_sfb.sfb04!='2' THEN
                    CALL cl_err('sfb04!=2','sia-002',0) NEXT FIELD sic03
                 END IF
                 IF g_sfb.sfb04='8' THEN
                    CALL cl_err('sfb04=8','sia-003',0) NEXT FIELD sic03
                 END IF
                 IF g_sfb.sfb02=13 THEN   
                    CALL cl_err('sfb02=13','asf-346',0) NEXT FIELD sic03
                 END IF
#FUN-B20009 ------------------Begin---------------------
                 IF g_sma.sma541 = 'Y' THEN
                    IF p_cmd = 'a' THEN
                       CALL i610_sic013_default()
                       IF g_success = 'N' THEN
                          NEXT FIELD sic03
                       END IF
                    END IF
                 END IF
#FUN-B20009 ------------------End-----------------------
#FUN-AC0074 ------------------Begin---------------------
                 IF g_sia.sia04 = '2' THEN
                    IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06 = 0 THEN
                       CALL i610_sum_sic06()
                    END IF
                 END IF
#FUN-AC0074 ------------------End-----------------------

            # END IF  #FUN-AC0074
 
                 #判斷被替代料須存在于備料檔中
                 IF NOT cl_null(g_sic[l_ac].sic04) AND
                    NOT cl_null(g_sic[l_ac].sic05) AND 
                    NOT cl_null(g_sic[l_ac].sic03) THEN
                    SELECT COUNT(*) INTO l_n FROM sfa_file
                     WHERE sfa01 = g_sic[l_ac].sic03
                       AND sfa03 = g_sic[l_ac].sic05
                       AND sfa27 = g_sic[l_ac].sic04
                    IF l_n <=0 THEN
                       CALL cl_err('','asf-340',1) 
                       NEXT FIELD sic03
                    END IF 
                 END IF 
              END IF    #FUN-AC0074
           END IF       #FUN-AC0074 
#FUN-AC0074 ---------------Begin----------------------
           IF NOT cl_null(g_sic[l_ac].sic03) THEN
              IF g_argv1 = '3' AND g_sia.sia05 = '4' THEN
                 IF NOT cl_null(g_sic[l_ac].sic15) THEN
                    IF p_cmd = 'a' OR (p_cmd = 'u' AND g_sic[l_ac].sic03 <> g_sic_t.sic03)
                                   OR (p_cmd = 'u' AND g_sic[l_ac].sic15 <> g_sic_t.sic15) THEN                        
                       IF NOT i610_sic03_chk() THEN
                          NEXT FIELD sic03
                       END IF
                    END IF   
                    CALL i610_display()
                    IF g_success = 'N' THEN
                       NEXT FIELD sic03
                    ELSE
                       DISPLAY g_sic[l_ac].sic03 TO sic03                
                    END IF
                 END IF
              END IF
           END IF
           IF g_argv1 MATCHES'[23]' THEN
              IF NOT cl_null(g_sic[l_ac].sic04) THEN
                 LET g_sic[l_ac].sic05 = g_sic[l_ac].sic04
              END IF
           END IF 
#FUN-AC0074 ---------------End------------------------
           #TQC-D10061--begin
           IF NOT cl_null(g_sic[l_ac].sic04) THEN
              SELECT ima02,ima021 INTO g_sic[l_ac].ima02,g_sic[l_ac].ima021 FROM ima_file
               WHERE ima01 = g_sic[l_ac].sic04
           END IF
           #TQC-D10061--end

#FUN-AC0074 ---------------Begin----------------------
         AFTER FIELD sic15
            IF NOT cl_null(g_sic[l_ac].sic15) THEN  
               IF g_argv1 = '2' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM oeb_file
                   WHERE oeb01 = g_sic[l_ac].sic03
                     AND oeb03 = g_sic[l_ac].sic15
                  IF l_cnt <= 0 THEN
                     CALL cl_err(g_sic[l_ac].sic03,'asf-186',0) 
                     NEXT FIELD sic15
                  END IF
                  #TQC-BA0091 ----- start -----
                  #SELECT oeb12,oeb24,oeb05,oeb04 INTO g_sic[l_ac].sfa05,g_sic[l_ac].sfa06,
                  #                                    g_sic[l_ac].sic07,g_sic[l_ac].sic04
                  SELECT oeb12,oeb24,oeb05,oeb04,oeb05_fac INTO g_sic[l_ac].sfa05,g_sic[l_ac].sfa06,
                                                                 g_sic[l_ac].sic07,g_sic[l_ac].sic04,
                                                                 g_sic[l_ac].sic07_fac
                  #TQC-BA0091 -----  end  -----
                    FROM oeb_file 
                   WHERE oeb01 = g_sic[l_ac].sic03
                     AND oeb03 = g_sic[l_ac].sic15
                  DISPLAY BY NAME g_sic[l_ac].sfa05
                  DISPLAY BY NAME g_sic[l_ac].sfa06
                  DISPLAY BY NAME g_sic[l_ac].sic07
                  DISPLAY BY NAME g_sic[l_ac].sic07_fac    #TQC-BA0091 add
               END IF
               IF g_argv1 = '3' AND g_sia.sia05 = '4' THEN
                  IF NOT cl_null(g_sic[l_ac].sic03) AND NOT cl_null(g_sic[l_ac].sic15) THEN
                     LET l_cnt = 0
                     IF p_cmd = 'a' OR (p_cmd = 'u' AND g_sic[l_ac].sic15 <> g_sic_t.sic15) THEN
                        SELECT COUNT(*) INTO l_cnt FROM sic_file
                         WHERE sic03 = g_sic[l_ac].sic03
                           AND sic15 = g_sic[l_ac].sic15
                        IF cl_null(l_cnt) THEN
                           LET l_cnt = 0
                        END IF
                        IF l_cnt > 0 THEN
                           CALL cl_err(g_sic[l_ac].sic03,'asf-192',0)
                           NEXT FIELD sic15
                        END IF
                     END IF
                  END IF
                  LET g_success = 'Y'
                  IF p_cmd = 'a' OR (p_cmd = 'u' AND g_sic[l_ac].sic03 <> g_sic_t.sic03)
                                   OR (p_cmd = 'u' AND g_sic[l_ac].sic15 <> g_sic_t.sic15) THEN
                     IF NOT i610_sic03_chk() THEN
                        NEXT FIELD sic03
                     END IF
                  END IF
                  CALL i610_display()
                  IF g_success = 'N' THEN
                      NEXT FIELD sic15
                  END IF
                  LET g_sic[l_ac].sic05 = g_sic[l_ac].sic04
               END IF 
               IF g_argv1 = '3' AND g_sia.sia05 = '5' THEN
                 LET l_cnt = 0  
                 IF NOT cl_null(g_sic[l_ac].sic15) AND NOT cl_null(g_sic[l_ac].sic03) THEN
                    IF p_cmd = 'a' OR (p_cmd = 'u' AND g_sic[l_ac].sic15 <> g_sic_t.sic15) THEN
                       SELECT COUNT(*) INTO l_cnt FROM sic_file
                        WHERE sic03 = g_sic[l_ac].sic03
                          AND sic15 = g_sic[l_ac].sic15
                       IF cl_null(l_cnt) THEN
                          LET l_cnt = 0
                       END IF
                       IF l_cnt > 0 THEN
                          CALL cl_err(g_sic[l_ac].sic03,'asf-192',0)
                          NEXT FIELD sic15
                       END IF
                    END IF
                 END IF             
                  CALL i610_show_imn()
                  IF g_success = 'N' THEN
                     CALL cl_err(g_sic[l_ac].sic03,'asf-187',0)
                     NEXT FIELD sic15
                  END IF
                  LET g_sic[l_ac].sic05 = g_sic[l_ac].sic04
               END IF 
            END IF
            IF g_argv1 MATCHES'[23]' THEN
               IF NOT cl_null(g_sic[l_ac].sic04) THEN
                  LET g_sic[l_ac].sic05 = g_sic[l_ac].sic04
               END IF
            END IF
#FUN-AC0074 ---------------End------------------------

         AFTER FIELD sic05
           IF NOT cl_null(g_sic[l_ac].sic05) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_sic[l_ac].sic05,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_sic[l_ac].sic05= g_sic_t.sic05
                 NEXT FIELD sic05
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              SELECT COUNT(*) INTO g_cnt FROM sic_file
               WHERE sic01=g_sia.sia01
                 AND sic02<>g_sic[l_ac].sic02
                 AND sic05=g_sic[l_ac].sic05
              IF g_cnt>0 THEN CALL cl_err('','aim-401',0) END IF
 
              SELECT ima25 INTO l_b2
                FROM ima_file WHERE ima01=g_sic[l_ac].sic05 AND imaacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",g_sic[l_ac].sic05,"",STATUS,"","sel ima",1)  #No.FUN-660128
                 NEXT FIELD sic05
              END IF
 
             #SELECT COUNT(*),MIN(sfa12),MIN(sfa08)              #FUN-AC0074
             #     INTO l_n, l_b2, l_b3                          #FUN-AC0074
              SELECT COUNT(*),MIN(sfa12),MIN(sfa08),MIN(sfa012),MIN(sfa013)     #FUN-AC0074
                   INTO l_n, l_b2, l_b3,g_sic[l_ac].sic012,g_sic[l_ac].sic013   #FUN-AC0074
              FROM sfa_file
              WHERE sfa01=g_sic[l_ac].sic03
                AND (sfa03=g_sic[l_ac].sic05 OR sfa03=b_sic.sic04)
                 IF l_n=0 THEN
                    CALL cl_err('sel sfa',100,0) NEXT FIELD sic03
                 END IF
                 IF cl_null(l_b2) THEN LET l_b2 = ' ' END IF
                 IF cl_null(l_b3) THEN LET l_b3 = ' ' END IF
                 IF cl_null(g_sic[l_ac].sic07) THEN
                    LET g_sic[l_ac].sic07=l_b2
                 END IF
                 IF cl_null(g_sic[l_ac].sic11) THEN
                    LET g_sic[l_ac].sic11=l_b3
                 END IF
              CALL s_schdat_ecm014(g_sic[l_ac].sic03,g_sic[l_ac].sic012)  #FUN-B20009
                   RETURNING g_sic[l_ac].ecm014                           #FUN-B20009
              DISPLAY BY NAME g_sic[l_ac].sic07
              DISPLAY BY NAME g_sic[l_ac].sic11
              DISPLAY BY NAME g_sic[l_ac].sic012    #FUN-B20009
              DISPLAY BY NAME g_sic[l_ac].sic013    #FUN-B20009
              DISPLAY BY NAME g_sic[l_ac].ecm014    #FUN-B20009
           END IF
          #FUN-AC0074 -------------Begin----------------------
          #IF g_sma.sma115 = 'Y' THEN
          #   IF NOT cl_null(g_sic[l_ac].sic05) THEN
          #      CALL s_chk_va_setting(g_sic[l_ac].sic05)
          #          RETURNING g_flag,g_ima906,g_ima907
          #      SELECT ima55 INTO g_ima55
          #        FROM ima_file WHERE ima01=g_sic[l_ac].sic05
          #      IF g_flag=1 THEN
          #         NEXT FIELD sic05
          #      END IF
          #   END IF
          #END IF
          #FUN-AC0074 -------------End------------------------
          IF  (p_cmd='a') OR (g_sic_t.sic05 <> g_sic[l_ac].sic05) THEN
             SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
              WHERE sfa01=g_sic[l_ac].sic03
                AND sfa03=g_sic[l_ac].sic05
                AND sfa12=g_sic[l_ac].sic07
                AND sfa08=g_sic[l_ac].sic11
          END IF
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_sic[l_ac].sic04) AND 
              NOT cl_null(g_sic[l_ac].sic03) AND 
              NOT cl_null(g_sic[l_ac].sic05) THEN
              SELECT COUNT(*) INTO l_n FROM sfa_file
               WHERE sfa01 = g_sic[l_ac].sic03
                 AND sfa03 = g_sic[l_ac].sic05
                 AND sfa27 = g_sic[l_ac].sic04
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD sic05
              END IF 
           END IF 
#FUN-AC0074 ------------------Begin---------------------
           IF NOT cl_null(g_sic[l_ac].sic05) THEN
              IF g_sia.sia04 = '2' THEN
                 IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06 = 0 THEN
                    CALL i610_sum_sic06()
                 END IF
              END IF
           END IF
           CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
                                 g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                                 g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
               RETURNING m_img10,m_sic06,m_sig05
           IF (m_img10-m_sig05) < m_sic06 THEN
              CALL cl_err(g_sic[l_ac].sic05,'sie-002',0)
              NEXT FIELD sic05
           END IF
#FUN-AC0074 ------------------End-----------------------
 
         AFTER FIELD sic04
           #當"工單單號+發料料號"依序判斷其中有一個位空時候,則NEXT FIELD到空的欄位
           IF cl_null(g_sic[l_ac].sic03) THEN
              NEXT FIELD sic03
           END IF
           #TQC-D10061--begin
           IF NOT cl_null(g_sic[l_ac].sic04) THEN
              SELECT ima02,ima021 INTO g_sic[l_ac].ima02,g_sic[l_ac].ima021 FROM ima_file
               WHERE ima01 = g_sic[l_ac].sic04
           END IF
           #TQC-D10061--end
           IF g_argv1 = '1' THEN     #FUN-AC0074
              IF cl_null(g_sic[l_ac].sic05) THEN
                 NEXT FIELD sic05
              END IF
              #判斷被替代料須存在于備料檔中
              IF NOT cl_null(g_sic[l_ac].sic04) THEN
                 SELECT COUNT(*) INTO l_n FROM sfa_file
                  WHERE sfa01 = g_sic[l_ac].sic03
                    AND sfa03 = g_sic[l_ac].sic05
                    AND sfa27 = g_sic[l_ac].sic04
                 IF l_n <=0 THEN
                    CALL cl_err('','asf-340',1) 
                    NEXT FIELD sic04
                 END IF 
              END IF 
              #FUN-AC0074 ------Begin----------
              IF g_sia.sia04 = '2' THEN
                 IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06 = 0 THEN
                    CALL i610_sum_sic06()
                 END IF
              END IF
              #FUN-AC0074 ------End------------
           END IF       #FUN-AC0074
#FUN-AC0074 -----------------Begin----------------------
           IF g_argv1 = '2' THEN
              CALL i610_img10_count(g_sic[l_ac].sic04,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
                                    g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                                    g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
                  RETURNING m_img10,m_sic06,m_sig05
              IF (m_img10-m_sig05) < m_sic06 THEN
                 CALL cl_err(g_sic[l_ac].sic04,'sie-002',0)
                 NEXT FIELD sic04
              END IF
              IF NOT cl_null(g_sic[l_ac].sic15) THEN
                 SELECT oeb04 INTO l_oeb04 FROM oeb_file
                  WHERE oeb01 = g_sic[l_ac].sic03
                    AND oeb03 = g_sic[l_ac].sic15
                 IF l_oeb04 <> g_sic[l_ac].sic04 THEN
                    CALL cl_err(g_sic[l_ac].sic04,'asf-184',0)
                    NEXT FIELD sic04
                 END IF 
                 SELECT ima25 INTO l_ima25 FROM ima_file
                  WHERE ima01= g_sic[l_ac].sic04
                 CALL s_umfchk(g_sic[l_ac].sic04,g_sic[l_ac].sic07,l_ima25)
                    RETURNING l_flag,l_fac
                 IF l_flag THEN
                    CALL cl_err('','',0)
                 ELSE
                    LET l_sic06=g_sic[l_ac].sic06 * l_fac
                    #No.FUN-BB0086--add--begin--
                    LET l_sic06=s_digqty(l_sic06,l_ima25)
                    DISPLAY BY NAME l_sic06
                    #No.FUN-BB0086--add--end--
                 END IF
              END IF
              LET g_sic[l_ac].sic05 = g_sic[l_ac].sic04
           END IF
#FUN-AC0074 -----------------END--------------------------
          
#FUN-B20009 ----------------------Begin-----------------------
        AFTER FIELD sic012 
           IF NOT cl_null(g_sic[l_ac].sic012) THEN
              CALL s_schdat_ecm014(g_sic[l_ac].sic03,g_sic[l_ac].sic012) 
                   RETURNING g_sic[l_ac].ecm014                         
              DISPLAY g_sic[l_ac].ecm014 TO ecm014
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM sfa_file
               WHERE sfa01 = g_sic[l_ac].sic03 
                 AND sfa03 = g_sic[l_ac].sic05
                 AND sfa012 = g_sic[l_ac].sic012
              IF l_n = 0 THEN
                 CALL cl_err('sel sfa',100,0)
                 NEXT FIELD sic012
              END IF  
              IF g_sma.sma541 = 'Y' THEN
                 IF p_cmd = 'a' THEN
                    CALL i610_sic013_default()
                    IF g_success = 'N' THEN
                       NEXT FIELD sic012
                    END IF
                 END IF 
              END IF
              LET l_n = 0
              IF p_cmd = 'u' AND g_sic[l_ac].sic012 ! = g_sic_t.sic012 THEN
                 SELECT COUNT(*) INTO l_n FROM sfa_file
                  WHERE sfa01 = g_sic[l_ac].sic03
                    AND sfa03 = g_sic[l_ac].sic05
                    AND sfa08 = g_sic[l_ac].sic11
                    AND sfa012 = g_sic[l_ac].sic012
                    AND sfa013 = g_sic[l_ac].sic013      
                 IF l_n = 0 THEN 
                    CALL cl_err('sel sfa',100,0)
                    NEXT FIELD sic012
                 END IF
              END IF
              #FUN-AC0074 ------Begin----------
              IF g_sia.sia04 = '2' THEN
                 IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06 = 0 THEN
                    CALL i610_sum_sic06()
                 END IF 
              END IF
              #FUN-AC0074 ------End------------
           END IF  


           IF NOT cl_null(g_sic[l_ac].sic013) THEN 
              IF (p_cmd = 'u') OR (g_sic[l_ac].sic013 ! = g_sic_t.sic013) THEN
                 IF cl_null(g_sic[l_ac].sic11) THEN
                    DECLARE i610_cs_sfa08 CURSOR FOR
                       SELECT DISTINCT sfa08 INTO g_sic[l_ac].sic11 FROM sfa_file
                        WHERE sfa01 = g_sic[l_ac].sic03
                          AND sfa012 = g_sic[l_ac].sic012                 
                          AND sfa013 = g_sic[l_ac].sic013 
                          AND sfa03 = g_sic[l_ac].sic05
                    FOREACH i610_cs_sfa08 INTO l_sfa08 
                       IF STATUS THEN
                          CALL cl_err(g_sic[l_ac].sic03,'asf-193',0)
                          NEXT FIELD sic013
                       END IF      
                       IF NOT cl_null(l_sfa08) then
                          LET g_sic[l_ac].sic11 = l_sfa08
                          EXIT FOREACH
                       END IF
                    END FOREACH 
                    DISPLAY BY NAME g_sic[l_ac].sic11
                 ELSE
                    SELECT COUNT(*) INTO l_n FROM sfa_file
                     WHERE sfa01 = g_sic[l_ac].sic03
                       AND sfa03 = g_sic[l_ac].sic05     
                       AND sfa08 = g_sic[l_ac].sic11
                       AND sfa012 = g_sic[l_ac].sic012   
                       AND sfa013 = g_sic[l_ac].sic013
                    IF l_n=0 THEN 
                       CALL cl_err('sel sfa',100,0)
                       NEXT FIELD sic013
                    END IF
                 END IF
             END IF 
             #FUN-AC0074 ------Begin----------
             IF g_sia.sia04 = '2' THEN
                IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06=0 THEN 
                   CALL i610_sum_sic06()
                END IF 
             END IF   
             SELECT COUNT(*) INTO l_n FROM sfa_file
              WHERE sfa01 = g_sic[l_ac].sic03
                AND sfa03 = g_sic[l_ac].sic05 
                AND sfa08 = g_sic[l_ac].sic11
                AND sfa012 = g_sic[l_ac].sic012
                AND sfa013 = g_sic[l_ac].sic013
             IF l_n=0 THEN
                CALL cl_err('sel sfa',100,0)
                NEXT FIELD sic013
             END IF
             #FUN-AC0074 ------End------------
          END IF
#FUN-B20009 ----------------------End-------------------------
          
         AFTER FIELD sic07
            IF NOT cl_null(g_sic[l_ac].sic07) THEN
               SELECT gfe02 INTO g_buf FROM gfe_file
                WHERE gfe01=g_sic[l_ac].sic07
               IF STATUS THEN
                  CALL cl_err3("sel","gfe_file",g_sic[l_ac].sic06,"",STATUS,"","gfe:",1)  
                  NEXT FIELD sic07
               END IF
               IF g_argv1 = '1' THEN     #FUN-AC0074
                  SELECT COUNT(*) INTO l_n FROM sfa_file
                   WHERE sfa01=g_sic[l_ac].sic03
                     AND (sfa03=g_sic[l_ac].sic05 OR sfa27=b_sic.sic04)
                     AND sfa12=g_sic[l_ac].sic07
                  IF l_n=0 THEN
                     CALL cl_err('sel sfa',100,0) NEXT FIELD sic07
                  END IF
               #FUN-AC0074 ------Begin-----------
                  SELECT ima25 INTO l_ima25 FROM ima_file
                   WHERE ima01 = g_sic[l_ac].sic05
                  CALL s_umfchk(g_sic[l_ac].sic05,g_sic[l_ac].sic07,l_ima25)
                       RETURNING l_flag,l_fac
                  LET  g_sic[l_ac].sic07_fac = l_fac
               END IF   
               IF g_sia.sia04 = '2' THEN
                  IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06 = 0 THEN
                     CALL i610_sum_sic06()
                  END IF
               END IF
               
               IF g_argv1 = '2' THEN 
                  SELECT ima25 INTO l_ima25 FROM ima_file
                   WHERE ima01 = g_sic[l_ac].sic04
                  CALL s_umfchk(g_sic[l_ac].sic04,g_sic[l_ac].sic07,l_ima25)
                       RETURNING l_flag,l_fac
                  LET  g_sic[l_ac].sic07_fac = l_fac
               END IF
               CALL i610sub_chk_sic06(g_sia.sia04,g_argv1,g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03,g_sic[l_ac].sic05,g_sic[l_ac].sic06,
                                      g_sic[l_ac].sic07,g_sic[l_ac].sic11,g_sic[l_ac].sic15,g_sic[l_ac].sic012,g_sic[l_ac].sic013 )
               IF g_success = 'N' THEN
                  NEXT FIELD sic06
               END IF
               #FUN-AC0074 ------End------------
               
               #No.FUN-BB0086--add---start---
               LET l_case = ''
               IF NOT cl_null(g_sic[l_ac].sic06) AND g_sic[l_ac].sic06<>0 THEN   #FUN-C20068 add
                  CALL i610_sic06_check(l_sic06x,m_img10,m_sic06,m_sig05,l_sic06) RETURNING l_tf,l_case
               END IF                                                            #FUN-C20068 add
               LET g_sic07_t = g_sic[l_ac].sic07
               IF NOT l_tf THEN 
                  case l_case 
                     WHEN 'sic06'
                        NEXT FIELD sic06
                     WHEN 'sic11'
                        NEXT FIELD sic11
                     OTHERWISE EXIT CASE 
                  END CASE    
               END IF 
               #No.FUN-BB0086--add---end---
            END IF
 
        AFTER FIELD sic11
           IF cl_null(g_sic[l_ac].sic11) THEN 
              LET g_sic[l_ac].sic11=' ' 
           ELSE 
              CALL i610_sic11(g_sic[l_ac].sic11) RETURNING g_errno
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sic[l_ac].sic11,g_errno,1)
                NEXT FIELD sic11
              END IF 
           END IF
              
          # LET l_cn = 0 
          # SELECT COUNT(*) INTO l_cn FROM sfa_file
          #    WHERE sfa01 = g_sic[l_ac].sic03
          #      AND sfa03 = g_sic[l_ac].sic05
          #       AND sfa08 = g_sic[l_ac].sic11
    
 
          # IF l_cn = 0 THEN
          #    CALL cl_err(g_sic[l_ac].sic11,'asf-905',0)
          #    NEXT FIELD sic11
          # END IF      
           
#作業編號
           IF NOT cl_null(g_sic[l_ac].sic11) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecd_file
               WHERE ecd01=g_sic[l_ac].sic11
              IF g_cnt=0 THEN
                 CALL cl_err('sel ecd_file',100,0)
                 NEXT FIELD sic11
              END IF
           END IF 
           
           SELECT SUM(sfa05-sfa065),SUM(sfa06)  # 扣除代買部分                
               INTO g_sic[l_ac].sfa05,g_sic[l_ac].sfa06                         
           FROM sfa_file
               WHERE sfa01=g_sic[l_ac].sic03
               AND sfa03=g_sic[l_ac].sic05  
               AND sfa12=g_sic[l_ac].sic07
               AND sfa08=g_sic[l_ac].sic11
               AND sfa27=g_sic[l_ac].sic04 
               AND sfa012 = g_sic[l_ac].sic012  #FUN-B20009
               AND sfa013 = g_sic[l_ac].sic013  #FUN-B20009
               IF SQLCA.SQLCODE THEN
                   LET g_sic[l_ac].sfa05 = 0 LET g_sic[l_ac].sfa06 = 0 
               END IF
           DISPLAY BY NAME g_sic[l_ac].sfa05
           DISPLAY BY NAME g_sic[l_ac].sfa06

           IF g_sic[l_ac].sfa05<=g_sic[l_ac].sfa06 THEN
              CALL cl_err('sfa05<=sfa06','sia-009',0) NEXT FIELD sic11
           END IF 
#FUN-AC0074 ------------Begin---------------
          IF g_sia.sia04 = '2' THEN
             IF g_sic[l_ac].sic06 IS NULL OR g_sic[l_ac].sic06=0 THEN
                CALL i610_sum_sic06()
             END IF
          END IF
#FUN-AC0074 ------------End-----------------
#FUN-B20009 -------------------------Begin----------------------------
           IF g_sma.sma541 = 'Y' THEN
              IF p_cmd = 'a' THEN
                 CALL i610_sic013_default()
                 IF g_success = 'N' THEN
                    NEXT FIELD sic11
                 END IF
              END IF
              IF p_cmd = 'u' AND g_sic[l_ac].sic11 ! = g_sic_t.sic11 THEN
                 CALL i610_sic013_default()
                 IF g_success = 'N' THEN
                    NEXT FIELD sic11
                 END IF
              END IF
           END IF
#FUN-B20009 -------------------------End------------------------------
        AFTER FIELD sic08
#FUN-AC0074 --------------------Begin----------------------
           IF g_sic[l_ac].sic08 = '　' THEN #全型空白
              LET g_sic[l_ac].sic08 = ' '
           END IF
           IF g_sic[l_ac].sic08 IS NULL THEN
              LET g_sic[l_ac].sic08 =' '
           END IF
           CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
                                 g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                                 g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
               RETURNING m_img10,m_sic06,m_sig05
           IF (m_img10-m_sig05) < m_sic06 THEN
              CALL cl_err(g_sic[l_ac].sic05,'sie-002',0)
             #NEXT FIELD sic08 #MOD-CC0185 mark
           END IF
#FUN-AC0074 --------------------End------------------------
           IF NOT cl_null(g_sic[l_ac].sic08) THEN
              #FUN-D20060 add str
              IF NOT s_chksmz(g_sic[l_ac].sic05, g_sia.sia01,
                          g_sic[l_ac].sic08, g_sic[l_ac].sic09) THEN
                 NEXT FIELD sic08
              END IF
              #FUN-D20060 add end
              SELECT imd02 INTO g_buf FROM imd_file  
               WHERE imd01=g_sic[l_ac].sic08
                  AND imdacti = 'Y' 
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",g_sic[l_ac].sic08,"",STATUS,"","sel imd",1)  
                 NEXT FIELD sic08
              END IF
              #Add No.FUN-AB0046
              IF NOT s_chk_ware(g_sic[l_ac].sic08) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD sic08
              END IF
              #End Add No.FUN-AB0046
              SELECT ima108 INTO l_ima108 FROM ima_file
               WHERE ima01=g_sic[l_ac].sic05
              IF l_ima108='Y' THEN        #若為SMT料必須檢查是否會WIP倉
                 SELECT COUNT(*) INTO l_n FROM imd_file
                  WHERE imd01=g_sic[l_ac].sic08 AND imd10='W'
                     AND imdacti = 'Y' 
                  LET g_msg = g_sic[l_ac].sic05," ",g_sic[l_ac].sic08  
                 IF l_n = 0 THEN
                    CALL cl_err(g_msg,'asf-724',0) NEXT FIELD sic07                   
                 END IF
              END IF
              #FUN-A50023 add --begin
              IF g_sia.sia04 = '2' THEN 
                LET l_cnt = 0
                IF NOT cl_null(g_sic[l_ac].sic03) AND NOT cl_null(g_sic[l_ac].sic05) THEN 
                 SELECT COUNT(*) INTO l_cnt FROM sie_file 
                    WHERE sie05 = g_sic[l_ac].sic03 
                     AND sie01 = g_sic[l_ac].sic05
                     AND sie02 = g_sic[l_ac].sic08
                     AND sie11 > 0 
                 IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
                 IF l_cnt <= 0 THEN  
                    CALL cl_err(g_sic[l_ac].sic05,'sie-105',1)
                    NEXT FIELD sic08
                 END IF 
                END IF 
              END IF 
              #FUN-A50023 add --end    
           END IF
        AFTER FIELD sic09
           #BugNo:5626 控管是否為全型空白
           IF g_sic[l_ac].sic09 = '　' THEN #全型空白
               LET g_sic[l_ac].sic09 = ' '
           END IF
           IF g_sic[l_ac].sic09 IS NULL THEN LET g_sic[l_ac].sic09 =' ' END IF
           #MOD-CC0185 add start -----
           CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
                                  g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                                  g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
                RETURNING m_img10,m_sic06,m_sig05
           IF (m_img10 - m_sig05)< m_sic06 THEN
              CALL cl_err(g_sic[l_ac].sic09,'sie-002',0)
           END IF
           #MOD-CC0185 add end   -----
          #FUN-AC0074 -------------------Begin---------------------------------
          ##------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_sic[l_ac].sic08) THEN #FUN-D20060 add
          #FUN-D20060 還原
             IF NOT s_chksmz(g_sic[l_ac].sic05, g_sia.sia01,
                          g_sic[l_ac].sic08, g_sic[l_ac].sic09) THEN
                NEXT FIELD sic08
             END IF
          #FUN-D20060 還原
           END IF #FUN-D20060 add
          ##------------------------------------------------------  roger
          #FUN-AC0074 -------------------End-----------------------------------
 
        AFTER FIELD sic10
                   #BugNo:5626 控管是否為全型空白
           IF g_sic[l_ac].sic10 = '　' THEN #全型空白
               LET g_sic[l_ac].sic10 = ' '
           END IF
           IF g_sic[l_ac].sic10 IS NULL THEN LET g_sic[l_ac].sic10 =' ' END IF 
           #MOD-CC0185 add start -----
           CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
                                  g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                                  g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
                RETURNING m_img10,m_sic06,m_sig05
           IF (m_img10 - m_sig05)< m_sic06 THEN
              CALL cl_err(g_sic[l_ac].sic10,'sie-002',0)
           END IF
           #MOD-CC0185 add end   -----
          #FUN-AC0074 -----------------------Begin----------------------------  
          #   SELECT img09 INTO g_img09
          #           FROM img_file
          #          WHERE img01=g_sic[l_ac].sic05 AND img02=g_sic[l_ac].sic08
          #            AND img03=g_sic[l_ac].sic09 AND img04=g_sic[l_ac].sic10
          #IF g_argv1=1 AND STATUS THEN    
          #   CALL cl_err('sel img:',STATUS,0) 
          #   NEXT FIELD sic08 
          #END IF
          #IF g_argv1=2 AND STATUS=100 THEN      
          #   IF g_sma.sma892[3,3] = 'Y' THEN
          #      IF NOT cl_confirm('mfg1401') THEN NEXT FIELD sic10 END IF
          #   END IF
          #      CALL s_add_img(g_sic[l_ac].sic05, g_sic[l_ac].sic08,
          #                     g_sic[l_ac].sic09, g_sic[l_ac].sic10,
          #                     g_sia.sia01,g_sic[l_ac].sic02,
          #                     g_sia.sia02)
          #   IF g_errno='N' THEN NEXT FIELD sic10 END IF
          #END IF
          #IF g_sma.sma115 = 'N' THEN
          #   IF g_sic[l_ac].sic07<>g_img09 THEN
          #      IF g_argv1 = '1' THEN   #FUN-AC0074
          #         CALL s_umfchk(g_sic[l_ac].sic05,g_sic[l_ac].sic07,g_img09)
          #              RETURNING l_flag,l_factor
          #      END IF       #FUN-AC0074
          #      IF l_flag THEN
          #         CALL cl_err('sic06<>img09:','asf-400',0) NEXT FIELD sic10
          #      END IF
          #   ELSE
          #      LET l_factor = 1
          #   END IF
          #END IF
          #   SELECT COUNT(*) INTO g_cnt FROM img_file
          #      WHERE img01 = g_sic[l_ac].sic05   #料號
          #        AND img02 = g_sic[l_ac].sic08   #倉庫
          #        AND img03 = g_sic[l_ac].sic09   #儲位
          #        AND img04 = g_sic[l_ac].sic10   #批號
          #        AND img18 < g_sia.sia03         #過帳日    
           LET l_sql = "SELECT COUNT(*) FROM img_file",
                       " WHERE img01 = '",g_sic[l_ac].sic05,"'",
                       "   AND img18 < '",g_sia.sia03,"'",
                       "   AND img03 = '",g_sic[l_ac].sic09,"'",
                       "   AND img04 = '",g_sic[l_ac].sic10,"'"      
           IF NOT cl_null(g_sic[l_ac].sic08) THEN
              LET l_sql = l_sql CLIPPED," AND img02 = '",g_sic[l_ac].sic08,"'"
           END IF
           PREPARE i600_pre1 FROM l_sql
           DECLARE i600_img_count CURSOR FOR i600_pre1
           OPEN i600_img_count
           IF SQLCA.sqlcode THEN
              CALL cl_err('',SQLCA.sqlcode,0)
              CLOSE i600_img_count
           ELSE
              FETCH i600_img_count INTO g_cnt
              IF SQLCA.sqlcode THEN
                  CALL cl_err('i600_img_count:',SQLCA.sqlcode,0)
                  CLOSE i600_img_count
              END IF
           END IF
          #FUN-AC0074 -----------------------End-----------------------------
              IF g_cnt > 0 THEN    #大於有效日期
                 call cl_err('','aim-400',0)   #須修改
                 NEXT FIELD sic08
              END IF

        AFTER FIELD sic06
           #No.FUN-BB0086--add---start---
           LET l_case = ''
           CALL i610_sic06_check(l_sic06x,m_img10,m_sic06,m_sig05,l_sic06) RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              case l_case 
                 WHEN 'sic06'
                    NEXT FIELD sic06
                 WHEN 'sic11'
                    NEXT FIELD sic11
                 OTHERWISE EXIT CASE 
              END CASE    
           END IF 
           #No.FUN-BB0086--add---end---
           
           #No.FUN-BB0086--mark---start---
           #IF NOT cl_null(g_sia.sia04) THEN                                                                                                                                            
           #   IF NOT cl_null(g_sic[l_ac].sic06) THEN
           #      IF g_argv1 = '1' THEN   #FUN-AC0074
           #         IF cl_null(g_sic[l_ac].sic05) OR cl_null(g_sic[l_ac].sic04) THEN
           #            CALL cl_err('','asf-878',1)
           #            NEXT FIELD CURRENT
           #         END IF
           #      END IF    #FUN-AC0074
           ##FUN-AC0074 ------------Begin--------------
           #      IF g_argv1 = '2' THEN 
           #         IF cl_null(g_sic[l_ac].sic04) THEN
           #            CALL cl_err('','asf-878',1)
           #            NEXT FIELD CURRENT
           #         END IF
           #      END IF 
           ##FUN-AC0074 ------------End----------------
           #   END IF
           #   IF g_sic[l_ac].sic06 >0 THEN                                                                                         
           #      IF (g_sic[l_ac].sfa05 = 0 OR cl_null(g_sic[l_ac].sfa05)) THEN  
           #         CALL cl_err('','sia-100',0)                                                                                        
           #         NEXT FIELD sic11                                                                                                   
           #      END IF                                                                                                                
           #   END IF                                                                                                                
           #   IF g_sia.sia04 MATCHES '[1]' THEN                                                                                                                                 
           #      IF g_sic[l_ac].sic06 <0 THEN                                                                                                                                                          
           #         CALL cl_err(g_sic[l_ac].sic06,"sia-101",1)                                                                                                               
           #         NEXT FIELD sic06                                                                                                                            
           #      END IF                                                                                                                                                        
           #      # 同一張備料單也考慮單身有數筆同一張工單的備料量計算                                                    
           #      LET l_sic06x = 0                                                                                                                                                                                
           #      SELECT SUM(sic06) INTO l_sic06x FROM sic_file,sia_file                                                                                                                  
           #       WHERE sic03=g_sic[l_ac].sic03                                                                                                                                          
           #         AND sic04=g_sic[l_ac].sic04                                                                                                                                                
           #         AND sic05=g_sic[l_ac].sic05   
           #         AND sic07=g_sic[l_ac].sic07                                                                                                                                         
           #         AND sic11=g_sic[l_ac].sic11                                                                                                                                               
           #         AND sic01 = g_sia.sia01                                                                                                                                                  
           #         AND sic02 != g_sic[l_ac].sic02                                                                                                                                              
           #         AND sia01=sic01 AND siaconf !='X' 
           #      IF STATUS OR cl_null(l_sic06x) THEN                                                                                                                          
           #         LET l_sic06x = 0                                                                                                                             
           #      END IF                                                                                                                                                          
           #                                                                                                                                                                                                                         
           #   END IF
           # #FUN-AC0074 -----------------------Begin----------------------------------
           #   CALL i610sub_chk_sic06(g_sia.sia04,g_argv1,g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03,g_sic[l_ac].sic05,g_sic[l_ac].sic06,
           #                          g_sic[l_ac].sic07,g_sic[l_ac].sic11,g_sic[l_ac].sic15,g_sic[l_ac].sic012,g_sic[l_ac].sic013 )        
           #   IF g_success = 'N' THEN
           #      NEXT FIELD sic06
           #   END IF
           # #FUN-AC0074 -----------------------End------------------------------------ 
           #   IF g_sia.sia04 ='1' THEN 
           #   #FUN-AC0074 ----------------------Begin----------------------
           #   #  SELECT img10 INTO l_img10
           #   #     FROM img_file
           #   #    WHERE img01=g_sic[l_ac].sic05 AND img02=g_sic[l_ac].sic08
           #   #      AND img03=g_sic[l_ac].sic09 AND img04=g_sic[l_ac].sic10
           #   #  SELECT sig05 INTO l_sig05 
           #   #     FROM sig_file 
           #   #    WHERE sig01=g_sic[l_ac].sic05 AND sig02=g_sic[l_ac].sic08
           #   #      AND sig03=g_sic[l_ac].sic09 AND sig04=g_sic[l_ac].sic10
           #   
           #   #  #sic06备置量  > img10庫存量 
           #   #  LET l_img10 = l_img10 - l_sig05
           #   #  IF g_sic[l_ac].sic06  > l_img10 THEN
           #   #        CALL cl_err(g_sic[l_ac].sic06,'sie-002',0)
           #   #        NEXT FIELD sic06
           #   #  END IF
           #      CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,
           #                            g_sic[l_ac].sic10,g_sic[l_ac].sic06,g_sic[l_ac].sic07)    
           #           RETURNING m_img10,m_sic06,m_sig05
           #      IF (m_img10 - m_sig05)< m_sic06 THEN 
           #         CALL cl_err(g_sic[l_ac].sic05,'sie-002',0)
           #         NEXT FIELD sic06
           #      END IF
           #   #FUN-AC0074 ----------------------End-------------------------     
           #   END IF
           #   IF g_sia.sia04 ='2' THEN                                                                                                  
           #      IF g_sic[l_ac].sic06 < 0  THEN
           #         CALL cl_err('','sia-102',1)
           #         NEXT FIELD sic06
           #      END IF   
           #   END IF                                                                                                        
           #                                                                                                                                                                       
           #                                                                                                 
           #   IF (g_sia.sia04 = '2') AND (g_sia.sia05='2') THEN    #一般退料      
           #                                                                                                                                                                             
           #      SELECT SUM(sie11) INTO l_sic06 FROM sie_file                                                                                                                         
           #      WHERE  sie01=g_sic[l_ac].sic05 AND sie05=g_sic[l_ac].sic03
           #       AND sie08=g_sic[l_ac].sic04                                                                                                                                                             
           #                                                                                                                                                                                                       
           #      IF cl_null(l_sic06) THEN LET l_sic06 = 0 END IF                                                                                                                       
           #      IF l_sic06 < g_sic[l_ac].sic06 THEN                                                                                                                                   
           #           CALL cl_err(g_sic[l_ac].sic04,'sia-008',1) 
           #           NEXT FIELD sic06                                                                                                                                                     
           #      END IF                                                                                                                                                                
           #   END IF
           #   #FUN-AC0074 -------------------Begin------------------
           #   IF (g_sia.sia04 = '2') AND (g_sia.sia05='3') THEN    #一般退料
           #      SELECT SUM(sie11) INTO l_sic06 FROM sie_file
           #      WHERE  sie01=g_sic[l_ac].sic04 AND sie05=g_sic[l_ac].sic03
           #
           #      IF cl_null(l_sic06) THEN LET l_sic06 = 0 END IF
           #      IF l_sic06 < g_sic[l_ac].sic06 THEN  
           #           CALL cl_err(g_sic[l_ac].sic04,'sia-008',1)
           #           NEXT FIELD sic06
           #      END IF
           #   END IF
           #   CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
           #                          g_sic[l_ac].sic06,g_sic[l_ac].sic07)
           #        RETURNING m_img10,m_sic06,m_sig05
           #   IF (m_img10 - m_sig05)< m_sic06 THEN
           #      CALL cl_err(g_sic[l_ac].sic05,'sie-002',0)
           #      NEXT FIELD sic06
           #   END IF
           #   #FUN-AC0074 -------------------End--------------------
           #END IF 
           #No.FUN-BB0086--mark---end---

        BEFORE DELETE                            #是否取消單身
            IF g_sic_t.sic02 > 0 AND g_sic_t.sic02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
 
                DELETE FROM sic_file
                 WHERE sic01 = g_sia.sia01 AND sic02 = g_sic_t.sic02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sic_file",g_sia.sia01,g_sic_t.sic02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
	            	COMMIT WORK
                display "commit work before delete"
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sic[l_ac].* = g_sic_t.*
               CLOSE i610_bcl
               DISPLAY "on row change rollback work"
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sic[l_ac].sic02,-263,1)
               LET g_sic[l_ac].* = g_sic_t.*
            ELSE
              LET l_cnt=0
            #FUN-AC0074 ----------Begin---------------
            # SELECT COUNT(*) INTO g_cnt FROM img_file
            #  WHERE img01 = g_sic[l_ac].sic05   #料號
            #    AND img02 = g_sic[l_ac].sic08   #倉庫
            #    AND img03 = g_sic[l_ac].sic09   #儲位
            #    AND img04 = g_sic[l_ac].sic10   #批號
            #    AND  img18 < g_sia.sia03        #過帳日
             LET l_sql = "SELECT COUNT(*) FROM img_file",
                         " WHERE img01 = '",g_sic[l_ac].sic05,"'",
                         "   AND img18 < '",g_sia.sia03,"'",
                         "   AND img03 = '",g_sic[l_ac].sic09,"'",
                         "   AND img04 = '",g_sic[l_ac].sic10,"'" 
             IF NOT cl_null(g_sic[l_ac].sic08) THEN 
                LET l_sql = l_sql CLIPPED," AND img02 = '",g_sic[l_ac].sic08,"'"
             END IF
             PREPARE i600_pre2 FROM l_sql
             DECLARE i600_img_count1 CURSOR FOR i600_pre2
             OPEN i600_img_count1
             IF SQLCA.sqlcode THEN 
                CALL cl_err('',SQLCA.sqlcode,0)
                CLOSE i600_img_count1
             ELSE 
                FETCH i600_img_count1 INTO g_cnt
                IF SQLCA.sqlcode THEN 
                    CALL cl_err('i600_img_count1:',SQLCA.sqlcode,0)
                    CLOSE i600_img_count1
                END IF
             END IF
            #FUN-AC0074 ----------End-----------------   
              IF g_cnt > 0 THEN    #大於有效日期
                 call cl_err('','aim-400',0)   #須修改
                 NEXT FIELD sic08
              END IF
 
               CALL i610_b_move_back()
               CALL i610_b_else()
               IF NOT cl_null(l_sfa27_a) THEN
                  SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
                   WHERE sfa01=g_sic[l_ac].sic03
                     AND sfa03=g_sic[l_ac].sic05
                     AND sfa12=g_sic[l_ac].sic07
                     AND sfa08=g_sic[l_ac].sic11
 
                   LET b_sic.sic04=l_sfa27_a
               END IF
               IF cl_null(b_sic.sic04) THEN LET b_sic.sic04=b_sic.sic05 END IF  
#FUN-B20009 -----------------------------Begin----------------------------
               IF g_sma.sma541 = 'N' THEN
                  IF cl_null(b_sic.sic012) THEN LET b_sic.sic012 = ' ' END IF  
                  IF cl_null(b_sic.sic013) THEN LET b_sic.sic013 = 0   END IF 
               END IF
#FUN-B20009 -----------------------------End------------------------------
               UPDATE sic_file SET * = b_sic.*
                WHERE sic01=g_sia.sia01 AND sic02=g_sic_t.sic02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sic_file",g_sia.sia01,g_sic_t.sic02,SQLCA.sqlcode,"","upd sic",1)  
                  LET g_sic[l_ac].* = g_sic_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
	          COMMIT WORK
                display "commit work on row change"
               END IF           
            END IF                                                                     
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            DISPLAY "after row int_flag before"
            IF INT_FLAG THEN
               DISPLAY "after row int_flag after"
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sic[l_ac].* = g_sic_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sic.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i610_bcl
               DISPLAY "after row rollback work"
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
           #MOD-CC0185 add start -----
            IF cl_null(g_sic[l_ac].sic08) THEN
               CALL cl_err(g_sic[l_ac].sic05,'apm1033',0)
               NEXT FIELD sic08
            END IF
           #MOD-CC0185 add end   -----

                IF (g_sia.sia04 = '2') AND (g_sia.sia05='2') THEN    #一般退料

                   SELECT SUM(sie11) INTO l_sic06 FROM sie_file
                   WHERE  sie01=g_sic[l_ac].sic05 AND sie05=g_sic[l_ac].sic03
                    AND sie08=g_sic[l_ac].sic04

                   IF cl_null(l_sic06) THEN LET l_sic06 = 0 END IF
                   IF l_sic06 < g_sic[l_ac].sic06 THEN
                      CALL cl_err(g_sic[l_ac].sic04,'sia-008',1)
                      NEXT FIELD sic06
                   END IF
               END IF

            IF g_sia.sia04 MATCHES '[2]' THEN   
               IF g_sic[l_ac].sfa05<0  THEN
                  LET g_sic[l_ac].sfa05=g_sic[l_ac].sfa05*(-1)
                  LET g_sic[l_ac].sfa06=g_sic[l_ac].sfa06*(-1)
               END IF
            END IF
            DISPLAY BY NAME g_sic[l_ac].sfa05,g_sic[l_ac].sfa06                                 

            CLOSE i610_bcl
            COMMIT WORK
            display "commit work after row"
           #CALL g_sic.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sic02) AND l_ac > 1 THEN
                LET g_sic[l_ac].sic03=g_sic[l_ac-1].sic03
                LET g_sic[l_ac].sic05=g_sic[l_ac-1].sic05
                LET g_sic[l_ac].sic04=g_sic[l_ac-1].sic04
                LET g_sic[l_ac].sic07=g_sic[l_ac-1].sic07
                LET g_sic[l_ac].sic08=g_sic[l_ac-1].sic08
                LET g_sic[l_ac].sic09=g_sic[l_ac-1].sic09
                LET g_sic[l_ac].sic10=g_sic[l_ac-1].sic10 
                LET g_sic[l_ac].sic11=g_sic[l_ac-1].sic11
                NEXT FIELD sic02
            END IF
 
        ON ACTION controlp
           CASE  
               WHEN INFIELD(sic03)
                 IF g_argv1 = '1' THEN   #FUN-AC0074
                    CASE WHEN g_sia.sia04 MATCHES '[2]'
                           CALL cl_init_qry_var()
                           LET g_qryparam.arg1 = '1=1'
                           LET g_qryparam.form ="q_sie051"
                           CALL cl_create_qry() RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic04,g_sic[l_ac].sic05
                           DISPLAY g_sic[l_ac].sic03 TO sic03
                           DISPLAY g_sic[l_ac].sic05 TO sic05
                           DISPLAY g_sic[l_ac].sic04 TO sic04                      
                           NEXT FIELD sic03
                         WHEN g_sia.sia04 MATCHES '[1]'
                           LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') AND sfb08-sfb081>0 "  
                           CALL q_short_qty(FALSE,TRUE,g_sic[l_ac].sic03,g_sic[l_ac].sic05,li_where,'4') 
                              RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic05,l_sfa08_tmp,l_sfa12_tmp,g_sic[l_ac].sic04,l_sfa012,l_sfa013   #FUN-A90035 add l_sfa012,l_sfa013
                           DISPLAY g_sic[l_ac].sic03 TO sic03
                           DISPLAY g_sic[l_ac].sic05 TO sic05
                           DISPLAY g_sic[l_ac].sic04 TO sic04
                     END CASE 
                  END IF     #FUN-AC0074
                  #FUN-AC0074 ---------------Begin---------------------
                  IF g_argv1 = '2' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.where = "oea49<>'2' AND oeahold IS NULL AND oeaconf = 'Y' "   #TQC-C60211 add
                     LET g_qryparam.form = "q_oeb01"
                     CALL cl_create_qry() RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic15
                     DISPLAY g_sic[l_ac].sic03 TO sic03
                     DISPLAY g_sic[l_ac].sic15 TO sic15 
                  END IF
                  IF g_argv1 = '3' THEN
                     CALL cl_init_qry_var()
                     IF g_sia.sia05 = '4' THEN
                        LET g_qryparam.form ="q_inb02"
                        LET g_qryparam.where =" inaconf = 'Y' "#TQC-CB0044 add
                     END IF
                     IF g_sia.sia05 = '5' THEN
                        LET g_qryparam.form ="q_imn01"
                        LET g_qryparam.where = " imm03 = 'N' AND immconf = 'Y' "#TQC-CB0044 add
                     END IF               
                     CALL cl_create_qry() RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic15
                     DISPLAY g_sic[l_ac].sic03 TO sic03
                     DISPLAY g_sic[l_ac].sic15 TO sic15 
                  END IF
               WHEN INFIELD(sic07)
                  IF g_argv1 MATCHES'[12]' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_sic[l_ac].sic07 
                     DISPLAY g_sic[l_ac].sic07 TO sic07
                     NEXT FIELD sic07
                  END IF 
                  #FUN-AC0074 ---------------End-----------------------

               WHEN INFIELD(sic08) OR INFIELD(sic09) OR INFIELD(sic10)
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_sic[l_ac].sic05
                  #IF s_industry("icd") AND g_ima906='3' THEN
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,TRUE,g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10)
                     RETURNING g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,TRUE,g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,'A')
                       RETURNING g_sic[l_ac].sic08,g_sic[l_ac].sic09,
                                 g_sic[l_ac].sic10
                  END IF  #FUN-C30300
                     DISPLAY g_sic[l_ac].sic08 TO sic08
                     DISPLAY g_sic[l_ac].sic09 TO sic09
                     DISPLAY g_sic[l_ac].sic10 TO sic10
                     IF INFIELD(sic08) THEN NEXT FIELD sic08 END IF
                     IF INFIELD(sic09) THEN NEXT FIELD sic09 END IF
                     IF INFIELD(sic10) THEN NEXT FIELD sic10 END IF
                WHEN INFIELD(sic04)
                 CASE WHEN g_sia.sia04 MATCHES '[1]' 
                        IF NOT cl_null(g_sic[l_ac].sic03) THEN                
                           LET li_where = " AND sfa01 = '",g_sic[l_ac].sic03,"'"  
                        END IF 
                        IF NOT cl_null(g_sic[l_ac].sic05) THEN 
                           LET li_where = li_where CLIPPED ," AND sfa03 = '",g_sic[l_ac].sic05, "'" 
                        END IF 
                        LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "
                        CALL q_short_qty(FALSE,TRUE,g_sic[l_ac].sic03,g_sic[l_ac].sic05,li_where,'4')
                          RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic05,l_sfa08_tmp,l_sfa12_tmp,g_sic[l_ac].sic04,l_sfa012,l_sfa013   #FUN-A90035 add l_sfa012,l_sfa013
                        DISPLAY g_sic[l_ac].sic03 TO sic03
                        DISPLAY g_sic[l_ac].sic04 TO sic04
                        DISPLAY g_sic[l_ac].sic05 TO sic05
                      WHEN g_sia.sia04 MATCHES '[2]'
                        LET g_sql=''  #MOD-AC0385
                        IF NOT cl_null(g_sic[l_ac].sic03) THEN 
                          LET g_sql = " sie05 ='",g_sic[l_ac].sic03,"' "
                        END IF 
                        IF NOT cl_null(g_sic[l_ac].sic05) THEN 
                          LET g_sql = g_sql CLIPPED," AND sie01 = '",g_sic[l_ac].sic05,"' " 
                        END IF                       
                        LET g_qryparam.arg1 = g_sql 
                        LET g_qryparam.form ="q_sie051"
                        CALL cl_create_qry() RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic04,g_sic[l_ac].sic05
                        DISPLAY g_sic[l_ac].sic03 TO sic03
                        DISPLAY g_sic[l_ac].sic05 TO sic05
                        DISPLAY g_sic[l_ac].sic04 TO sic04  
                 END CASE          
                WHEN INFIELD(sic05)
                 CASE WHEN g_sia.sia04 MATCHES '[1]'   
                        IF NOT cl_null(g_sic[l_ac].sic03) THEN                
                         LET li_where = " AND  sfa01 = '",g_sic[l_ac].sic03,"'"  
                        END IF 
                        IF NOT cl_null(g_sic[l_ac].sic04) THEN 
                         LET li_where = li_where CLIPPED ," AND sfa27 = '",g_sic[l_ac].sic04, "'" 
                        END IF                                
                        LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8','U','T','S','Z') "#TQC-CB0042 add ustz
                        CALL q_short_qty(FALSE,TRUE,g_sic[l_ac].sic03,g_sic[l_ac].sic05,li_where,'4')
                          RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic05,l_sfa08_tmp,l_sfa12_tmp,g_sic[l_ac].sic04,l_sfa012,l_sfa013   #FUN-A90035 add l_sfa012,l_sfa013
                        DISPLAY g_sic[l_ac].sic03 TO sic03
                        DISPLAY g_sic[l_ac].sic04 TO sic04
                        DISPLAY g_sic[l_ac].sic05 TO sic05
                      WHEN g_sia.sia04 MATCHES '[2]'
                        LET g_sql=''  #MOD-AC0385
                        IF NOT cl_null(g_sic[l_ac].sic03) THEN 
                         LET g_sql = " sie05 ='",g_sic[l_ac].sic03,"' "
                        END IF 
                        IF NOT cl_null(g_sic[l_ac].sic04) THEN 
                         LET g_sql = g_sql CLIPPED ," AND sie08 ='",g_sic[l_ac].sic04,"' "
                        END IF
                        LET g_qryparam.arg1 = g_sql 
                        LET g_qryparam.form ="q_sie051"
                        CALL cl_create_qry() RETURNING g_sic[l_ac].sic03,g_sic[l_ac].sic04,g_sic[l_ac].sic05
                        DISPLAY g_sic[l_ac].sic03 TO sic03
                        DISPLAY g_sic[l_ac].sic05 TO sic05
                        DISPLAY g_sic[l_ac].sic04 TO sic04  
                 END CASE                          
#FUN-B20009 ---------------------Begin-------------------------
                   WHEN INFIELD(sic012)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_sic"
                        LET g_qryparam.arg1 = g_sic[l_ac].sic03
                        CALL cl_create_qry() RETURNING g_sic[l_ac].sic012
                        DISPLAY BY NAME g_sic[l_ac].sic012
                        NEXT FIELD sic012
                   WHEN INFIELD(sic013)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_sic01"
                        LET g_qryparam.arg1 = g_sic[l_ac].sic03
                        CALL cl_create_qry() RETURNING g_sic[l_ac].sic013
                        DISPLAY BY NAME g_sic[l_ac].sic013
                        NEXT FIELD sic013
#FUN-B20009 ---------------------End---------------------------
           END CASE
 
         #ON ACTION CONTROLZ  #TQC-C50082 mark
         ON ACTION CONTROLR   #TQC-C50082 add
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name   
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
    UPDATE sia_file SET siamodu=g_sia.siamodu,  
                        siadate=g_sia.siadate
     WHERE sia01=g_sia.sia01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","sia_file",g_sia.sia01,"",SQLCA.sqlcode,"","upd siamodu",1)  #No.FUN-660128
       LET g_sia.siamodu=g_sia_t.siamodu
       LET g_sia.siadate=g_sia_t.siadate
       DISPLAY BY NAME g_sia.siamodu
       DISPLAY BY NAME g_sia.siadate
    END IF
 
    SELECT COUNT(*) INTO g_cnt FROM sic_file WHERE sic01=g_sia.sia01
    IF g_cnt=0 THEN 			# 未輸入單身資料, 則取消單頭資料
       IF cl_confirm('9042') THEN
        DELETE FROM sia_file WHERE sia01 = g_sia.sia01
        DELETE FROM sib_file WHERE sib01 = g_sia.sia01
          LET g_cnt=0
          CLEAR FORM
          CALL g_sib.clear()
          CALL g_sic.clear()
       END IF
    END IF
 
    IF g_cnt>0 AND g_smy.smydmy4='Y' THEN 
       CALL i610sub_y_chk(g_sia.sia01)
       IF g_success = "Y" THEN
          CALL i610sub_y_upd(g_sia.sia01,g_action_choice,FALSE)   
            RETURNING g_sia.*
          DISPLAY BY NAME g_sia.siaconf  
          IF g_sia.siaconf='X' THEN
             LET g_chr='Y' 
          ELSE 
             LET g_chr='N' 
          END IF  
          CALL i610_pic() #圖形顯示  
       END IF
    END IF
 
    IF g_cnt>0 THEN
       IF g_sic.getlength()>g_cnt THEN
          WHILE g_sic.getlength()>g_cnt
             CALL g_sic.deleteElement(g_sic.getlength())
          END WHILE
       END IF
    END IF
END FUNCTION   

#FUN-AC0074 ----------------------Begin---------------------------#lixh1
FUNCTION i610_sum_sic06()
   IF g_argv1 = '1' THEN
      IF g_sma.sma542 = 'N' THEN
         LET g_sic[l_ac].sic012=' '
         LET g_sic[l_ac].sic013=0
      END IF
      IF cl_null(g_sic[l_ac].sic11) THEN LET g_sic[l_ac].sic11=' ' END IF
        IF NOT cl_null(g_sic[l_ac].sic03) AND NOT cl_null(g_sic[l_ac].sic05) AND
           g_sic[l_ac].sic11 IS NOT NULL AND NOT cl_null(g_sic[l_ac].sic07) AND
           NOT cl_null(g_sic[l_ac].sic04) AND g_sic[l_ac].sic012 IS NOT NULL AND 
           NOT cl_null(g_sic[l_ac].sic013) THEN
           SELECT sum(sie11) INTO g_sic[l_ac].sic06 FROM sie_file
            WHERE sie05=g_sic[l_ac].sic03 
              AND sie01=g_sic[l_ac].sic05
              AND sie06=g_sic[l_ac].sic11
              AND sie07=g_sic[l_ac].sic07
              AND sie08=g_sic[l_ac].sic04
              AND sie012=g_sic[l_ac].sic012
              AND sie013=g_sic[l_ac].sic013
         END IF
   END IF
   IF g_argv1 = '2' THEN
      IF NOT cl_null(g_sic[l_ac].sic03) AND NOT cl_null(g_sic[l_ac].sic15) THEN
         SELECT sum(sie11) INTO g_sic[l_ac].sic06 FROM sie_file
          WHERE sie05=g_sic[l_ac].sic03
            AND sie15=g_sic[l_ac].sic15 
      END IF
   END IF
   
   IF SQLCA.SQLCODE = 100 THEN
      LET g_sic[l_ac].sic06 = 0
   END IF 
   IF g_sic[l_ac].sic06 <> 0 THEN
      DISPLAY BY NAME g_sic[l_ac].sic06
   END IF
END FUNCTION
FUNCTION i610_display()
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_flag      LIKE type_file.chr1   
   DEFINE l_fac       LIKE ima_file.ima31_fac
   LET g_success = 'Y'
   SELECT inb04,inb05,inb06,inb07,inb08,inb09 INTO
          g_sic[l_ac].sic04,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
          g_sic[l_ac].sic07,g_sic[l_ac].sfa05
     FROM inb_file
    WHERE inb01 = g_sic[l_ac].sic03
      AND inb03 = g_sic[l_ac].sic15   
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL cl_err(g_sic[l_ac].sic03,'asf-185',0)
      RETURN
   END IF   
   LET g_sic[l_ac].sic06 = g_sic[l_ac].sfa05  
   LET g_sic[l_ac].sic06 = s_digqty(g_sic[l_ac].sic06,g_sic[l_ac].sic07)   #No.FUN-BB0086
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01 = g_sic[l_ac].sic04
   CALL s_umfchk(g_sic[l_ac].sic04,g_sic[l_ac].sic07,l_ima25)
      RETURNING l_flag,l_fac
   IF l_flag THEN 
      CALL cl_err('','',0)
      LET g_success = 'N'
      RETURN
   ELSE 
      LET g_sic[l_ac].sic07_fac = l_fac 
   END IF
   DISPLAY g_sic[l_ac].sic07 TO sic07
END FUNCTION
FUNCTION i610_show_imn()
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE l_fac       LIKE ima_file.ima31_fac
   LET g_success = 'Y'
   IF NOT cl_null(g_sic[l_ac].sic03) AND  NOT cl_null(g_sic[l_ac].sic15) THEN
      SELECT imn03,imn04,imn05,imn06,imn09,imn10 INTO
             g_sic[l_ac].sic04,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
             g_sic[l_ac].sic07,g_sic[l_ac].sfa05
        FROM imn_file
       WHERE imn01 = g_sic[l_ac].sic03
         AND imn02 = g_sic[l_ac].sic15
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err(g_sic[l_ac].sic03,'asf-187',0)
         RETURN
      END IF
      LET g_sic[l_ac].sic06 = g_sic[l_ac].sfa05
      LET g_sic[l_ac].sic06 = s_digqty(g_sic[l_ac].sic06,g_sic[l_ac].sic07)   #No.FUN-BB0086
      SELECT ima25 INTO l_ima25 FROM ima_file
       WHERE ima01 = g_sic[l_ac].sic04
      CALL s_umfchk(g_sic[l_ac].sic04,g_sic[l_ac].sic07,l_ima25)
         RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL cl_err('','',0)
         LET g_success = 'N'
         RETURN
      ELSE
         LET g_sic[l_ac].sic07_fac = l_fac
      END IF
      DISPLAY g_sic[l_ac].sic07 TO sic07
   END IF
END FUNCTION
FUNCTION i610_sic03_chk()
   DEFINE l_cnt    LIKE type_file.num5
   SELECT COUNT(*) INTO l_cnt FROM sic_file
    WHERE sic03 = g_sic[l_ac].sic03
      AND sic15 = g_sic[l_ac].sic15
   IF l_cnt = 0 THEN
      RETURN TRUE
   ELSE 
      CALL cl_err(g_sic[l_ac].sic03,'axm-282',0)
      RETURN FALSE
   END IF
END FUNCTION
#FUN-AC0074 ----------------------End-----------------------------
#FUN-B20009 ---------------Begin---------------
FUNCTION i610_sic013_default()
   DEFINE l_sic013 LIKE sic_file.sic013
   LET g_success = 'Y'
   IF NOT cl_null(g_sic[l_ac].sic11) AND NOT cl_null(g_sic[l_ac].sic03)
      AND NOT cl_null(g_sic[l_ac].sic012) AND NOT cl_null(g_sic[l_ac].sic05) THEN
      DECLARE i610_cs_sic013 CURSOR FOR 
         SELECT DISTINCT sfa013 FROM sfa_file
          WHERE sfa01 = g_sic[l_ac].sic03
            AND sfa012 = g_sic[l_ac].sic012
            AND sfa08 = g_sic[l_ac].sic11
            AND sfa03 = g_sic[l_ac].sic05       
      FOREACH i610_cs_sic013 INTO l_sic013
         IF STATUS THEN
            CALL cl_err(g_sic[l_ac].sic03,'asf-193',0)
            LET g_success = 'N'
            RETURN
         END IF 
         IF NOT cl_null(l_sic013) THEN
            LET g_sic[l_ac].sic013 = l_sic013
            INITIALIZE l_sic013 TO NULL
            EXIT FOREACH
         END IF           
      END FOREACH
      DISPLAY BY NAME g_sic[l_ac].sic013
   END IF 
END FUNCTION
#FUN-B20009 ---------------End-----------------

#此函數用于計算退備置未審核量,若有需要可直接擴展為未審核量計算。
FUNCTION i610_totsic06(p_sia01,p_sia04,p_sic02,p_sic03,p_sic05,p_sic07,p_sic11,p_sic04)  #No.MOD-790175 modify#FUN-9B0149
DEFINE   l_tot        LIKE sic_file.sic05    
DEFINE   p_sia01      LIKE sia_file.sia01
DEFINE   p_sic02      LIKE sic_file.sic02
DEFINE   p_sic03      LIKE sic_file.sic03
DEFINE   p_sic05      LIKE sic_file.sic05
DEFINE   p_sic07      LIKE sic_file.sic07    
DEFINE   p_sic11      LIKE sic_file.sic11    
DEFINE   p_sia04      LIKE sia_file.sia04
DEFINE   p_sic04      LIKE sic_file.sic04   
 
 
    LET l_tot = 0
 
    SELECT SUM(sic06) INTO l_tot  FROM sic_file,sia_file
     WHERE sic01  = sia01
       AND siaconf != 'Y'
       AND sia04  = p_sia4
       AND ((sic01 != p_sia01) 
         OR (sic01 = p_sia01 AND sic02 != p_sic02))
       AND sic03  = p_sic03
       AND sic05  = p_sic05
       AND sic07  = p_sic07    
       AND sic11  = p_sic11   
       AND sic04  = p_sic04  
       AND siaconf != 'X'    
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sic_file",g_sic[l_ac].sic05,"",SQLCA.sqlcode,"","sel sum(sic05)",1)
       LET l_tot = 0
    END IF
    IF cl_null(l_tot) THEN
       LET l_tot=0
    END IF
 
    RETURN l_tot
     
 
END FUNCTION

FUNCTION i610_b_move_to()
   LET g_sic[l_ac].sic02 = b_sic.sic02
   LET g_sic[l_ac].sic03 = b_sic.sic03
   LET g_sic[l_ac].sic05 = b_sic.sic05 
   LET g_sic[l_ac].sic04 = b_sic.sic04
   LET g_sic[l_ac].sic11 = b_sic.sic11
   LET g_sic[l_ac].sic06 = b_sic.sic06
   LET g_sic[l_ac].sic07 = b_sic.sic07
   LET g_sic[l_ac].sic08 = b_sic.sic08
   LET g_sic[l_ac].sic09 = b_sic.sic09
   LET g_sic[l_ac].sic10 = b_sic.sic10
   LET g_sic[l_ac].sic012 = b_sic.sic012    #FUN-B20009
   LET g_sic[l_ac].sic013 = b_sic.sic013    #FUN-B20009
#FUN-AC0074 --------------Begin------------------
   IF g_argv1 = '1' THEN
      IF cl_null(g_sic[l_ac].sic15) THEN
         LET g_sic[l_ac].sic15 = 0
      END IF
   END IF
#FUN-AC0074 --------------End--------------------
   LET g_sic[l_ac].sic16 = b_sic.sic16      

END FUNCTION
 
FUNCTION i610_b_move_back()
   LET b_sic.sic02 = g_sic[l_ac].sic02
   LET b_sic.sic03 = g_sic[l_ac].sic03
   LET b_sic.sic05 = g_sic[l_ac].sic05
   LET b_sic.sic06 = g_sic[l_ac].sic06
   LET b_sic.sic07 = g_sic[l_ac].sic07
   LET b_sic.sic08 = g_sic[l_ac].sic08
   LET b_sic.sic09 = g_sic[l_ac].sic09
   LET b_sic.sic10 = g_sic[l_ac].sic10
   LET b_sic.sic11 = g_sic[l_ac].sic11
   LET b_sic.sic12 = ''
   LET b_sic.sic04 = g_sic[l_ac].sic04
   LET b_sic.sic012 = g_sic[l_ac].sic012      #FUN-B20009
   LET b_sic.sic013 = g_sic[l_ac].sic013      #FUN-B20009
   LET b_sic.sicplant = g_plant 
   LET b_sic.siclegal = g_legal 
#FUN-AC0074 --------Begin----------------
   LET b_sic.sic16 = g_sic[l_ac].sic16
   IF g_argv1 = '1' THEN
      IF cl_null(g_sic[l_ac].sic15) THEN
         LET g_sic[l_ac].sic15 = 0
      END IF
   END IF
   IF g_argv1 MATCHES'[23]' THEN
      LET b_sic.sic07_fac = g_sic[l_ac].sic07_fac  
      LET b_sic.sic05 = b_sic.sic04
      LET b_sic.sic012 = ' '
      LET b_sic.sic11 = ' '
      LET b_sic.sic013 = 0
   END IF
#FUN-AC0074 --------End------------------ 
END FUNCTION
 

FUNCTION i610_b_else()
   IF g_sic[l_ac].sic10 IS NULL THEN LET g_sic[l_ac].sic10 =' ' END IF
   IF g_sic[l_ac].sic08 IS NULL THEN LET g_sic[l_ac].sic08 =' ' END IF
   IF g_sic[l_ac].sic09 IS NULL THEN LET g_sic[l_ac].sic09 =' ' END IF
   LET b_sic.sic10 = g_sic[l_ac].sic10    
   LET b_sic.sic08 = g_sic[l_ac].sic08    
   LET b_sic.sic09 = g_sic[l_ac].sic09    
   LET b_sic.sic15 = g_sic[l_ac].sic15          #FUN-AC0074
END FUNCTION

FUNCTION i610_d_fill(p_wc2)              #BODY FILL UP
 DEFINE p_wc2           LIKE type_file.chr1000 
 DEFINE l_ima01 LIKE ima_file.ima01
 
       LET g_sql =
           "SELECT sib02,sib04,sfb05,'','',sib03", 
           " FROM sib_file LEFT OUTER JOIN sfb_file ON sib02 = sfb01 ",                     #09/10/21 xiaofeizhu Add
           " WHERE sib01 ='",g_sia.sia01,"' ",
           " ORDER BY sib02"                                                                #09/10/21 xiaofeizhu Add
    
    PREPARE i610_pd FROM g_sql
    DECLARE sib_curs CURSOR FOR i610_pd
 
    CALL g_sib.clear()
 
    LET g_cnt = 1
    LET g_rec_d = 0
 
    FOREACH sib_curs INTO g_sib[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          LET l_ima01=g_sib[g_cnt].sfb05
       SELECT ima02,ima021 INTO g_sib[g_cnt].ima02, g_sib[g_cnt].ima021
         FROM ima_file
        WHERE ima01=l_ima01
       LET g_cnt = g_cnt + 1
    END FOREACH
 
    IF STATUS THEN CALL cl_err('fore sib:',STATUS,1) END IF
    CALL g_sib.deleteElement(g_cnt)
 
    LET g_rec_d = g_cnt - 1
 
    DISPLAY g_rec_d TO FORMONLY.cn3
 
    DISPLAY ARRAY g_sib TO s_sib.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END DISPLAY
 
END FUNCTION
 
FUNCTION i610_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2           LIKE type_file.chr1000 
    DEFINE l_factor        LIKE ima_file.ima31_fac  
    DEFINE l_cnt           LIKE type_file.num5  
 
       IF g_argv1 = '1' THEN     #FUN-AC0074
       LET g_sql =
         #"SELECT sic02,sic03,sic04,sic05,sic11,(sfa05-sfa065),sfa06,sic06,",                     #FUN-B20009  
         #"SELECT sic02,sic03,sic04,sic05,sic012,' ',sic11,sic013,(sfa05-sfa065),sfa06,sic06,",   #FUN-B20009   #FUN-AC0074
          "SELECT sic02,sic03,sic15,sic04,ima02,ima021,sic05,sic012,' ',sic11,sic013,(sfa05-sfa065),sfa06,sic06,",           #FUN-AC0074     #TQC-D10061 add ima
          "       sic07,sic07_fac,sic08,sic09,sic10",
          " FROM sic_file LEFT OUTER JOIN sfa_file ON sic03=sfa01 AND sic05=sfa03 AND sic07=sfa12 AND sic11=sfa08 AND sic04=sfa27",                                                                               #09/10/21 xiaofeizhu Add
          "  AND sic012=sfa012 AND sic013=sfa013",  #TQC-B60244
          "  LEFT OUTER JOIN ima_file ON sic04 = ima01 ",                                         #TQC-D10061
          " WHERE sic01 ='",g_sia.sia01,"'", 
          "   AND ",p_wc2 CLIPPED,  
          " ORDER BY sic02 "   
       END IF   #FUN-AC0074 
#FUN-AC0074 -------------------------------------Begin------------------------------------------
       IF g_argv1 = '2' THEN
          LET g_sql = "SELECT sic02,sic03,sic15,sic04,ima02,ima021,sic05,sic012,' ',sic11,sic013,' ',' ',",   #TQC-D10061 add ima
                      "       sic06,sic07,sic07_fac,sic08,sic09,sic10",
                      "  FROM sic_file LEFT OUTER JOIN oeb_file ON sic03 = oeb01 AND sic15 = oeb03 ",
                      "  LEFT OUTER JOIN ima_file ON sic04 = ima01 ",                                         #TQC-D10061
                      " WHERE sic01 ='",g_sia.sia01,"'",
                      "   AND ",p_wc2 CLIPPED,
                      " ORDER BY sic02 "
       END IF
       IF g_argv1 = '3' THEN
          LET g_sql = "SELECT sic02,sic03,sic15,sic04,ima02,ima021,sic05,sic012,' ',sic11,sic013,' ',' ',",   #TQC-D10061 add ima
                      "       sic06,sic07,sic07_fac,sic08,sic09,sic10",
                      "  FROM sic_file LEFT OUTER JOIN inb_file ON sic03 = inb01 AND sic15 = inb03 ", 
                      "  LEFT OUTER JOIN ima_file ON sic04 = ima01 ",                                         #TQC-D10061
                      " WHERE sic01 ='",g_sia.sia01,"'",
                      "   AND ",p_wc2 CLIPPED,
                      " ORDER BY sic02 "
       END IF
#FUN-AC0074 -------------------------------------End--------------------------------------------
 
    PREPARE i610_pb FROM g_sql
    DECLARE sic_curs CURSOR FOR i610_pb
 
    CALL g_sic.clear()
 
    LET g_cnt = 1
 
    FOREACH sic_curs INTO g_sic[g_cnt].* #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#FUN-B20009 ------------------Begin-------------------------
           CALL s_schdat_ecm014(g_sic[g_cnt].sic03,g_sic[g_cnt].sic012)
                RETURNING g_sic[g_cnt].ecm014                        
#FUN-B20009 ------------------End---------------------------
#FUN-AC0074 ------------------Begin-------------------------
        IF g_argv1 = '2' THEN
           SELECT oeb12,oeb24 INTO g_sic[g_cnt].sfa05,g_sic[g_cnt].sfa06
             FROM oeb_file
            WHERE oeb01 = g_sic[g_cnt].sic03
              AND oeb03 = g_sic[g_cnt].sic15
        END IF
        IF g_argv1 = '3' THEN
           SELECT inb09 INTO g_sic[g_cnt].sfa05 FROM inb_file
            WHERE inb01 = g_sic[g_cnt].sic03
              AND inb03 = g_sic[g_cnt].sic15
        END IF
#FUN-AC0074 ------------------End---------------------------
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore sic:',STATUS,1) END IF
    CALL g_sic.deleteElement(g_cnt)
    
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    DISPLAY ARRAY g_sic TO s_sic.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END DISPLAY
 
END FUNCTION
 
FUNCTION i610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY ARRAY g_sib TO s_sib.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF g_errno='genb' THEN CALL i610_b_fill(' 1=1') LET g_errno='' END IF
 
   DISPLAY ARRAY g_sic TO s_sic.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
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
         CALL i610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
      ON ACTION jump
         CALL i610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                
 
      ON ACTION next
         CALL i610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL i610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         CALL i610_pic() #圖形顯示
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
  
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
           
    
#圖形顯示
FUNCTION i610_pic()
   IF g_sia.siaconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_sia.siaconf,"",g_sia.sia04,"",g_void,"")
END FUNCTION
  
FUNCTION i610_b_i_move_back(l_i)
   DEFINE l_i LIKE type_file.num10
   LET b_sib.sib01  = g_sia.sia01
   LET b_sib.sib02  = g_sib[l_i].sib02   
   LET b_sib.sib04  = g_sib[l_i].sib04   
   LET b_sib.sib03  = g_sib[l_i].sib03 
 
   LET b_sib.sibplant = g_plant 
   LET b_sib.siblegal = g_legal 
END FUNCTION
 
 
FUNCTION i610_sic11(p_sic11)
DEFINE p_sic11     LIKE sic_file.sic10
DEFINE l_ecdacti   LIKE ecd_file.ecdacti
DEFINE l_errno     LIKE type_file.chr10
      
    LET l_errno =''
    SELECT ecdacti INTO l_ecdacti FROM ecd_file 
     WHERE ecd01 = p_sic11
    CASE
      WHEN SQLCA.sqlcode = 100  LET l_errno = 'mfg4009'
      WHEN l_ecdacti = 'N'      LET l_errno = 'ams-106'
      OTHERWISE LET l_errno = SQLCA.sqlcode USING '-----'
    END CASE
 
    RETURN l_errno
 
END FUNCTION 
   
FUNCTION i610_y_chk()
 
   CALL i610sub_y_chk(g_sia.sia01)
 
   IF g_success='N' THEN
      RETURN   
   END IF
 
END FUNCTION
 
FUNCTION i610_y_upd()  
 
   CALL i610sub_y_upd(g_sia.sia01,g_action_choice,FALSE)  
     RETURNING g_sia.*
 
   IF g_success='N' THEN
      RETURN  
   END IF
 
END FUNCTION
  
FUNCTION i610_sfb01(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   IF cl_null(p_sfb01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(p_sfb01)
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM smy_file
    WHERE smy69 = l_slip
   IF l_cnt > 0 THEN
      LET g_errno = 'asf-875'     #不可使用組合拆解對應工單單別
   END IF
 
END FUNCTION

FUNCTION i610_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
    DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
    DEFINE l_img10              LIKE img_file.img10    
    DEFINE l_factor             LIKE img_file.img21    
    DEFINE l_cnt                LIKE type_file.num5    
    define mai_ware	LIKE img_file.img02              #FUN-B80086  main改成mai
    define mai_loc	LIKE img_file.img03              #FUN-B80086  main改成mai
    define wip_ware	LIKE img_file.img02
    define wip_loc	LIKE img_file.img03
 
    SELECT ima35,ima36,ima136,ima137
      INTO mai_ware,mai_loc,wip_ware,wip_loc FROM ima_file     #FUN-B80086  main改成mai
     WHERE ima01=g_sfa2.sfa03
    IF g_ima108 = 'Y' THEN
       LET mai_ware = wip_ware                              #FUN-B80086  main改成mai
       LET mai_loc  = wip_loc                               #FUN-B80086  main改成mai
    END IF     
    IF cl_null(mai_ware) THEN LET mai_ware=' ' END IF       #FUN-B80086  main改成mai
    IF cl_null(mai_loc ) THEN LET mai_loc =' '  END IF      #FUN-B80086  main改成mai
    #FUN-A50023 --add --begin
    IF issue_type='1' THEN
       LET g_img.img01=g_sfa2.sfa03
       LET g_img.img02=mai_ware                             #FUN-B80086  main改成mai
       LET g_img.img03=mai_loc                              #FUN-B80086  main改成mai
       LET g_img.img04=lot_no
       LET issue_qty2=issue_qty1
       CALL i610_ins_sic()
       LET img_qty = issue_qty1 #No.+238
       RETURN
    END IF
 
     IF issue_type MATCHES '[2]' THEN      #No.MOD-570241 modify
       LET g_img.img01=g_sfa2.sfa03
       LET g_img.img02=ware_no
       LET g_img.img03=loc_no
       LET g_img.img04=lot_no
       LET issue_qty2=issue_qty1
       IF issue_qty2 <= 0  THEN RETURN END IF
       CALL i610_ins_sic()
       LET img_qty = issue_qty1 #No.+238
       RETURN
    END IF
 
     IF issue_type MATCHES '[3]' THEN
         LET g_img.img01=g_sfa2.sfa03
         LET g_img.img02=g_sfa2.sfa30
         LET g_img.img03=g_sfa2.sfa31
         LET g_img.img04=' '

         LET issue_qty2=issue_qty1
         IF issue_qty2 <= 0  THEN RETURN END IF
         CALL i610_ins_sic()
         LET img_qty = issue_qty1 #No.+238
         RETURN
     END IF
 
 
    IF issue_type MATCHES '[45]' AND ware_no IS NOT NULL THEN
       LET g_img.img01 = g_sfa2.sfa03
       LET g_img.img02 = ware_no
    END IF
 
    IF issue_type MATCHES '[45]' AND loc_no IS NOT NULL THEN
       LET g_img.img01 = g_sfa2.sfa03
       LET g_img.img03 = loc_no
    END IF
 
    IF issue_type MATCHES '[45]' AND lot_no IS NOT NULL THEN
       LET g_img.img01 = g_sfa2.sfa03
       LET g_img.img04 = lot_no
    END IF
    
    
    LET l_img10 = (g_sfa2.sfa05-g_sfa2.sfa06) * g_sfa2.sfa13   
    LET img_qty=0   
    LET l_sql="SELECT * FROM img_file",
              " WHERE img01='",g_sfa2.sfa03,"'",	#料號
              "   AND img10>0 AND img23='Y'"		#可用
    IF NOT cl_null(mai_ware) AND issue_type = '1' THEN                 #FUN-B80086  main改成mai
       LET l_sql=l_sql CLIPPED," AND img02='",mai_ware,"'"             #FUN-B80086  main改成mai
    END IF
    IF NOT cl_null(mai_loc) AND issue_type = '1' THEN                  #FUN-B80086  main改成mai
       LET l_sql=l_sql CLIPPED," AND img03='",mai_loc,"'"              #FUN-B80086  main改成mai
    END IF
    IF NOT cl_null(lot_no) AND issue_type = '1'  THEN
       LET l_sql=l_sql CLIPPED," AND img04='",lot_no,"'"
    END IF
    IF NOT cl_null(ware_no) AND issue_type MATCHES '[245]' THEN
       LET l_sql=l_sql CLIPPED," AND img02='",ware_no,"'"
    END IF
    IF NOT cl_null(loc_no) AND issue_type MATCHES '[245]' THEN
       LET l_sql=l_sql CLIPPED," AND img03='",loc_no,"'"
    END IF
    IF NOT cl_null(lot_no) AND issue_type MATCHES '[245]'  THEN
       LET l_sql=l_sql CLIPPED," AND img04='",lot_no,"'"
    END IF
    LET l_sql=l_sql CLIPPED," ORDER BY img27"		#發料順序
    PREPARE g_b1_p3 FROM l_sql
    DECLARE g_b1_c3 CURSOR FOR g_b1_p3
    FOREACH g_b1_c3 INTO g_img.*
       IF STATUS THEN CALL cl_err('fore img',STATUS,1) EXIT FOREACH END IF
       IF g_sfa2.sfa12 = g_img.img09 THEN
          LET l_factor = 1
       ELSE
          CALL s_umfchk(g_img.img01,g_img.img09,g_sfa2.sfa12)
             RETURNING l_cnt,l_factor
          IF l_cnt = 1 THEN
             LET l_factor = 1
          END IF
       END IF
       LET g_img.img10 = g_img.img10 * l_factor
       IF issue_type='5' THEN		# 扣除已撿量
          SELECT SUM(sic06) INTO qty_alo FROM sic_file,sia_file  
                WHERE sic05=g_img.img01 AND sic08=g_img.img02
                  AND sic09=g_img.img03 AND sic10=g_img.img04
                  AND sia01=sic01 AND siaconf = 'Y'              
          IF qty_alo IS NULL THEN LET qty_alo = 0 END IF
          LET g_img.img10=g_img.img10-qty_alo
          IF g_img.img10<=0 THEN CONTINUE FOREACH END IF
       END IF
      #IF g_argv1='1' THEN        #FUN-AC0074 
       IF g_sia.sia04 = '1' THEN  #FUN-AC0074
          IF issue_qty1<=g_img.img10 THEN    
             LET issue_qty2=issue_qty1
             CALL i610_ins_sic()
             LET issue_qty1=issue_qty1-issue_qty2
             LET img_qty = img_qty+issue_qty2 
             EXIT FOREACH
          ELSE
             LET issue_qty2=g_img.img10
             CALL i610_ins_sic()
             LET issue_qty1=issue_qty1-issue_qty2
             LET img_qty = img_qty+issue_qty2 
          END IF
       END IF
    END FOREACH
 
#    IF  issue_qty1>0 THEN	#產生一筆 Shortage 項次以供警告
#       LET issue_qty2=issue_qty1
#       LET g_img.img01=g_sfa2.sfa03
#       LET g_img.img02 = cl_getmsg('asf-012',g_lang)  
#       LET g_img.img03=' '
#       LET g_img.img04=' '
#       CALL i610_ins_sic()
# 
#    END IF
    
    #FUN-A50023 --add --end
    
    #FUN-A50023 --mark --begin
    #LET g_img.img01=g_sfa2.sfa03
    #LET g_img.img02=mai_ware              #FUN-B80086  main改成mai
    #LET g_img.img03=mai_loc               #FUN-B80086  main改成mai
    #LET g_img.img04=lot_no
    #IF cl_null(g_img.img04) THEN
    #    LET g_img.img04 = ' '
    #END IF
    #LET issue_qty2=issue_qty1
    #CALL i610_ins_sic()
    #FUN-A50023 --mark --end 
END FUNCTION

FUNCTION i610_ins_sic()	# Insert sic_file
DEFINE l_gfe03 LIKE gfe_file.gfe03 
DEFINE l_tot   LIKE sic_file.sic05 #   #記錄未審核退備置數量
DEFINE l_ima25 LIKE ima_file.ima25       #FUN-AC0074
DEFINE l_flag  LIKE type_file.chr1  #FUN-AC0074 
 
    SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01=g_sfa2.sfa12
    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
       LET l_gfe03=0
    END IF
    
    LET b_sic.sic01=g_sia.sia01
    LET b_sic.sic02=b_sic.sic02+1
    LET b_sic.sic03=b_sib.sib02
    LET b_sic.sic04='' 
    LET b_sic.sic05=g_img.img01
    LET b_sic.sic06=issue_qty2 
    LET b_sic.sic06=cl_digcut(issue_qty2,l_gfe03) 
    LET b_sic.sic07=g_sfa2.sfa12
    LET b_sic.sic08=g_img.img02
    LET b_sic.sic09=g_img.img03
    LET b_sic.sic10=g_img.img04
    LET b_sic.sic11=g_sfa2.sfa08 
    LET b_sic.sic12=''
    IF g_sfa2.sfa26 MATCHES '[SUTZ]' THEN
       LET b_sic.sic04=g_sfa2.sfa27
     END IF
    IF b_sic.sic10 IS NULL THEN LET b_sic.sic10 = ' ' END IF
    IF b_sic.sic08 IS NULL THEN LET b_sic.sic08 = ' ' END IF
    IF b_sic.sic09 IS NULL THEN LET b_sic.sic09 = ' ' END IF
    IF cl_null(b_sic.sic04) THEN
       LET b_sic.sic04=b_sic.sic05
    END IF
    IF cl_null(b_sic.sic04) THEN
       LET b_sic.sic04 = ' '
    END IF
 
    LET b_sic.sicplant = g_plant
    LET b_sic.siclegal = g_legal
       
 #FUN-B20009 ---------------Begin----------------
    LET b_sic.sic012 = g_sfa2.sfa012
    LET b_sic.sic013 = g_sfa2.sfa013
    IF cl_null(b_sic.sic012) THEN
       LET b_sic.sic012 = ' '
    END IF
    IF cl_null(b_sic.sic013) THEN
       LET b_sic.sic013 = 0 
    END IF
 #FUN-B20009 ---------------End------------------
 #FUN-AC0074 ---------------Begin----------------
    SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01 = g_img.img01 
    CALL s_umfchk(g_img.img01,b_sic.sic07,l_ima25)
       RETURNING l_flag,l_fac
    IF l_flag THEN
       CALL cl_err('','',0)
    ELSE
       LET b_sic.sic07_fac = l_fac
    END IF
    IF cl_null(b_sic.sic15) THEN 
       LET b_sic.sic15 = 0      
    END IF                     
 #FUN-AC0074 ---------------End------------------

    INSERT INTO sic_file VALUES(b_sic.*)
    IF STATUS THEN 
       CALL cl_err3("ins","sic_file",b_sic.sic01,b_sic.sic02,STATUS,"","ins sic:",1)  #No.FUN-660128
    END IF
    
END FUNCTION

#No.FUN-BB0086---start---add---
FUNCTION i610_sic06_check(l_sic06x,m_img10,m_sic06,m_sig05,l_sic06)
DEFINE l_sic06x         LIKE sic_file.sic06
DEFINE m_img10          LIKE img_file.img10
DEFINE m_sic06          LIKE sic_file.sic06   
DEFINE m_sig05          LIKE sig_file.sig05  
DEFINE l_sic06          LIKE sic_file.sic06

   IF NOT cl_null(g_sic[l_ac].sic06) AND NOT cl_null(g_sic[l_ac].sic07) THEN
      IF cl_null(g_sic_t.sic06) OR cl_null(g_sic07_t) OR g_sic_t.sic06 != g_sic[l_ac].sic06 OR g_sic07_t != g_sic[l_ac].sic07 THEN
         LET g_sic[l_ac].sic06=s_digqty(g_sic[l_ac].sic06, g_sic[l_ac].sic07)
         DISPLAY BY NAME g_sic[l_ac].sic06
      END IF
   END IF
   
   IF NOT cl_null(g_sia.sia04) THEN
      IF NOT cl_null(g_sic[l_ac].sic06) THEN
         IF g_argv1 = '1' THEN   #FUN-AC0074
            IF cl_null(g_sic[l_ac].sic05) OR cl_null(g_sic[l_ac].sic04) THEN
               CALL cl_err('','asf-878',1)
               RETURN FALSE,'sic06'
            END IF
         END IF    #FUN-AC0074
   #FUN-AC0074 ------------Begin--------------
         IF g_argv1 = '2' THEN
            IF cl_null(g_sic[l_ac].sic04) THEN
               CALL cl_err('','asf-878',1)
               RETURN FALSE,'sic06'
            END IF
         END IF
   #FUN-AC0074 ------------End----------------
      END IF
      IF g_sic[l_ac].sic06 >0 THEN
         IF (g_sic[l_ac].sfa05 = 0 OR cl_null(g_sic[l_ac].sfa05)) THEN
            CALL cl_err('','sia-100',0)
            RETURN FALSE,'sic11'
         END IF
      END IF
      IF g_sia.sia04 MATCHES '[1]' THEN
         IF g_sic[l_ac].sic06 <0 THEN
            CALL cl_err(g_sic[l_ac].sic06,"sia-101",1)
            RETURN FALSE,'sic06'
         END IF
         # 同一張備料單也考慮單身有數筆同一張工單的備料量計算
         LET l_sic06x = 0
         SELECT SUM(sic06) INTO l_sic06x FROM sic_file,sia_file
          WHERE sic03=g_sic[l_ac].sic03
            AND sic04=g_sic[l_ac].sic04
            AND sic05=g_sic[l_ac].sic05
            AND sic07=g_sic[l_ac].sic07
            AND sic11=g_sic[l_ac].sic11
            AND sic01 = g_sia.sia01
            AND sic02 != g_sic[l_ac].sic02
            AND sia01=sic01 AND siaconf !='X'
         IF STATUS OR cl_null(l_sic06x) THEN
            LET l_sic06x = 0
         END IF

      END IF
    #FUN-AC0074 -----------------------Begin----------------------------------
      CALL i610sub_chk_sic06(g_sia.sia04,g_argv1,g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03,g_sic[l_ac].sic05,g_sic[l_ac].sic06,
                             g_sic[l_ac].sic07,g_sic[l_ac].sic11,g_sic[l_ac].sic15,g_sic[l_ac].sic012,g_sic[l_ac].sic013 )
      IF g_success = 'N' THEN
         RETURN FALSE,'sic06'
      END IF
    #FUN-AC0074 -----------------------End------------------------------------
      IF g_sia.sia04 ='1' THEN
      #FUN-AC0074 ----------------------Begin----------------------
      #  SELECT img10 INTO l_img10
      #     FROM img_file
      #    WHERE img01=g_sic[l_ac].sic05 AND img02=g_sic[l_ac].sic08
      #      AND img03=g_sic[l_ac].sic09 AND img04=g_sic[l_ac].sic10
      #  SELECT sig05 INTO l_sig05
      #     FROM sig_file
      #    WHERE sig01=g_sic[l_ac].sic05 AND sig02=g_sic[l_ac].sic08
      #      AND sig03=g_sic[l_ac].sic09 AND sig04=g_sic[l_ac].sic10

      #  #sic06备置量  > img10庫存量
      #  LET l_img10 = l_img10 - l_sig05
      #  IF g_sic[l_ac].sic06  > l_img10 THEN
      #        CALL cl_err(g_sic[l_ac].sic06,'sie-002',0)
      #        RETURN FALSE,'sic06'
      #  END IF
         CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,
                               g_sic[l_ac].sic10,g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                               g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
              RETURNING m_img10,m_sic06,m_sig05
         IF (m_img10 - m_sig05)< m_sic06 THEN
            CALL cl_err(g_sic[l_ac].sic05,'sie-002',0)
            RETURN FALSE,'sic06'
         END IF
      #FUN-AC0074 ----------------------End-------------------------
      END IF
      IF g_sia.sia04 ='2' THEN
         IF g_sic[l_ac].sic06 < 0  THEN
            CALL cl_err('','sia-102',1)
            RETURN FALSE,'sic06'
         END IF
      END IF


      IF (g_sia.sia04 = '2') AND (g_sia.sia05='2') THEN    #一般退料

         SELECT SUM(sie11) INTO l_sic06 FROM sie_file
         WHERE  sie01=g_sic[l_ac].sic05 AND sie05=g_sic[l_ac].sic03
          AND sie08=g_sic[l_ac].sic04

         IF cl_null(l_sic06) THEN LET l_sic06 = 0 END IF
         IF l_sic06 < g_sic[l_ac].sic06 THEN
              CALL cl_err(g_sic[l_ac].sic04,'sia-008',1)
              RETURN FALSE,'sic06'
         END IF
      END IF
      #FUN-AC0074 -------------------Begin------------------
      IF (g_sia.sia04 = '2') AND (g_sia.sia05='3') THEN    #一般退料
         SELECT SUM(sie11) INTO l_sic06 FROM sie_file
         WHERE  sie01=g_sic[l_ac].sic04 AND sie05=g_sic[l_ac].sic03

         IF cl_null(l_sic06) THEN LET l_sic06 = 0 END IF
         IF l_sic06 < g_sic[l_ac].sic06 THEN
              CALL cl_err(g_sic[l_ac].sic04,'sia-008',1)
              RETURN FALSE,'sic06'
         END IF
      END IF
      CALL i610_img10_count(g_sic[l_ac].sic05,g_sic[l_ac].sic08,g_sic[l_ac].sic09,g_sic[l_ac].sic10,
                             g_sic[l_ac].sic06,g_sic[l_ac].sic07,
                             g_sia.sia01,g_sic[l_ac].sic02,g_sic[l_ac].sic03)  #MOD-D60230 add
           RETURNING m_img10,m_sic06,m_sig05
      IF (m_img10 - m_sig05)< m_sic06 THEN
         CALL cl_err(g_sic[l_ac].sic05,'sie-002',0)
         RETURN FALSE,'sic06'
      END IF
      #FUN-AC0074 -------------------End--------------------
   END IF
   RETURN TRUE,''
END FUNCTION
#No.FUN-BB0086---end---add---

