# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arti132.4gl
# Descriptions...: 促銷協議維護作業
# Date & Author..: FUN-870008 08/07/19 By Mike
# Modify.........: No.FUN-870007 09/08/27 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30028 10/03/12 By Cockroach add orig/oriu
# Modify.........: No.FUN-A50102 10/07/14 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.TQC-AA0129 10/10/26 By destiny  修改促销类型及促销单来源 
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0046 10/10/27 By huangtao 修改新增時單別開窗只返回3碼的問題
# Modify.........: No.TQC-AB0337 10/11/30 By shenyang GP5.2 SOP流程修改
# Modify.........: No.TQC-AC0106 10/12/13 By huangtao 輸入的時候，經營方式沒有根據採購協議帶過來
# Modify.........: No.TQC-B50152 11/05/30 By lixia 錄入單頭時，點退出，未把單頭畫面清空
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70154 11/07/18 By suncx 促銷稅前單價和含稅單價維護BUG修正
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.TQC-C20195 12/02/16 By fanbj 促銷折扣比率%不可大於100
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 13/02/04 By bart 無單身刪除單頭
# Modify.........: No:FUN-D30033 13/04/10 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rtu           RECORD LIKE rtu_file.*,
    g_rtu_t         RECORD LIKE rtu_file.*,
    g_rtu_o         RECORD LIKE rtu_file.*,
    g_rtu01_t       LIKE rtu_file.rtu01,    #簽核等級 (舊值)
    g_rtu02_t       LIKE rtu_file.rtu02,
    g_rtuplant_t      LIKE rtu_file.rtuplant,
    l_cnt           LIKE type_file.num5,   
    g_rtv           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        rtv03       LIKE rtv_file.rtv03,   #項次
        rtv04       LIKE rtv_file.rtv04,   #商品代碼
        ima02       LIKE ima_file.ima02,   #商品名稱
        ima021      LIKE ima_file.ima021,  #規格型號
        ima1004     LIKE ima_file.ima1004, #品類
        ima1005     LIKE ima_file.ima1005, #品牌 
        ima1009     LIKE ima_file.ima1009, #花色
        ima1007     LIKE ima_file.ima1007, #尺寸 
        rtv05       LIKE rtv_file.rtv05,   #庫存單位 
        rtv05_desc  LIKE gfe_file.gfe02,   #單位名稱
        rtv14       LIKE rtv_file.rtv14,   #默認采購單位
        rtv14_desc  LIKE gfe_file.gfe02,   #單位名稱
        rtv06       LIKE rtv_file.rtv06,   #促銷折扣比例
        rtv07       LIKE rtv_file.rtv07,   #促銷未稅單價  
        rtv07t      LIKE rtv_file.rtv07t,  #促銷含稅單價
        rtv08       LIKE rtv_file.rtv08,   #采購量滿
        rtv09       LIKE rtv_file.rtv09,   #采購額滿 
        rtv10       LIKE rtv_file.rtv10,   #可搭贈量
        rtv11       LIKE rtv_file.rtv11,   #可折扣率
        rtv12       LIKE rtv_file.rtv12,   #結算扣率
        rtv13       LIKE rtv_file.rtv13    #促銷分攤比例
                    END RECORD,
    g_rtv_t         RECORD                 #程式變數 (舊值)
       rtv03       LIKE rtv_file.rtv03,   #項次                                                                       
       rtv04       LIKE rtv_file.rtv04,   #商品代碼                                                                        
       ima02       LIKE ima_file.ima02,   #商品名稱                                                                         
       ima021      LIKE ima_file.ima021,  #規格型號                                                                       
       ima1004     LIKE ima_file.ima1004, #品類                                                                            
       ima1005     LIKE ima_file.ima1005, #品牌                                                                            
       ima1009     LIKE ima_file.ima1009, #花色                                                                            
       ima1007     LIKE ima_file.ima1007, #尺寸                                                                           
       rtv05       LIKE rtv_file.rtv05,   #庫存單位                                                                     
       rtv05_desc  LIKE gfe_file.gfe02,   #單位名稱 
       rtv14       LIKE rtv_file.rtv14,   #默認采購單位
       rtv14_desc  LIKE gfe_file.gfe02,   #單位名稱                                                                  
       rtv06       LIKE rtv_file.rtv06,   #促銷折扣比例                                                                   
       rtv07       LIKE rtv_file.rtv07,   #促銷未稅單價
       rtv07t      LIKE rtv_file.rtv07t,  #促銷含稅單價                                                                    
       rtv08       LIKE rtv_file.rtv08,   #采購量滿                                                                   
       rtv09       LIKE rtv_file.rtv09,   #采購額滿                                                                     
       rtv10       LIKE rtv_file.rtv10,   #可搭贈量
       rtv11       LIKE rtv_file.rtv11,   #可折扣率 
       rtv12       LIKE rtv_file.rtv12,   #結算扣率
       rtv13       LIKE rtv_file.rtv13    #促銷分攤比例 
                    END RECORD,
    g_rtv_o         RECORD                 #程式變數 (舊值)
        rtv03       LIKE rtv_file.rtv03,   #項次                                                                           
        rtv04       LIKE rtv_file.rtv04,   #商品代碼                                                                       
        ima02       LIKE ima_file.ima02,   #商品名稱                                                                      
        ima021      LIKE ima_file.ima021,  #規格型號                                                                        
        ima1004     LIKE ima_file.ima1004, #品類                                                                         
        ima1005     LIKE ima_file.ima1005, #品牌                                                                         
        ima1009     LIKE ima_file.ima1009, #花色                                                                         
        ima1007     LIKE ima_file.ima1007, #尺寸                                                                            
        rtv05       LIKE rtv_file.rtv05,   #庫存單位                                                                      
        rtv05_desc  LIKE gfe_file.gfe02,   #單位名稱 
        rtv14       LIKE rtv_file.rtv14,   #默認采購單位
        rtv14_desc  LIKE gfe_file.gfe02,   #單位名稱                                                                     
        rtv06       LIKE rtv_file.rtv06,   #促銷折扣比例                                                                
        rtv07       LIKE rtv_file.rtv07,   #促銷未稅單價 
        rtv07t      LIKE rtv_file.rtv07t,  #促銷含稅單價                                                                
        rtv08       LIKE rtv_file.rtv08,   #采購量滿                                                                    
        rtv09       LIKE rtv_file.rtv09,   #采購額滿                                                                      
        rtv10       LIKE rtv_file.rtv10,   #可搭贈量        
        rtv11       LIKE rtv_file.rtv11,   #可折扣率                                                            
        rtv12       LIKE rtv_file.rtv12,   #結算扣率                                                                      
        rtv13       LIKE rtv_file.rtv13    #促銷分攤比例     
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  
    g_rec_b         LIKE type_file.num5,   #單身筆數  
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT 
DEFINE p_row,p_col     LIKE type_file.num5  
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE g_chr          LIKE type_file.chr1    
DEFINE g_cnt          LIKE type_file.num10  
DEFINE g_msg          LIKE ze_file.ze03      
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_curs_index   LIKE type_file.num10 
DEFINE g_jump         LIKE type_file.num10   
DEFINE mi_no_ask      LIKE type_file.num5   
DEFINE g_chr2         LIKE type_file.chr1
DEFINE g_chr3         LIKE type_file.chr3         
DEFINE g_gec07        LIKE gec_file.gec07
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   END IF
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rtu_file WHERE rtu01 =? AND rtu02=? AND rtuplant=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i132_cl CURSOR FROM g_forupd_sql
 
        OPEN WINDOW i132_w WITH FORM "art/42f/arti132"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
        CALL cl_ui_init()

#    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
#    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
#    CALL aws_efapp_toolbar()    
#    
#   #將aws_gpmcli_toolbar()移到aws_efapp_toolbar()之後
#       IF g_aza.aza71 MATCHES '[Yy]' THEN 
#          CALL aws_gpmcli_toolbar()
#          CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
#       ELSE
#          CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
#       END IF
#
#    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
#    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,
#    locale, void, confirm, undo_confirm,easyflow_approval")
#          RETURNING g_laststage
#
#   IF (g_sma.sma116 MATCHES '[02]') THEN  
#      CALL cl_set_comp_visible("ima908",FALSE)
#   END IF
 
   CALL i132_menu()
   CLOSE WINDOW i132_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i132_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_rtv.clear()
 
   CALL cl_set_head_visible("","YES")           
   INITIALIZE g_rtu.* TO NULL   
   CONSTRUCT BY NAME g_wc ON rtu01,rtu02,rtu03,rtu04,rtu05,rtu06,rtuplant,rtu17,rtu18,
                             rtu07,rtu08,rtu09,rtu10,rtu11,rtu12,rtu13,rtu14,rtu15,
                         #   rtuconf,rtucond,rtuconu,rtumksg,rtu900,rtu16,#TQC-AB0337  
                             rtuconf,rtucond,rtuconu,rtu16,         #TQC-AB0337 
                             rtuuser,rtugrup,rtumodu,rtudate,rtuacti,rtucrat
                            ,rtuoriu,rtuorig                                   #TQC-A30028 ADD 
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtu01) #促銷協議編號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_rtu01"
               LET g_qryparam.default1 = g_rtu.rtu01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtu01
               NEXT FIELD rtu01
 
            WHEN INFIELD(rtu02) #簽定機構
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtu02"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtu02
               #CALL i132_rtu02('d')
               NEXT FIELD rtu02
 
            WHEN INFIELD(rtu04) #采購協議編號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_rtu04"
               LET g_qryparam.default1 = g_rtu.rtu04
               CALL cl_create_qry() RETURNING g_rtu.rtu04
               DISPLAY BY NAME g_rtu.rtu04
               NEXT FIELD rtu04
 
            WHEN INFIELD(rtu17) #稅別                                                                                       
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.state ="c"                                                                                            
               LET g_qryparam.form ="q_rtu17"                                                                                       
               LET g_qryparam.default1 = g_rtu.rtu17                                                                                
               CALL cl_create_qry() RETURNING g_rtu.rtu17                                                                           
               DISPLAY BY NAME g_rtu.rtu17                                                                                          
               NEXT FIELD rtu17           
 
            WHEN INFIELD(rtu08)   #促銷單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtu08"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtu08
                 NEXT FIELD rtu08
             
            WHEN INFIELD(rtu14)   #簽定人(供應商)                                                                          
                 CALL cl_init_qry_var()                                                                                  
                 LET g_qryparam.form = "q_rtu14"                                                                           
                 LET g_qryparam.state = "c"     
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                         
                 DISPLAY g_qryparam.multiret TO rtu14
               #  CALL i132_rtu14('d')                                                                               
                 NEXT FIELD rtu14 
          
            WHEN INFIELD(rtu15)   #簽定人(內部)                                                                          
                 CALL cl_init_qry_var()                                                                                     
                 LET g_qryparam.form = "q_rtu15"                                                                          
                 LET g_qryparam.state = "c"      
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                         
                 DISPLAY g_qryparam.multiret TO rtu15  
                # CALL i132_rtu15('d')                                                                             
                 NEXT FIELD rtu15  
 
            WHEN INFIELD(rtuconu)   #審核人                                                                               
                 CALL cl_init_qry_var()                                                                                    
                 LET g_qryparam.form = "q_rtuconu"                                                                          
                 LET g_qryparam.state = "c"      
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                     
                 DISPLAY g_qryparam.multiret TO rtuconu                                                                
                 NEXT FIELD rtuconu 
            WHEN INFIELD(rtuplant)   
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtuplant
                 NEXT FIELD rtuplant
            OTHERWISE EXIT CASE
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
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND rtuuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND rtugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET g_wc = g_wc clipped," AND rtugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtuuser', 'rtugrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON rtv03,rtv04,
                      rtv05,rtv14,rtv06,rtv07,rtv07t,rtv08,rtv09,   
                      rtv10,rtv11,rtv12,rtv13           
           FROM s_rtv[1].rtv03,s_rtv[1].rtv04,s_rtv[1].rtv05,s_rtv[1].rtv14,
                s_rtv[1].rtv06,s_rtv[1].rtv07,s_rtv[1].rtv07t,s_rtv[1].rtv08,s_rtv[1].rtv09,
                s_rtv[1].rtv10,s_rtv[1].rtv11,s_rtv[1].rtv12,s_rtv[1].rtv13    
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
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
              WHEN INFIELD(rtv04) #商品代碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_rtv04"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rtv04
                   #CALL i132_rtv04('d')
                   NEXT FIELD rtv04
              WHEN INFIELD(rtv05)     #庫存單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_rtv05"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rtv05
                   #CALL i132_rtv05('d')
                   NEXT FIELD rtv05
              WHEN INFIELD(rtv14) #默認采購單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.state="c"
                   LET g_qryparam.form="q_rtv14"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rtv14
                  #CALL i132_rtv14('d')
                   NEXT FIELD rtv14  
              OTHERWISE EXIT CASE
           END CASE
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
 
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_wc = g_wc CLIPPED," AND rtuplant IN ",g_auth CLIPPED  
   
   IF g_wc2 = " 1=1" OR cl_null(g_wc2) THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT rtu01,rtu02,rtuplant FROM rtu_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY rtu01,rtu02,rtuplant"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE rtu01,rtu02,rtuplant ",
                  "  FROM rtu_file, rtv_file ",
                  " WHERE rtu01 = rtv01",
                  " AND rtu02=rtv02 AND rtuplant=rtvplant ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rtu01,rtu02,rtuplant"
   END IF
 
   PREPARE i132_prepare FROM g_sql
   DECLARE i132_cs                         #CURSOR
       SCROLL CURSOR WITH HOLD FOR i132_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM rtu_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM rtu_file,rtv_file WHERE ",
                "rtv01=rtu01 AND rtv02=rtu02 AND rtvplant=rtuplant AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i132_precount FROM g_sql
   DECLARE i132_count CURSOR FOR i132_precount
 
END FUNCTION
 
FUNCTION i132_rtu14(p_cmd)                                                                                                
DEFINE p_cmd LIKE type_file.chr1                                                                                            
DEFINE l_gen02 LIKE gen_file.gen02                                                                                         
DEFINE l_genacti LIKE gen_file.genacti                                                                                   
                                                                                                                        
LET g_errno =''                                                                                                             
SELECT gen02,genacti INTO l_gen02,l_genacti FROM  gen_file                                                                 
 WHERE gen01=g_rtu.rtu14                                                                                                
CASE                                                                                                                    
   WHEN SQLCA.sqlcode=100 LET g_errno='aoo-070'                                                                        
                          LET l_gen02=NULL                                                                                 
   WHEN l_genacti='N'     LET g_errno='9028'                                                                          
   OTHERWISE                                                                                                              
      LET g_errno = SQLCA.sqlcode USING '------'                                                                            
END CASE                                                                                                              
                                                                                                                         
IF p_cmd='d' OR cl_null(g_errno) THEN                                                                                       
   DISPLAY l_gen02 TO FORMONLY.rtu14_desc                                                                                   
END IF                                                                                                                 
END FUNCTION                   
 
FUNCTION i132_rtu15(p_cmd)                                                                                                  
DEFINE p_cmd LIKE type_file.chr1                                                                                          
DEFINE l_gen02 LIKE gen_file.gen02                                                                                          
DEFINE l_genacti LIKE gen_file.genacti                                                                                     
                                                                                                                       
LET g_errno =''                                                                                                        
SELECT gen02,genacti INTO l_gen02,l_genacti FROM  gen_file                                                                
 WHERE gen01=g_rtu.rtu15                                                                                                 
CASE                                                                                                                    
   WHEN SQLCA.sqlcode=100 LET g_errno='aoo-070'                                                                         
                          LET l_gen02=NULL                                                                             
   WHEN l_genacti='N'     LET g_errno='9028'                                                                            
   OTHERWISE                                                                                                            
      LET g_errno = SQLCA.sqlcode USING '------'                                                                           
END CASE                                                                                                                 
                                                                                                                        
IF p_cmd='d' OR cl_null(g_errno) THEN                                                                                      
   DISPLAY l_gen02 TO FORMONLY.rtu15_desc                                                                     
END IF                                                                                                                     
END FUNCTION   
 
FUNCTION i132_rtuplant(p_cmd)                                                                                               
DEFINE p_cmd LIKE type_file.chr1                                                                                            
DEFINE l_azp02 LIKE azp_file.azp02                                                                                          
                                                                                                                            
LET g_errno =''                                                                                                        
SELECT azp02 INTO l_azp02 FROM  azp_file                                                             
 WHERE azp01=g_rtu.rtuplant                                                                                                
CASE                                                                                                                   
   WHEN SQLCA.sqlcode=100 LET g_errno='art-069'                                                                         
                          LET l_azp02=NULL                                                                             
   OTHERWISE                                                                                                            
      LET g_errno = SQLCA.sqlcode USING '------'                                                                          
END CASE                                                                                                                 
                                                                                                                      
IF p_cmd='d' OR cl_null(g_errno) THEN                                                                                
   DISPLAY l_azp02 TO FORMONLY.rtuplant_desc                                                                             
END IF                                                                                                                   
END FUNCTION          
 
FUNCTION i132_menu()
   DEFINE l_creator     LIKE type_file.chr1   
   DEFINE l_flowuser    LIKE type_file.chr1     # 是否有指定加簽人員      
   DEFINE g_laststage   LIKE type_file.chr1
   LET l_flowuser = "N"
 
   WHILE TRUE
      CALL i132_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i132_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i132_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL i132_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL i132_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL i132_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL i132_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        # WHEN "output"
        #    IF cl_chk_act_auth() THEN
        #       CALL i132_out()
        #    END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL i132_y_chk()          #CALL 原確認的 check 段
                  IF g_success = "Y" THEN
                      CALL i132_y_upd()      #CALL 原確認的 update 段
                  END IF
            END IF
         WHEN "feizhi"
            IF cl_chk_act_auth() THEN
                  CALL i132_feizhi()
            END IF    
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL i132_x()
            END IF
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rtv),'','')
            END IF
#
#       #@WHEN "簽核狀況"
#          WHEN "approval_status"           
#            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
#               IF aws_condition2() THEN
#                    CALL aws_efstat2()    
#               END IF
#            END IF
#
# #@WHEN "准"
#         WHEN "agree"
#              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
#                 CALL i132_y_upd()      #CALL 原確認的 update 段
#              ELSE
#                 LET g_success = "Y"
#                 IF NOT aws_efapp_formapproval() THEN
#                    LET g_success = "N"
#                 END IF
#              END IF
#              IF g_success = 'Y' THEN
#                    IF cl_confirm('aws-081') THEN
#                       IF aws_efapp_getnextforminfo() THEN
#                          LET l_flowuser = 'N'
#                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
#                          IF NOT cl_null(g_argv1) THEN
#                                CALL i132_q()
#                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
#                                CALL aws_efapp_flowaction("insert, modify,
#                                delete, reproduce, detail, query, locale,
#                                void,confirm, undo_confirm,easyflow_approval")
#                                      RETURNING g_laststage
#                          ELSE
#                              EXIT WHILE
#                          END IF
#                        ELSE
#                              EXIT WHILE
#                        END IF
#                    ELSE
#                       EXIT WHILE
#                    END IF
#              END IF
#
#         #@WHEN "不准"
#         WHEN "deny"
#             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
#                IF aws_efapp_formapproval() THEN
#                   IF l_creator = "Y" THEN
#                      LET g_rtu.rtu06 = 'R'
#                      DISPLAY BY NAME g_rtu.rtu06
#                   END IF
#                   IF cl_confirm('aws-081') THEN
#                      IF aws_efapp_getnextforminfo() THEN
#                          LET l_flowuser = 'N'
#                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
#                          IF NOT cl_null(g_argv1) THEN
#                                CALL i132_q()
#                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
#                                CALL aws_efapp_flowaction("insert, modify,
#                                delete,reproduce, detail, query, locale,void,
#                                confirm, undo_confirm,easyflow_approval")
#                                      RETURNING g_laststage
#                           ELSE
#                                EXIT WHILE
#                          END IF
#                      ELSE
#                            EXIT WHILE
#                      END IF
#                   ELSE
#                      EXIT WHILE
#                   END IF
#                END IF
#              END IF
#
#         #@WHEN "加簽"
#         WHEN "modify_flow"
#              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
#                 LET l_flowuser = 'Y'
#              ELSE
#                 LET l_flowuser = 'N'
#              END IF
#
#         #@WHEN "撤簽"
#         WHEN "withdraw"
#              IF cl_confirm("aws-080") THEN
#                 IF aws_efapp_formapproval() THEN
#                    EXIT WHILE
#                 END IF
#              END IF
#
#         #@WHEN "抽單"
#         WHEN "org_withdraw"
#              IF cl_confirm("aws-079") THEN
#                 IF aws_efapp_formapproval() THEN
#                    EXIT WHILE
#              END IF
#              END IF
#
#        #@WHEN "簽核意見"
#         WHEN "phrase"
#              CALL aws_efapp_phrase()
#
#         WHEN "easyflow_approval"   
#           IF cl_chk_act_auth() THEN
#                CALL i132_ef()
#           END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rtu.rtu01 IS NOT NULL THEN
                 LET g_doc.column1 = "rtu01"
                 LET g_doc.value1 = g_rtu.rtu01
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION i132_a()
DEFINE li_result LIKE type_file.num5           
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtv.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rtu.* LIKE rtu_file.*             #DEFAULT 設定
   LET g_rtu01_t = NULL
   LET g_rtu02_t = NULL
   LET g_rtuplant_t= NULL 
   #預設值及將數值類變數清成零
   LET g_rtu_t.* = g_rtu.*
   LET g_rtu_o.* = g_rtu.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rtu.rtu02=g_plant
      CALL i132_rtu02('d')
      LET g_rtu.rtu15=g_user
      LET g_rtu.rtuconf='N' 
      LET g_rtu.rtu900='0'
      LET g_rtu.rtuplant=g_plant
      CALL i132_rtuplant('d')
      LET g_rtu.rtumksg='N'     #TQC-AB0337 
      LET g_rtu.rtuuser=g_user
      LET g_rtu.rtugrup=g_grup
      LET g_rtu.rtucrat=g_today
      LET g_rtu.rtuacti='Y'              #資料有效
      LET g_rtu.rtuoriu = g_user   #TQC-A30028 ADD      
      LET g_rtu.rtuorig = g_grup   #TQC-A30028 ADD
      LET g_data_plant  = g_plant   #TQC-A10128 ADD
      SELECT azw02 INTO g_rtu.rtulegal FROM azw_file
       WHERE azw01 = g_plant


      DISPLAY BY NAME g_rtu.rtuoriu,g_rtu.rtuorig   #TQC-A30028 ADD

      CALL i132_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_rtu.* TO NULL
         CLEAR FORM                      #TQC-B50152
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL OR g_rtu.rtuplant IS NULL THEN  # KEY 不可空白
         CONTINUE WHILE
      END IF
      
      BEGIN WORK 
#     CALL s_auto_assign_no('axm',g_rtu.rtu01,g_today,'A5','rtu_file','rtu01,rtu02,rtuplant','','','')  #FUN-A70130 mark
      CALL s_auto_assign_no('art',g_rtu.rtu01,g_today,'A5','rtu_file','rtu01,rtu02,rtuplant','','','')  #FUN-A70130 mod
         RETURNING li_result,g_rtu.rtu01
      IF (NOT li_result) THEN
          CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rtu.rtu01
    
     #LET g_rtu.rtuoriu = g_user      #No.FUN-980030 10/01/04
     #LET g_rtu.rtuorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO rtu_file VALUES (g_rtu.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      #   ROLLBACK WORK           #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rtu_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK              #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK 
         CALL cl_flow_notify(g_rtu.rtu01,'I')
      END IF
 
      SELECT * INTO g_rtu.* FROM rtu_file
       WHERE rtu01 = g_rtu.rtu01 AND rtu02=g_rtu.rtu02 
         AND rtuplant=g_rtu.rtuplant
      LET g_rtu01_t = g_rtu.rtu01        #保留舊值
      LET g_rtu02_t = g_rtu.rtu02
      LET g_rtuplant_t= g_rtu.rtuplant
      LET g_rtu_t.* = g_rtu.*
      LET g_rtu_o.* = g_rtu.*
      CALL g_rtv.clear()
 
      LET g_rec_b=0  
      CALL i132_b()                   #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i132_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL OR g_rtu.rtuplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtu.* FROM rtu_file
    WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant 
 
   #檢查資料是否已確認
   IF g_rtu.rtuconf='Y' THEN
      CALL cl_err(g_rtu.rtuconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_rtu.rtuconf='X' THEN
      CALL cl_err(g_rtu.rtuconf,'9024',0)
      RETURN
   END IF
 
   IF g_rtu.rtuacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_rtu.rtu01,'mfg1000',0)
      RETURN
   END IF
 
    #只可對簽定機構為當前機構的采購協議進行促銷協議維護                                                                    
    LET l_cnt=0                                                                                                            
    SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                               
      WHERE rts01=g_rtu.rtu04                                                                                               
      AND rtsconf='Y'  AND rts02=g_rtu.rtu02   AND rtsplant=g_rtu.rtuplant
    IF l_cnt=0 THEN                                                                                                        
       CALL cl_err('','art-110',1)
       RETURN                                                                                          
    END IF 
                   
#   IF g_rtu.rtu900 matches '[Ss]' THEN     #  TQC-AB0337      
#        CALL cl_err('','apm-030',0)        #  TQC-AB0337  
#        RETURN                             #  TQC-AB0337  
#  END IF #  TQC-AB0337  
 
#  IF g_rtu.rtumksg= 'Y' AND (g_rtu.rtu900 = '1' AND g_rtu.rtu900 = 'S') THEN   #  TQC-AB0337  
#     CALL cl_err(g_rtu.rtu01,'agl-160',0)                      #  TQC-AB0337 
#     RETURN                                               #  TQC-AB0337          
#  END IF                                                  #  TQC-AB0337 
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtu01_t = g_rtu.rtu01
   LET g_rtu02_t = g_rtu.rtu02 
   LET g_rtuplant_t=g_rtu.rtuplant
   BEGIN WORK
 
   OPEN i132_cl USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant
   IF STATUS THEN
      CALL cl_err("OPEN i132_cl:", STATUS, 1)
      CLOSE i132_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i132_cl INTO g_rtu.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i132_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i132_show()
 
   WHILE TRUE
      LET g_rtu01_t = g_rtu.rtu01
      LET g_rtu02_t = g_rtu.rtu02
      LET g_rtuplant_t= g_rtu.rtuplant
      LET g_rtu_o.* = g_rtu.*
      LET g_rtu.rtumodu=g_user
      LET g_rtu.rtudate=g_today
 
      CALL i132_i("u")                      #欄位更改
 
      SELECT COUNT(*) INTO g_cnt FROM rtv_file                                                                                      
        WHERE rtv01 = g_rtu.rtu01 
          AND rtv02 = g_rtu.rtu02 
          AND rtvplant= g_rtu.rtuplant                                                          
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtu.*=g_rtu_t.*
         CALL i132_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rtu.rtu01 != g_rtu01_t OR g_rtu.rtu02 != g_rtu02_t THEN   # 更改單號
         UPDATE rtv_file SET rtv01 = g_rtu.rtu01,
                             rtv02 = g_rtu.rtu02
          WHERE rtv01 = g_rtu01_t AND rtv02=g_rtu02_t AND rtvplant=g_plant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","rtv_file",g_rtu01_t,"",SQLCA.sqlcode,"","rtv",1)  
            CONTINUE WHILE
         END IF
         LET g_rtu01_t=g_rtu.rtu01
         LET g_rtu02_t=g_rtu.rtu02
      END IF
      
      LET g_rtu.rtu900 = '0'
      UPDATE rtu_file SET rtu_file.* = g_rtu.*
       WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02
         AND rtuplant=g_rtu.rtuplant
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rtu_file","","",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 # DISPLAY BY NAME g_rtu.rtu900      #  TQC-AB0337        
   IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   
 # IF g_rtu.rtu900='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF #  TQC-AB0337 
   CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"","",g_chr,"")         
 
   CLOSE i132_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtu.rtu01,'U')
 
END FUNCTION
 
FUNCTION i132_i(p_cmd)
DEFINE l_n LIKE type_file.num5 
DEFINE li_result LIKE type_file.num5   
DEFINE p_cmd LIKE type_file.chr1         #a:輸入 u:更改  
DEFINE l_rts04 LIKE rts_file.rts04
DEFINE l_rto05 LIKE rto_file.rto05
DEFINE l_rto06 LIKE rto_file.rto06
DEFINE l_rtu09 LIKE rtu_file.rtu09
DEFINE l_rtu10 LIKE rtu_file.rtu10
#DEFINE g_t1 LIKE type_file.chr3               #FUN-AA0046  mark
DEFINE g_t1 LIKE type_file.chr30               #FUN-AA0046 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rtu.rtu02,g_rtu.rtu15,g_rtu.rtuconf,g_rtu.rtuuser,g_rtu.rtumodu,
              #    g_rtu.rtugrup,g_rtu.rtudate,g_rtu.rtuacti,g_rtu.rtucrat,g_rtu.rtumksg,#TQC-AB0337 
                   g_rtu.rtugrup,g_rtu.rtudate,g_rtu.rtuacti,g_rtu.rtucrat,        #TQC-AB0337 
                   g_rtu.rtuplant
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rtu.rtu01,g_rtu.rtu03,g_rtu.rtu04,g_rtu.rtu07,g_rtu.rtu08,g_rtu.rtu09,
             #   g_rtu.rtu10,g_rtu.rtu12,g_rtu.rtu13,g_rtu.rtu14,g_rtu.rtu15,g_rtu.rtumksg,#TQC-AB0337 
                 g_rtu.rtu10,g_rtu.rtu12,g_rtu.rtu13,g_rtu.rtu14,g_rtu.rtu15,#TQC-AB0337 
                 g_rtu.rtu16
       WITHOUT DEFAULTS 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i132_set_entry(p_cmd)
         CALL i132_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rtu01")
 
      AFTER FIELD rtu01   #促銷協議編號
         IF cl_null(g_rtu.rtu01) THEN
            CALL cl_err('','alm-055',1)
            LET g_rtu.rtu01=g_rtu01_t
            DISPLAY BY NAME g_rtu.rtu01
            NEXT FIELD rtu01
         ELSE
            IF g_rtu.rtu01 !=g_rtu01_t OR g_rtu01_t IS NULL THEN
#              CALL s_check_no('AXM',g_rtu.rtu01,g_rtu01_t,'A5','rtu_file','rtu01,rtu02,rtuplant','')  #FUN-A70130 mark
               CALL s_check_no('ART',g_rtu.rtu01,g_rtu01_t,'A5','rtu_file','rtu01,rtu02,rtuplant','')  #FUN-A70130 mod
                    RETURNING li_result,g_rtu.rtu01
               IF (NOT li_result) THEN
                  NEXT FIELD rtu01
               END IF
            END IF
         END IF  
       AFTER FIELD rtu04 #采購協議編號
          IF NOT cl_null(g_rtu.rtu04) THEN
             LET l_cnt=0 
             SELECT COUNT(*) INTO l_cnt FROM rts_file,rto_file
              WHERE rts01=g_rtu.rtu04 
                AND rtsconf='Y' AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant
                AND rto01=rts04 AND rto03=rts02 AND rtoplant=g_plant
                AND rto09>=g_today 
             IF l_cnt=0 THEN 
               CALL cl_err('','art-104',1)
               LET g_rtu.rtu04=g_rtu_o.rtu04
               DISPLAY BY NAME g_rtu.rtu04
               NEXT FIELD rtu04                
             END IF
             #只可對簽定機構為當前機構的采購協議進行促銷協議維護
             LET l_cnt=0                                                                                                 
             SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                     
              WHERE rts01=g_rtu.rtu04                                                                        
                AND rtsconf='Y'  AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant   
                AND rts03 = (SELECT MAX(rts03) FROM rts_file WHERE rts01 = g_rtu.rtu04 
                              AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant)            #TQC-AC0106 
             IF l_cnt=0 THEN                                                                                               
               CALL cl_err('','art-110',1)                                                                                
               LET g_rtu.rtu04=g_rtu_o.rtu04                                                                           
               DISPLAY BY NAME g_rtu.rtu04                                                                             
               NEXT FIELD rtu04                                                                                         
             END IF
 
             SELECT rts06,rts07 INTO g_rtu.rtu17,g_rtu.rtu18 FROM rts_file
              WHERE rts01=g_rtu.rtu04 AND rts02=g_rtu.rtu02 
                AND rtsplant=g_rtu.rtuplant AND rtsconf='Y'
                AND rts03 = (SELECT MAX(rts03) FROM rts_file WHERE rts01 = g_rtu.rtu04
                              AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant)            #TQC-AC0106
             DISPLAY BY NAME g_rtu.rtu17,g_rtu.rtu18
             SELECT rts04 INTO l_rts04 FROM rts_file #合同編號
              WHERE rts01=g_rtu.rtu04 AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant
               AND  rtsconf='Y' 
               AND rts03 = (SELECT MAX(rts03) FROM rts_file WHERE rts01 = g_rtu.rtu04
                            AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant)            #TQC-AC0106
             LET g_errno=''
             CASE
                WHEN SQLCA.sqlcode =100 LET g_errno='atm-123'
                                       LET l_rts04=NULL
                OTHERWISE LET g_errno=SQLCA.sqlcode USING '------'
             END CASE
             IF cl_null(g_errno) THEN
                SELECT rto05,rto06 INTO  l_rto05,l_rto06 FROM rto_file #供應商代碼，經營方式
                 WHERE rto01=l_rts04 AND rto03=g_rtu.rtu02 AND rtoplant=g_rtu.rtuplant
                   AND rto02= (SELECT MAX(rto02) FROM rto_file WHERE  rto01=l_rts04
                                AND rto03=g_rtu.rtu02 AND rtoplant=g_rtu.rtuplant)           #TQC-AC0106
                LET g_errno=''                                                                                            
                CASE                                                                                                    
                   WHEN SQLCA.sqlcode =100 LET g_errno='art-056'                                                          
                                           LET l_rto05=NULL
                                           LET l_rto06=NULL                                                               
                   OTHERWISE LET g_errno=SQLCA.sqlcode USING '------'                                                      
                END CASE
                IF cl_null(g_errno) THEN
                   LET g_rtu.rtu05=l_rto05
                   LET g_rtu.rtu06=l_rto06
                   DISPLAY BY NAME g_rtu.rtu05 #供應商代碼
                   DISPLAY BY NAME g_rtu.rtu06 #經營方式
                   IF g_rtu.rtu06 matches '[12]' THEN                                                                  
                      CALL cl_set_comp_visible("rtv06,rtv07,rtv07t,rtv08,rtv09,rtv10,rtv11",TRUE)
                      CALL cl_set_comp_visible("rtv12",FALSE)  
                      CALL cl_set_comp_required("rtv06,rtv07",TRUE)  
                   ELSE
                      IF g_rtu.rtu06 matches '[34]' THEN                                                                        
                         CALL cl_set_comp_visible("rtv12",TRUE) 
                         CALL cl_set_comp_visible("rtv06,rtv07,rtv07t,rtv08,rtv09,rtv10,rtv11",FALSE)
                         CALL cl_set_comp_required("rtv12",TRUE)                                   
                      END IF  
                   END IF
                   CALL i132_rtu05(p_cmd)
                   CALL i132_rtu17('d')                     
               END IF          
            END IF 
         END IF
      
      AFTER FIELD rtu07
         CALL i132_set_entry(p_cmd)
         CALL i132_set_no_entry(p_cmd)
         IF g_rtu.rtu07 != g_rtu_t.rtu07 THEN
            NEXT FIELD rtu08
         END IF       

      AFTER FIELD rtu08  #促銷單號
         IF NOT cl_null(g_rtu.rtu08) THEN
            #No.TQC-AA0129--begin--mark
            #LET l_cnt=0
            #SELECT COUNT(*) INTO l_cnt FROM rwb_file
            # WHERE rwb04=g_rtu.rtu08 AND rwb03=g_rtu.rtu07 AND rwbplant=g_plant
            #   AND rwbconf='Y'
            #IF l_cnt=0 THEN
            #   CALL cl_err('','art-220',1) 
            #   NEXT FIELD rtu08
            #END IF
            CALL i132_rtu08_check()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD rtu08 
            END IF    
            #No.TQC-AA0129--end
         END IF

      AFTER FIELD rtu09
         IF NOT cl_null(g_rtu.rtu09) THEN
            LET l_cnt=0 
            SELECT COUNT(*) INTO l_cnt FROM rts_file,rto_file 
              WHERE rts01=g_rtu.rtu04 AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant
                AND rtsconf='Y' AND rto08<=g_rtu.rtu09 AND rto09>=g_rtu.rtu09
                AND rto01=rts04 AND rto03=rts02 AND rtoplant=rtsplant AND rtoconf='Y'
            IF l_cnt=0 THEN
               CALL cl_err('','art-106',1)
               LET g_rtu.rtu09=g_rtu_o.rtu09
               DISPLAY BY NAME g_rtu.rtu09               
               NEXT FIELD rtu09
            END IF
            #一份采購協議同一時間只可有一份促銷協議    
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM rtu_file
             WHERE rtu04=g_rtu.rtu04 AND rtu02=g_rtu.rtu02 
               AND rtuplant=g_rtu.rtuplant AND rtuconf='Y' 
            IF l_cnt <>0 THEN
               LET g_sql= "SELECT rtu09,rtu10 FROM rtu_file WHERE rtu02='",g_rtu.rtu02,"' ",
                          " AND rtu04='",g_rtu.rtu04,"' AND rtuplant='",g_rtu.rtuplant,"' ",
                          " AND rtuconf='Y' "
               PREPARE i132_pre FROM g_sql 
               DECLARE i132_cur CURSOR FOR i132_pre
               FOREACH i132_cur INTO l_rtu09,l_rtu10
                  IF g_rtu.rtu09>=l_rtu09 AND g_rtu.rtu09<=l_rtu10 THEN
                      CALL cl_err('','art-109',1)                                                                        
                      LET g_rtu.rtu09=g_rtu_o.rtu09                                                                      
                      DISPLAY BY NAME g_rtu.rtu09
                      NEXT FIELD rtu09  
                      EXIT FOREACH                                                                                         
                  END IF
                  LET l_rtu09=''
                  LET l_rtu10=''  
               END FOREACH 
            END IF                                                                                   
            IF NOT cl_null(g_rtu.rtu10) THEN
               IF g_rtu.rtu09>g_rtu.rtu10 THEN
                  CALL cl_err('',-9913,1)
                  LET g_rtu.rtu09=g_rtu_o.rtu09
                  DISPLAY BY NAME g_rtu.rtu09
                  NEXT FIELD rtu09
               END IF
            END IF
         END IF   
      AFTER FIELD rtu10                                                                                                    
         IF NOT cl_null(g_rtu.rtu10) THEN
            LET l_cnt=0                                                                                                  
            SELECT COUNT(*) INTO l_cnt FROM rts_file,rto_file                                                                      
              WHERE rts01=g_rtu.rtu04 AND rts02=g_rtu.rtu02                                          
                AND rtsconf='Y' AND rto08<=g_rtu.rtu10 
                AND rto09>=g_rtu.rtu10 AND rtoplant=rtsplant AND rtoconf='Y'  
                AND rto01=rts04 AND rto03=rts02                                        
            IF l_cnt=0 THEN                                                                                                
               CALL cl_err('','art-106',1)                                                                               
               LET g_rtu.rtu10=g_rtu_o.rtu10                                                                            
               DISPLAY BY NAME g_rtu.rtu10                                                                               
               NEXT FIELD rtu10                                                                                          
            END IF   
            #一份采購協議同一時間只可有一份促銷協議
            LET l_cnt=0 
            SELECT COUNT(*) INTO l_cnt FROM rtu_file                                                                       
             WHERE rtu04=g_rtu.rtu04 AND rtu02=g_rtu.rtu02 
               AND rtuplant=g_rtu.rtuplant AND rtuconf='Y'                                  
            IF l_cnt <>0 THEN                                                                                              
               LET g_sql = "SELECT rtu09,rtu10 FROM rtu_file WHERE rtu02='",g_rtu.rtu02,"' ",                                      
                           "   AND rtu04='",g_rtu.rtu04,"' AND rtuplant='",g_rtu.rtuplant,"' ",                                  
                           "   AND rtuconf='Y' "                                                                           
               DECLARE i132_cur1 CURSOR FROM g_sql                                                                          
               FOREACH i132_cur1 INTO l_rtu09,l_rtu10                                                                      
                  IF g_rtu.rtu10>=l_rtu09 AND g_rtu.rtu10<=l_rtu10 THEN                                                   
                      CALL cl_err('','art-109',1)                                                                      
                      LET g_rtu.rtu10=g_rtu_o.rtu10                                                                      
                      DISPLAY BY NAME g_rtu.rtu10                                                                       
                      NEXT FIELD rtu10                                                                                   
                      EXIT FOREACH                                                                                        
                  END IF                                                                                                
                  LET l_rtu09=''                                                                                         
                  LET l_rtu10=''                                                                                          
               END FOREACH                                                                                                 
            END IF                                                                                                         
            IF NOT cl_null(g_rtu.rtu09) THEN                                                                             
               IF g_rtu.rtu09>g_rtu.rtu10 THEN                                                                         
                  CALL cl_err('',-9913,1)                                                                               
                  LET g_rtu.rtu10=g_rtu_o.rtu10
                  DISPLAY BY NAME g_rtu.rtu10                                                                        
                  NEXT FIELD rtu10                                                                                      
               END IF                                                                                                   
            END IF
         END IF       
      
      AFTER FIELD rtu12
         IF NOT cl_null(g_rtu.rtu12) THEN
            IF g_rtu.rtu12<=0 THEN 
               CALL cl_err('','axm_109',1)
               LET g_rtu.rtu12=g_rtu_o.rtu12
               DISPLAY BY NAME g_rtu.rtu12
               NEXT FIELD rtu12
            END IF
            #TQC-C20195--start add----------------
            IF g_rtu.rtu12 > 100 THEN
               CALL cl_err('','alm-453',0)
               LET g_rtu.rtu12=g_rtu_t.rtu12
               DISPLAY BY NAME g_rtu.rtu12
               NEXT FIELD rtu12
            END IF
            #TQC-C20195--end add------------------  
         END IF
      
      AFTER FIELD rtu13                                                                                               
         IF NOT cl_null(g_rtu.rtu13) THEN                                                                                
            IF g_rtu.rtu13<=0 THEN                                                                                       
               CALL cl_err('','axm_109',1)                                                                              
               LET g_rtu.rtu13=g_rtu_o.rtu13                                                                               
               DISPLAY BY NAME g_rtu.rtu13                                     
               NEXT FIELD rtu13                                                                                      
            END IF                                                                                         
         END IF 
                       
      AFTER FIELD rtu14
         IF NOT cl_null(g_rtu.rtu14) THEN 
            LET l_cnt=0 
            SELECT COUNT(*) INTO l_cnt FROM gen_file
             WHERE gen01=g_rtu.rtu14 AND genacti='Y'
            IF l_cnt=0 THEN
               CALL cl_err('','aap-038',1)
               LET g_rtu.rtu14=g_rtu_o.rtu14
               DISPLAY BY NAME g_rtu.rtu14
               NEXT FIELD rtu14
            END IF
         END IF
         CALL i132_rtu14('d')
  
      AFTER FIELD rtu15                                                                                                     
         IF NOT cl_null(g_rtu.rtu15) THEN                                                                                  
            LET l_cnt=0                                                                                                 
            SELECT COUNT(*) INTO l_cnt FROM gen_file                                                                    
             WHERE gen01=g_rtu.rtu15 AND genacti='Y'                                                                     
            IF l_cnt=0 THEN                                                                                                 
               CALL cl_err('','aap-038',1)                                                                               
               LET g_rtu.rtu15=g_rtu_o.rtu15                                                                               
               DISPLAY BY NAME g_rtu.rtu15                                                                                 
               NEXT FIELD rtu15                                                                                            
            END IF
         END IF              
         CALL i132_rtu15('d')                                                                                            
      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtu01)
               LET g_t1=s_get_doc_no(g_rtu.rtu01)
               CALL q_oay(false,false,g_t1,'A5','art') RETURNING g_t1         #FUN-A70130
               LET g_rtu.rtu01=g_t1
               DISPLAY BY NAME g_rtu.rtu01
               NEXT FIELD rtu01
         
            WHEN INFIELD(rtu04)                                                                                             
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.form ="q_rts01"                                                                            
               LET g_qryparam.default1 = g_rtu.rtu04
               LET g_qryparam.arg1 = g_rtu.rtu02
               LET g_qryparam.arg2 = g_today
               CALL cl_create_qry() RETURNING g_rtu.rtu04                                                                
               DISPLAY BY NAME g_rtu.rtu04                                                                              
               NEXT FIELD rtu04   
 
            WHEN INFIELD(rtu08)
               CALL cl_init_qry_var() 
               #No.TQC-AA0129--begin 
               CASE g_rtu.rtu07
                  WHEN "1" 
                    LET g_qryparam.form ="q_rab1" 
                  WHEN "2"
                    LET g_qryparam.form ="q_rae1" 
                  WHEN "3"
                    LET g_qryparam.form ="q_rah1" 
               END CASE 
               LET g_qryparam.arg1 = g_plant
               #LET g_qryparam.form ="q_rwb04_2" 
               #LET g_qryparam.arg1 = g_rtu.rtu07
               #No.TQC-AA0129--end
               LET g_qryparam.default1 = g_rtu.rtu08
               CALL cl_create_qry() RETURNING g_rtu.rtu08  
               DISPLAY BY NAME g_rtu.rtu08  
               NEXT FIELD rtu08 
  
            WHEN INFIELD(rtu14)                                                                                         
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.form ="q_gen"                                                                            
               LET g_qryparam.default1 = g_rtu.rtu14                                                                        
               CALL cl_create_qry() RETURNING g_rtu.rtu14                                                                  
               DISPLAY BY NAME g_rtu.rtu14
               CALL i132_rtu14('d')                                                                                         
               NEXT FIELD rtu14  
            WHEN INFIELD(rtu15)                                                                                             
               CALL cl_init_qry_var()                                                                                    
               LET g_qryparam.form ="q_gen"                                                                              
               LET g_qryparam.default1 = g_rtu.rtu15                                                                        
               CALL cl_create_qry() RETURNING g_rtu.rtu15                                                                 
               DISPLAY BY NAME g_rtu.rtu15
               CALL i132_rtu15('d')                                                                                         
               NEXT FIELD rtu15                           
            OTHERWISE EXIT CASE
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
 
   END INPUT
 
END FUNCTION

#No.TQC-AA0129--begin
FUNCTION i132_rtu08_check()
DEFINE l_rabacti   LIKE rab_file.rabacti
DEFINE l_rabconf   LIKE rab_file.rabconf 
    LET g_errno='' 
    CASE g_rtu.rtu07 
       WHEN "1"
          SELECT rabacti,rabconf INTO l_rabacti,l_rabconf
            FROM rab_file WHERE rab02=g_rtu.rtu08 AND rabplant=g_plant 
          IF SQLCA.sqlcode=100 THEN LET g_errno='art-220' END IF 
          IF l_rabacti='N' THEN LET g_errno='art-686' END IF 
          IF l_rabconf!='Y' THEN LET g_errno='art-685' END IF 
       WHEN "2"
          SELECT raeacti,raeconf INTO l_rabacti,l_rabconf
            FROM rae_file WHERE rae02=g_rtu.rtu08 AND raeplant=g_plant 
          IF SQLCA.sqlcode=100 THEN LET g_errno='art-220' END IF 
          IF l_rabacti='N' THEN LET g_errno='art-686' END IF 
          IF l_rabconf!='Y' THEN LET g_errno='art-685' END IF 
       WHEN "3"
          SELECT rahacti,rahconf INTO l_rabacti,l_rabconf
            FROM rah_file WHERE rah02=g_rtu.rtu08 AND rahplant=g_plant 
          IF SQLCA.sqlcode=100 THEN LET g_errno='art-220' END IF 
          IF l_rabacti='N' THEN LET g_errno='art-686' END IF 
          IF l_rabconf!='Y' THEN LET g_errno='art-685' END IF    
    END CASE 
END FUNCTION   
#No.TQC-AA0129--end
 
FUNCTION i132_rtu02(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_azp02 LIKE azp_file.azp02
 
LET g_errno =''
SELECT azp02 INTO l_azp02 FROM  azp_file 
 WHERE azp01=g_rtu.rtu02
CASE 
   WHEN SQLCA.sqlcode=100 LET g_errno='art-055'
                          LET l_azp02=NULL
   OTHERWISE 
      LET g_errno = SQLCA.sqlcode USING '------'
END CASE
 
IF p_cmd='d' OR cl_null(g_errno) THEN
   DISPLAY l_azp02 TO FORMONLY.rtu02_desc
END IF
END FUNCTION
      
FUNCTION i132_rtu05(p_cmd)
DEFINE  p_cmd LIKE type_file.chr1
DEFINE  l_pmc03 LIKE pmc_file.pmc03
 
   SELECT pmc03 INTO l_pmc03 FROM pmc_file                              
    WHERE pmc01=g_rtu.rtu05 AND pmcacti='Y' AND pmc05='1'                                                                         
   LET g_errno=''                                                                                                   
   CASE                                                                                                             
      WHEN SQLCA.sqlcode =100 LET g_errno='art-056'                                                                   
                              LET l_pmc03=NULL
      OTHERWISE LET g_errno=SQLCA.sqlcode USING '------'                                                              
   END CASE   
   IF p_cmd = 's' THEN
      DISPLAY l_pmc03 TO FORMONLY.rtu05_desc   
      RETURN
   END IF
   IF cl_null(g_errno) OR p_cmd='d' THEN                                                                                         
      DISPLAY l_pmc03 TO FORMONLY.rtu05_desc  
   END IF                                                
END FUNCTION
 
FUNCTION i132_rtu17(p_cmd)
DEFINE  p_cmd LIKE type_file.chr1                                                                                                   
                                                                                                                                    
   SELECT gec07 INTO g_gec07 FROM gec_file                                                                     
    WHERE gec01=g_rtu.rtu17 AND gecacti='Y' AND gec011='1'                                                                          
   LET g_errno=''                                                                                                                   
   CASE                                                                                                                             
      WHEN SQLCA.sqlcode =100 LET g_errno='art-056'                                                                                 
                              LET g_gec07=NULL                                                                                      
      OTHERWISE LET g_errno=SQLCA.sqlcode USING '------'                                                                            
   END CASE                                                                                                                         
   IF cl_null(g_errno) THEN                   
      DISPLAY g_gec07 TO FORMONLY.gec07                                                                                        
   END IF                       
END FUNCTION
 
FUNCTION i132_rtuconu(p_cmd)
DEFINE  p_cmd LIKE type_file.chr1   
DEFINE  l_gen02 LIKE gen_file.gen02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtu.rtuconu AND genacti='Y'
   IF SQLCA.sqlcode=100 THEN LET l_gen02=NULL END IF
   IF p_cmd='d' THEN DISPLAY l_gen02 TO FORMONLY.rtuconu_desc END IF
END FUNCTION 
   
FUNCTION i132_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rtu.* TO NULL                 
 
   CALL cl_msg("")                        
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rtv.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i132_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rtu.* TO NULL
      RETURN
   END IF
 
   OPEN i132_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rtu.* TO NULL
   ELSE
      OPEN i132_count
      FETCH i132_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i132_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i132_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     i132_cs INTO g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant
       WHEN 'P' FETCH PREVIOUS i132_cs INTO g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant 
       WHEN 'F' FETCH FIRST    i132_cs INTO g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant 
       WHEN 'L' FETCH LAST     i132_cs INTO g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant 
       WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i132_cs INTO g_rtu.rtu01,
                                               g_rtu.rtu02,g_rtu.rtuplant
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)
      INITIALIZE g_rtu.* TO NULL  
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
 
   SELECT * INTO g_rtu.* FROM rtu_file 
    WHERE rtu01 = g_rtu.rtu01
      AND rtu02 = g_rtu.rtu02
      AND rtuplant=g_rtu.rtuplant 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rtu_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rtu.* TO NULL
      RETURN
   END IF
   LET g_data_plant = g_rtu.rtuplant #TQC-A10128 ADD
   CALL i132_show()
 
END FUNCTION
 
FUNCTION i132_show()
 
   LET g_rtu_t.* = g_rtu.*                #保存單頭舊值
   LET g_rtu_o.* = g_rtu.*                #保存單頭舊值
   DISPLAY BY NAME g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtu03,g_rtu.rtu04,g_rtu.rtu05,
                   g_rtu.rtu06,g_rtu.rtuplant,g_rtu.rtu07,g_rtu.rtu08,g_rtu.rtu09,g_rtu.rtu10,
                   g_rtu.rtu11,g_rtu.rtu12,g_rtu.rtu13,g_rtu.rtu14,g_rtu.rtu15,
                  #g_rtu.rtuconf,g_rtu.rtucond,g_rtu.rtuconu,g_rtu.rtumksg,#TQC-AB0337
                   g_rtu.rtuconf,g_rtu.rtucond,g_rtu.rtuconu,              #TQC-AB0337
                   g_rtu.rtu16,
                   g_rtu.rtuuser,g_rtu.rtu17,g_rtu.rtu18,
                   g_rtu.rtugrup,g_rtu.rtumodu,g_rtu.rtudate,g_rtu.rtuacti,g_rtu.rtucrat
                  ,g_rtu.rtuoriu,g_rtu.rtuorig                           #TQC-A30028 ADD
 
   IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
#  IF g_rtu.rtu900='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF #  TQC-AB0337 
   CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"","",g_chr,"")
   CALL i132_rtu02('d')
   CALL i132_rtu05('s') 
   CALL i132_rtu17('d')
   CALL i132_rtuplant('d')
   CALL i132_rtuconu('d')   
   CALL i132_rtu14('d')
   CALL i132_rtu15('d') 
   IF g_rtu.rtu06 matches '[12]' THEN 
      CALL cl_set_comp_visible("rtv06,rtv07,rtv08,rtv09,rtv10,rtv11",TRUE)
      CALL cl_set_comp_visible("rtv12",FALSE)  
   ELSE
      IF g_rtu.rtu06 MATCHES '[34]' THEN    
         CALL cl_set_comp_visible("rtv12",TRUE)
         CALL cl_set_comp_visible("rtv06,rtv07,rtv08,rtv09,rtv10,rtv11",FALSE)    
      END IF
   END IF
   CALL i132_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()            
END FUNCTION
 
FUNCTION i132_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL  THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtu.* FROM rtu_file
    WHERE rtu01=g_rtu.rtu01
      AND rtu02=g_rtu.rtu02
      AND rtuplant=g_rtu.rtuplant
   #檢查資料是否已確認
   IF g_rtu.rtuconf='Y' THEN
      CALL cl_err(g_rtu.rtuconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_rtu.rtuconf='X' THEN
      CALL cl_err(g_rtu.rtuconf,'9024',0)
      RETURN
   END IF
 
   IF g_rtu.rtuacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_rtu.rtu01,'mfg1000',0)
      RETURN
   END IF
 
#   IF g_rtu.rtumksg = 'Y' AND (g_rtu.rtu900 = '1' OR g_rtu.rtu900 = 'S')  #  TQC-AB0337 
#  THEN                                                         #  TQC-AB0337 
#     CALL cl_err(g_rtu.rtu01,'agl-160',0)                      #  TQC-AB0337 
#     RETURN                        #  TQC-AB0337 
#  END IF                       #  TQC-AB0337 
   #只可對簽定機構為當前機構的采購協議進行促銷協議維護                                                                     
    LET l_cnt=0                                                                                                             
    SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                            
      WHERE rts01=g_rtu.rtu04                                                                                           
      AND rtsconf='Y' AND rts02=g_plant  
                                                                        
    IF l_cnt=0 THEN                                                                                                     
       CALL cl_err('','art-110',1)                                                                                      
       RETURN                                                                                                         
    END IF             
   BEGIN WORK
 
   OPEN i132_cl USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant
   IF STATUS THEN
      CALL cl_err("OPEN i132_cl:", STATUS, 1)
      CLOSE i132_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i132_cl INTO g_rtu.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i132_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rtu01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rtu.rtu01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM rtu_file WHERE rtu01 = g_rtu.rtu01 AND rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant
      DELETE FROM rtv_file WHERE rtv01 = g_rtu.rtu01 AND rtv02=g_rtu.rtu02 AND rtvplant=g_rtu.rtuplant
      CLEAR FORM
      CALL g_rtv.clear()
      OPEN i132_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i132_cs
         CLOSE i132_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i132_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i132_cs
         CLOSE i132_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i132_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i132_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i132_fetch('/')
      END IF
   END IF
 
   CLOSE i132_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtu.rtu01,'D')
 
END FUNCTION
 
FUNCTION i132_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,    #檢查重複用 
    l_cnt           LIKE type_file.num5,    #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    p_cmd           LIKE type_file.chr1,    #處理狀態  
    l_cmd           LIKE type_file.chr1000,
    l_allow_insert  LIKE type_file.num5,    #可新增否  
    l_allow_delete  LIKE type_file.num5,    #可刪除否 
    l_rtu900        LIKE rtu_file.rtu900
DEFINE l_rtt11   LIKE rtt_file.rtt11
DEFINE l_rtt06   LIKE rtt_file.rtt06
      
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rtu.* FROM rtu_file
     WHERE rtu01=g_rtu.rtu01
      AND  rtu02=g_rtu.rtu02
  # LET l_rtu900 = g_rtu.rtu900   #  TQC-AB0337  
 
   #檢查資料是否已確認
   IF g_rtu.rtuconf='Y' THEN
      CALL cl_err(g_rtu.rtuconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_rtu.rtuconf='X' THEN
      CALL cl_err(g_rtu.rtuconf,'9024',0)
      RETURN
   END IF
 
#   IF g_rtu.rtu900 matches '[Ss]' THEN    #  TQC-AB0337    
#        CALL cl_err('','apm-030',0)       #  TQC-AB0337 
#        RETURN                            #  TQC-AB0337 
#  END IF   #  TQC-AB0337 
 
   IF g_rtu.rtuacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_rtu.rtu01,'mfg1000',0)
      RETURN
   END IF
 
   #只可對簽定機構為當前機構的采購協議進行促銷協議維護                                                                  
    LET l_cnt=0                                                                                                           
    SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                                
      WHERE rts01=g_rtu.rtu04                                                                                               
      AND rtsconf='Y'      AND rts02=g_plant                                                                        
    IF l_cnt=0 THEN                                                                                                      
       CALL cl_err('','art-110',1)                                                                                       
       RETURN                                                                                                           
    END IF              
   CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rtv03,rtv04,'','','','','','',rtv05,'',rtv14,'',rtv06,rtv07,rtv07t,rtv08,",  
                       "       rtv09,rtv10,rtv11,rtv12,rtv13 ", 
                       "  FROM rtv_file",
                       " WHERE rtv01=? AND rtv02=? ",
                       "   AND rtv03=? AND rtvplant=? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i132_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rtv WITHOUT DEFAULTS FROM s_rtv.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
 
           BEGIN WORK
           OPEN i132_cl USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant
           IF STATUS THEN
              CALL cl_err("OPEN i132_cl:", STATUS, 1)
              CLOSE i132_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i132_cl INTO g_rtu.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i132_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rtv_t.* = g_rtv[l_ac].*  #BACKUP
              LET g_rtv_o.* = g_rtv[l_ac].*  #BACKUP
              OPEN i132_bcl USING g_rtu.rtu01,g_rtu.rtu02,g_rtv_t.rtv03,g_rtu.rtuplant
              IF STATUS THEN
                 CALL cl_err("OPEN i132_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i132_bcl INTO g_rtv[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rtv_t.rtv03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL i132_rtv04('d')
              CALL i132_rtv14('d')
              CALL i132_set_entry_b(p_cmd)      
              CALL i132_set_no_entry_b(p_cmd)  
              CALL cl_show_fld_cont()     
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rtv[l_ac].* TO NULL  
           IF cl_null(g_rtu.rtu12) THEN 
              LET g_rtv[l_ac].rtv06 = 100
           ELSE
              LET g_rtv[l_ac].rtv06 = g_rtu.rtu12
           END IF 
           LET g_rtv[l_ac].rtv13 = g_rtu.rtu13
           IF NOT cl_null(g_rtu.rtu12) THEN                                                                             
              LET g_rtv[l_ac].rtv12=g_rtu.rtu12                                                                           
           ELSE                                                                                                       
              LET l_rtt11=''                                                                                           
              SELECT rtt11 INTO l_rtt11 FROM rtt_file WHERE rtt01=g_rtu.rtu04                                           
               AND rtt02=g_rtu.rtu02 AND rtt15='Y'                                              
              IF SQLCA.sqlcode =100 THEN                                                                                   
                 LET l_rtt11=null                                                                                         
              ELSE                                                                                                     
                 LET  g_rtv[l_ac].rtv12=l_rtt11                                                                           
              END IF                                                                                                     
           END IF 
           LET g_rtv[l_ac].rtv07 = 0
           LET g_rtv[l_ac].rtv07t = 0         
           LET g_rtv_t.* = g_rtv[l_ac].*         #新輸入資料
           LET g_rtv_o.* = g_rtv[l_ac].*         #新輸入資料
           CALL i132_set_entry_b(p_cmd)     
           CALL i132_set_no_entry_b(p_cmd)  
           CALL cl_show_fld_cont()    
           NEXT FIELD rtv03
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rtv_file(rtv01,rtv02,rtv03,rtv04,rtv05,rtv06,rtv07,rtv07t,
                                rtv08,rtv09,rtv10,rtv11,rtv12,rtv13,rtv14,rtvplant,rtvlegal) 
                VALUES(g_rtu.rtu01,g_rtu.rtu02,
                       g_rtv[l_ac].rtv03,g_rtv[l_ac].rtv04,
                       g_rtv[l_ac].rtv05,g_rtv[l_ac].rtv06,
                       g_rtv[l_ac].rtv07,g_rtv[l_ac].rtv07t,
                       g_rtv[l_ac].rtv08,
                       g_rtv[l_ac].rtv09,g_rtv[l_ac].rtv10,  
                       g_rtv[l_ac].rtv11,g_rtv[l_ac].rtv12, 
                       g_rtv[l_ac].rtv13,g_rtv[l_ac].rtv14,
                       g_plant,g_rtu.rtulegal)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","rtv_file",g_rtu.rtu01,g_rtv[l_ac].rtv03,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rtv03                        #default 序號
           IF g_rtv[l_ac].rtv03 IS NULL OR g_rtv[l_ac].rtv03 = 0 THEN
              SELECT max(rtv03)+1 INTO g_rtv[l_ac].rtv03 FROM rtv_file
               WHERE rtv01 = g_rtu.rtu01 AND rtv02 = g_rtu.rtu02
                 AND rtvplant=g_rtu.rtuplant
              IF g_rtv[l_ac].rtv03 IS NULL THEN
                 LET g_rtv[l_ac].rtv03 = 1
              END IF
           END IF
 
        AFTER FIELD rtv03       #check 序號是否重複
           IF NOT cl_null(g_rtv[l_ac].rtv03) THEN
              IF g_rtv[l_ac].rtv03<=0 THEN
                 CALL cl_err('','aec-994',1)
                 LET g_rtv[l_ac].rtv03=g_rtv_t.rtv03
                 DISPLAY BY NAME g_rtv[l_ac].rtv03
                 NEXT FIELD rtv03
              END IF
              IF g_rtv[l_ac].rtv03 != g_rtv_t.rtv03 OR g_rtv_t.rtv03 IS NULL THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM rtv_file
                  WHERE rtv01 = g_rtu.rtu01
                    AND rtv02 = g_rtu.rtu02
                    AND rtv03=g_rtv[l_ac].rtv03
                    AND rtvplant=g_rtu.rtuplant
                 IF l_cnt > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rtv[l_ac].rtv03 = g_rtv_t.rtv03
                    NEXT FIELD rtv03
                 END IF
              END IF
           END IF
 
        AFTER FIELD rtv04                  #商品代碼
           IF NOT cl_null(g_rtv[l_ac].rtv04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_rtv[l_ac].rtv04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rtv[l_ac].rtv04= g_rtv_t.rtv04
                 NEXT FIELD rtv04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              LET l_cnt=0 
              SELECT COUNT(*) INTO l_cnt FROM rtt_file                                                                      
                WHERE rtt01=g_rtu.rtu04 AND rtt02=g_rtu.rtu02
                  AND rtt15='Y' AND rtt04=g_rtv[l_ac].rtv04                                                               
              IF l_cnt=0 THEN                                                                                              
                 #CALL cl_err('','art-030',1)                #TQC-C20195 mark 
                 CALL cl_err('','art1049',0)                 #TQC-C20195 add                                                            
                 LET g_rtv[l_ac].rtv04=g_rtv_t.rtv04                                                                     
                 DISPLAY BY NAME g_rtv[l_ac].rtv04                                                                      
                 NEXT FIELD rtv04 
              ELSE
                 IF g_rtv[l_ac].rtv04 != g_rtv_t.rtv04 OR g_rtv_t.rtv04 IS NULL THEN         
                    LET l_cnt=0
                    SELECT count(*) INTO l_cnt FROM rtv_file,rtu_file
                     WHERE rtv01=rtu01 AND rtv02=rtu02 
                       AND rtu08=g_rtu.rtu08
                       AND rtv04=g_rtv[l_ac].rtv04
                    IF l_cnt !=0 THEN
                       CALL cl_err('','art-227',1) 
                       NEXT FIELD rtv04
                    END IF
                 END IF                                                                                       
              END IF
           END IF    
           CALL i132_rtv04('d')
           CALL i132_rtv14('d')
 
        BEFORE FIELD rtv07
             LET g_errno=''
             LET l_rtt06 =''
             SELECT rtt06 INTO l_rtt06 FROM rtt_file
              WHERE rtt01 = g_rtu.rtu04 AND rtt02 = g_rtu.rtu02 AND rtt15 = 'Y'
                AND rttplant = g_plant AND rtt04 = g_rtv[l_ac].rtv04      #MOD-B70154
             IF SQLCA.sqlcode=100 THEN 
                LET l_rtt06=NULL 
                LET g_errno='art-111'
             ELSE
             	  IF NOT cl_null(l_rtt06) THEN                   #MOD-B70154
                   IF NOT cl_null(g_rtv[l_ac].rtv06) THEN
                      LET g_rtv[l_ac].rtv07=l_rtt06*g_rtv[l_ac].rtv06/100
                   ELSE 
                      LET g_rtv[l_ac].rtv07=l_rtt06
                   END IF
                #MOD-B70154 add begin---------
                ELSE
                	 LET l_rtt06=NULL                                                                             
                   LET g_errno='art-111'
                END IF  
                #MOD-B70154 add end-----------
             END IF
        
        AFTER FIELD rtv06                                                                                                          
         IF NOT cl_null(g_rtv[l_ac].rtv06) THEN                                                                                    
            IF g_rtv[l_ac].rtv06<=0 THEN                                                                                           
               CALL cl_err('','axm_109',1)                                                                                          
               LET g_rtv[l_ac].rtv06=g_rtv_t.rtv06                                                                                 
               DISPLAY BY NAME g_rtv[l_ac].rtv06                                                                                   
               NEXT FIELD rtv06                                                                                                     
            END IF      
            #TQC-C20195--start add---------------------
            IF g_rtv[l_ac].rtv06 >100 THEN
               CALL cl_err('','alm-453',0)
               LET g_rtv[l_ac].rtv06=g_rtv_t.rtv06
               DISPLAY BY NAME g_rtv[l_ac].rtv06
               NEXT FIELD rtv06
            END IF
            #TQC-C20195--end add-----------------------                                                                                                            
         END IF                
      
        AFTER FIELD rtv07
           IF NOT cl_null(g_rtv[l_ac].rtv07) THEN
              IF g_rtv[l_ac].rtv07<=0 THEN                                                                                         
                 CALL cl_err('','aap-505',1)                                                                                        
                 LET g_rtv[l_ac].rtv07=g_rtv_t.rtv07                                                                                 
                 DISPLAY BY NAME g_rtv[l_ac].rtv07                                                                                   
                 NEXT FIELD rtv07                                                                                                   
              END IF 
              LET g_rtv_o.rtv07 = g_rtv[l_ac].rtv07                                                                                 
              LET g_rtv[l_ac].rtv07t= g_rtv[l_ac].rtv07 * (1 + g_rtu.rtu18/100)                                                    
              LET g_rtv_o.rtv07t = g_rtv[l_ac].rtv07t                                                                               
              LET g_errno=''                                                                                                
              LET l_rtt06 =''                                                                                                
              SELECT rtt06 INTO l_rtt06 FROM rtt_file                                                                        
               WHERE rtt01=g_rtu.rtu04 AND rtt02=g_rtu.rtu02                                     
                 AND rtt15='Y'
                 AND rttplant = g_plant AND rtt04 = g_rtv[l_ac].rtv04      #MOD-B70154                                                                                            
              IF SQLCA.sqlcode=100 THEN 
                 LET l_rtt06=NULL                                                                     
                 LET g_errno='art-111'                                                               
              ELSE
              	 IF NOT cl_null(l_rtt06) THEN                   #MOD-B70154
                    LET g_rtv[l_ac].rtv06=g_rtv[l_ac].rtv07/l_rtt06*100 
                 #MOD-B70154 add begin---------
                 ELSE
                	  LET l_rtt06=NULL                                                                             
                    LET g_errno='art-111'
                 END IF  
                 #MOD-B70154 add end-----------
              END IF
           END IF
         
        AFTER FIELD rtv07t
           IF NOT cl_null(g_rtv[l_ac].rtv07t) THEN                                                                                 
              IF g_rtv[l_ac].rtv07t<=0 THEN                                                                                         
                CALL cl_err('','aap-505',1)                                                                                         
                LET g_rtv[l_ac].rtv07t=g_rtv_t.rtv07t                                                                              
                DISPLAY BY NAME g_rtv[l_ac].rtv07t                                                                                
                NEXT FIELD rtv07t                                                                                                   
              END IF                                                                                                                
              LET g_rtv_o.rtv07t = g_rtv[l_ac].rtv07t                                                                           
              #LET g_rtv[l_ac].rtv07= g_rtv[l_ac].rtv07 / (1 + g_rtu.rtu18/100)        
              LET g_rtv[l_ac].rtv07= g_rtv[l_ac].rtv07t / (1 + g_rtu.rtu18/100)   #MOD-B70154                                           
              LET g_rtv_o.rtv07 = g_rtv[l_ac].rtv07                                                                               
              LET g_errno=''                                                                                                         
              LET l_rtt06 =''                                                                                                        
              SELECT rtt06 INTO l_rtt06 FROM rtt_file                                                                                
               WHERE rtt01=g_rtu.rtu04 AND rtt02=g_rtu.rtu02                                               
                 AND rtt15='Y'    
                 AND rttplant = g_plant AND rtt04 = g_rtv[l_ac].rtv04      #MOD-B70154                                                                                                  
              IF SQLCA.sqlcode=100 THEN 
                 LET l_rtt06=NULL                                                                             
                 LET g_errno='art-111'                                                                        
              ELSE   
              	 IF NOT cl_null(l_rtt06) THEN                   #MOD-B70154                                                                                                                
                    LET g_rtv[l_ac].rtv06=g_rtv[l_ac].rtv07/l_rtt06*100      
                 #MOD-B70154 add begin---------
                 ELSE
                 	  LET l_rtt06=NULL                                                                             
                    LET g_errno='art-111'
                 END IF  
                 #MOD-B70154 add end-----------                                                        
              END IF                                                                                                                 
           END IF     
                               
        AFTER FIELD rtv08                                                                                                           
         IF NOT cl_null(g_rtv[l_ac].rtv08) THEN                                                                                     
            IF g_rtv[l_ac].rtv08<0 THEN                                                                                            
               CALL cl_err('','art-184',1)                                                                                          
               LET g_rtv[l_ac].rtv08=g_rtv_t.rtv08                                                                                  
               DISPLAY BY NAME g_rtv[l_ac].rtv08                                                                                    
               NEXT FIELD rtv08                                                                                                     
            END IF                                                                                                                  
         END IF          
 
        AFTER FIELD rtv09                                                                                                           
         IF NOT cl_null(g_rtv[l_ac].rtv09) THEN                                                                                     
            IF g_rtv[l_ac].rtv09<=0 THEN                                                                                            
               CALL cl_err('','afa-949',1)                                                                                          
               LET g_rtv[l_ac].rtv09=g_rtv_t.rtv09                                                                                  
               DISPLAY BY NAME g_rtv[l_ac].rtv09                                                                                    
               NEXT FIELD rtv09                                                                                                     
            END IF                                                                                                                  
         END IF          
 
        AFTER FIELD rtv10                                                                                                           
         IF NOT cl_null(g_rtv[l_ac].rtv10) THEN                                                                                     
            IF g_rtv[l_ac].rtv10<0 THEN                                                                                             
               CALL cl_err('','art-184',1)                                                                                          
               LET g_rtv[l_ac].rtv10=g_rtv_t.rtv10                                                                                  
               DISPLAY BY NAME g_rtv[l_ac].rtv10                                                                                    
               NEXT FIELD rtv10                                                                                                     
            END IF                                                                                                                  
         END IF               
 
        AFTER FIELD rtv11                                                                                                           
         IF NOT cl_null(g_rtv[l_ac].rtv11) THEN                                                                                     
            IF g_rtv[l_ac].rtv11<=0 THEN                                                                                            
               CALL cl_err('','art-185',1)                                                                                          
               LET g_rtv[l_ac].rtv11=g_rtv_t.rtv11                                                                                  
               DISPLAY BY NAME g_rtv[l_ac].rtv11                                                                                    
               NEXT FIELD rtv11                                                                                                     
            END IF                                                                                                                  
         END IF               
 
        AFTER FIELD rtv12                                                                                                           
         IF NOT cl_null(g_rtv[l_ac].rtv12) THEN                                                                                     
            IF g_rtv[l_ac].rtv12<=0 THEN                                                                                            
               CALL cl_err('','art-183',1)                                                                                          
               LET g_rtv[l_ac].rtv12=g_rtv_t.rtv12                                                                                  
               DISPLAY BY NAME g_rtv[l_ac].rtv12                                                                                    
               NEXT FIELD rtv12                                                                                                     
            END IF                                                                                                                  
         END IF              
 
         AFTER FIELD rtv13                                                                                                         
          IF NOT cl_null(g_rtv[l_ac].rtv13) THEN                                                                                   
            IF g_rtv[l_ac].rtv13<=0 THEN                                                                                            
               CALL cl_err('','axm_109',1)                                                                                          
               LET g_rtv[l_ac].rtv13=g_rtv_t.rtv13                                                                                  
               DISPLAY BY NAME g_rtv[l_ac].rtv13                                                                                    
               NEXT FIELD rtv13                                                                                                     
            END IF                                                                                                                  
         END IF              
 
        BEFORE DELETE                            #是否取消單身
           IF g_rtv_t.rtv03 > 0 AND g_rtv_t.rtv03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtv_file
               WHERE rtv01 = g_rtu.rtu01
                 AND rtv02 = g_rtu.rtu02
                 AND rtv03 = g_rtv_t.rtv03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtv_file",g_rtu.rtu01,g_rtv_t.rtv03,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtv[l_ac].* = g_rtv_t.*
              CLOSE i132_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtv[l_ac].rtv03,-263,1)
              LET g_rtv[l_ac].* = g_rtv_t.*
           ELSE
              UPDATE rtv_file SET rtv03 = g_rtv[l_ac].rtv03,
                                  rtv04 = g_rtv[l_ac].rtv04,
                                  rtv05 = g_rtv[l_ac].rtv05,
                                  rtv06 = g_rtv[l_ac].rtv06,
                                  rtv07 = g_rtv[l_ac].rtv07,
                                  rtv07t= g_rtv[l_ac].rtv07t,
                                  rtv08 = g_rtv[l_ac].rtv08,
                                  rtv09 = g_rtv[l_ac].rtv09,
                                  rtv10 = g_rtv[l_ac].rtv10,   
                                  rtv11 = g_rtv[l_ac].rtv11,
                                  rtv12= g_rtv[l_ac].rtv12,  
                                  rtv13 = g_rtv[l_ac].rtv13,
                                  rtv14 = g_rtv[l_ac].rtv14
               WHERE rtv01=g_rtu.rtu01
                 AND rtv02=g_rtu.rtu02
                 AND rtv03=g_rtv_t.rtv03   
                 AND rtvplant=g_rtu.rtuplant         
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","rtv_file",g_rtu.rtu01,g_rtv_t.rtv03,SQLCA.sqlcode,"","",1) 
                 LET g_rtv[l_ac].* = g_rtv_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtv[l_ac].* = g_rtv_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rtv.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE i132_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE i132_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(rtv03) AND l_ac > 1 THEN
              LET g_rtv[l_ac].* = g_rtv[l_ac-1].*
              NEXT FIELD rtv03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtv04)     #商品代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_rtt04"
                 LET g_qryparam.default1 =g_rtv[l_ac].rtv04 
                 LET g_qryparam.arg1=g_rtu.rtu04
                 LET g_qryparam.arg2=g_rtu.rtu02
                 CALL cl_create_qry() RETURNING g_rtv[l_ac].rtv04
                 DISPLAY BY NAME g_rtv[l_ac].rtv04
                 CALL i132_rtv04('d')
                 CALL i132_rtv14('d')           
                 NEXT FIELD rtv04
              OTHERWISE EXIT CASE
           END CASE
 
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
 
      ON ACTION controls                                   
         CALL cl_set_head_visible("","AUTO") 
    END INPUT
 
    LET g_rtu.rtumodu = g_user
    LET g_rtu.rtudate = g_today
    UPDATE rtu_file SET rtumodu = g_rtu.rtumodu,rtudate = g_rtu.rtudate
     WHERE rtu01 = g_rtu.rtu01 AND rtu02=g_rtu.rtu02
       AND rtuplant=g_rtu.rtuplant
    DISPLAY BY NAME g_rtu.rtumodu,g_rtu.rtudate
 
     #  UPDATE rtu_file SET rtu900 = l_rtu900              #  TQC-AB0337 
     #     WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02 #  TQC-AB0337 
     #  LET g_rtu.rtu900 = l_rtu900   #  TQC-AB0337 
     #  DISPLAY BY NAME g_rtu.rtu900  #  TQC-AB0337 
        IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF    
     #  IF g_rtu.rtu900='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF  #  TQC-AB0337 
        CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"","",g_chr,"")
 
    CLOSE i132_bcl
    COMMIT WORK
 
#   CALL i132_delall()  #CHI-C30002 mark
    CALL i132_delHeader()     #CHI-C30002 add
 
END FUNCTION


 
FUNCTION i132_rtv04(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1
 DEFINE l_imaacti LIKE ima_file.imaacti
 DEFINE l_gfeacti LIKE gfe_file.gfeacti
 LET g_errno=''
 SELECT ima02,ima021,ima1004,ima1005,ima1009,ima1007,ima25,imaacti                                                    
                  INTO g_rtv[l_ac].ima02,g_rtv[l_ac].ima021,g_rtv[l_ac].ima1004,                                            
                       g_rtv[l_ac].ima1005,g_rtv[l_ac].ima1009,g_rtv[l_ac].ima1007,
                       g_rtv[l_ac].rtv05,l_imaacti                                        
               FROM ima_file WHERE ima01=g_rtv[l_ac].rtv04                                                                  
             CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'                                                         
                                            LET g_rtv[l_ac].ima02 = NULL                                                
                                            LET g_rtv[l_ac].ima021= NULL                                                   
                                            LET g_rtv[l_ac].ima1004=NULL                                                 
                                            LET g_rtv[l_ac].ima1005=NULL                                                 
                                            LET g_rtv[l_ac].ima1009=NULL                                                  
                                            LET g_rtv[l_ac].ima1007=NULL
                                            LET g_rtv[l_ac].rtv05=NULL                                                      
                  WHEN l_imaacti='N' LET g_errno = '9028'                                                                  
                  WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'                                                       
                  OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                           
            END CASE 
 IF cl_null(g_errno) THEN
    SELECT gfe02,gfeacti INTO g_rtv[l_ac].rtv05_desc,l_gfeacti FROM gfe_file 
     WHERE gfe01=g_rtv[l_ac].rtv05  
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET g_rtv[l_ac].rtv05_desc=NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'   
         WHEN l_gfeacti MATCHES '[PH]'  LET g_errno = '9038'  
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
    END CASE                             
 END IF             
 IF cl_null(g_errno) OR p_cmd='d' THEN
    DISPLAY BY NAME g_rtv[l_ac].ima02,g_rtv[l_ac].ima021,g_rtv[l_ac].ima1004,
                    g_rtv[l_ac].ima1005,g_rtv[l_ac].ima1009,g_rtv[l_ac].ima1007,
                    g_rtv[l_ac].rtv05,g_rtv[l_ac].rtv05_desc
 END IF
END FUNCTION
 
FUNCTION i132_rtv05(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_gfe02   LIKE gfe_file.gfe02
DEFINE l_gfeacti LIKE gfe_file.gfeacti
 
   LET g_errno=''
   SELECT gfe02,gfeacti INTO g_rtv[l_ac].rtv05_desc,l_gfeacti FROM gfe_file                                                
     WHERE gfe01=g_rtv[l_ac].rtv05                                                                                         
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'                                                              
                                  LET g_rtv[l_ac].rtv05_desc=NULL                                                       
        WHEN l_gfeacti='N' LET g_errno = '9028'                                                                        
        WHEN l_gfeacti MATCHES '[PH]'  LET g_errno = '9038'                                                             
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                  
   END CASE                                                                                                             
  IF cl_null(g_errno) OR p_cmd='d' THEN                                                                                 
     DISPLAY BY NAME  g_rtv[l_ac].rtv05_desc                                                          
  END IF  
END FUNCTION 
                                       
FUNCTION i132_rtv14(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_rtt14 LIKE rtt_file.rtt14
DEFINE l_gfe02 LIKE gfe_file.gfe02
 
   SELECT rtt14 INTO l_rtt14 FROM rtt_file 
     WHERE rtt01=g_rtu.rtu04 AND rtt02=g_rtu.rtu02 
       AND rtt04=g_rtv[l_ac].rtv04
   IF SQLCA.sqlcode=100 THEN LET l_rtt14=NULL END IF
   SELECT gfe02 INTO l_gfe02 FROM gfe_file
     WHERE gfe01=l_rtt14 AND gfeacti='Y'  
   IF SQLCA.sqlcode=100 THEN LET l_gfe02=NULL END IF
   IF p_cmd='d' THEN
      LET g_rtv[l_ac].rtv14=l_rtt14
      LET g_rtv[l_ac].rtv14_desc =l_gfe02
      DISPLAY BY NAME g_rtv[l_ac].rtv14
      DISPLAY BY NAME g_rtv[l_ac].rtv14_desc
   END IF
 
END FUNCTION 
 

#CHI-C30002 -------- add -------- begin
FUNCTION i132_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rtu.rtu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rtu_file ",
                  "  WHERE rtu01 LIKE '",l_slip,"%' ",
                  "    AND rtu01 > '",g_rtu.rtu01,"'"
      PREPARE i132_pb1 FROM l_sql 
      EXECUTE i132_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL i132_feizhi()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rtu_file WHERE rtu01 = g_rtu.rtu01
                                AND rtu02=g_rtu.rtu02
                                AND rtuplant=g_rtu.rtuplant
         INITIALIZE g_rtu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i132_delall()
#
#   LET g_cnt= 0
#   SELECT COUNT(*) INTO g_cnt FROM rtv_file
#    WHERE rtv01 = g_rtu.rtu01 AND rtv02=g_rtu.rtu02  
#      AND rtvplant = g_rtu.rtuplant
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM rtu_file WHERE rtu01 = g_rtu.rtu01
#                             AND rtu02=g_rtu.rtu02   
#                             AND rtuplant=g_rtu.rtuplant
#      INITIALIZE g_rtu.* TO NULL   #TQC-B50152
#      CLEAR FORM                   #TQC-B50152
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
#FUNCTION i132_b_askkey()
#DEFINE
#    l_wc2           LIKE type_file.chr1000 
#
#    CONSTRUCT l_wc2 ON rtv03,rtv04,rtv05,rtv14,
#                       rtv06,rtv07,rtv07t,rtv08,rtv09,rtv10,rtv11,rtv12,rtv13      
#            FROM s_rtv[1].rtv03,s_rtv[1].rtv04,s_rtv[1].rtv05,s_rtv[1].rtv14,
#                 s_rtv[1].rtv06,
#                 s_rtv[1].rtv07,s_rtv[1].rtv07t,s_rtv[1].rtv08,s_rtv[1].rtv09,
#                 s_rtv[1].rtv10,s_rtv[1].rtv11,
#                 s_rtv[1].rtv12,s_rtv[1].rtv13
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
# 
#      ON ACTION controlg      
#         CALL cl_cmdask()     
# 
#
# 
#                 ON ACTION qbe_select
#         	   CALL cl_qbe_select()
#                 ON ACTION qbe_save
#		   CALL cl_qbe_save()
#
#    END CONSTRUCT
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       RETURN
#    END IF
#    #LET l_wc2 = l_wc2 CLIPPED, " AND rtuplant = '",g_plant,"'"  
#    CALL i132_b_fill(l_wc2)
#
#END FUNCTION
 
FUNCTION i132_b_fill(p_wc2)              #BODY FILL UP
DEFINE  p_wc2 LIKE type_file.chr1000 
DEFINE  l_gfeacti LIKE gfe_file.gfeacti
DEFINE  l_imaacti LIKE ima_file.imaacti
    IF p_wc2 IS NULL THEN LET p_wc2='1=1' END IF
 
    LET g_sql = "SELECT rtv03,rtv04,'','','','','','',rtv05,'',rtv14,'',rtv06,rtv07,",
                "       rtv07t,rtv08,rtv09,rtv10,rtv11,rtv12,rtv13 ",  
                " FROM rtv_file ", 
                " WHERE rtv01 ='",g_rtu.rtu01,"' AND ",  #單頭
                "       rtv02 ='",g_rtu.rtu02,"' AND ",
                "       rtvplant='",g_rtu.rtuplant,"' AND ",
                p_wc2 CLIPPED,                           #單身
                " ORDER BY rtv03"
    PREPARE i132_pb FROM g_sql
    DECLARE rtv_cs                       #CURSOR
        CURSOR FOR i132_pb
 
    CALL g_rtv.clear()
    LET g_cnt = 1
    FOREACH rtv_cs INTO g_rtv[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_errno = ' '
        SELECT ima02,ima021,ima1004,ima1005,ima1009,ima1007,ima25,imaacti 
         INTO g_rtv[g_cnt].ima02,g_rtv[g_cnt].ima021,g_rtv[g_cnt].ima1004,
              g_rtv[g_cnt].ima1005,g_rtv[g_cnt].ima1009,g_rtv[g_cnt].ima1007,
              g_rtv[g_cnt].rtv05,l_imaacti
          FROM ima_file WHERE ima01=g_rtv[g_cnt].rtv04
        IF SQLCA.SQLCODE = 100 THEN
           LET g_rtv[g_cnt].ima02 = NULL
           LET g_rtv[g_cnt].ima021= NULL
           LET g_rtv[g_cnt].ima1004= NULL
           LET g_rtv[g_cnt].ima1005= NULL
           LET g_rtv[g_cnt].ima1009= NULL
           LET g_rtv[g_cnt].ima1007= NULL
           LET g_rtv[g_cnt].rtv05=NULL
        END IF                          
        SELECT gfe02,gfeacti INTO g_rtv[g_cnt].rtv05_desc,l_gfeacti FROM gfe_file                                        
          WHERE gfe01=g_rtv[g_cnt].rtv05                                                                                   
        IF SQLCA.SQLCODE = 100  THEN       
           LET g_rtv[g_cnt].rtv05_desc=NULL
        END IF                                                      
        SELECT gfe02 INTO g_rtv[g_cnt].rtv14_desc FROM gfe_file
         WHERE gfe01=g_rtv[g_cnt].rtv14 AND gfeacti='Y'
        IF SQLCA.sqlcode=100 THEN
           LET g_rtv[g_cnt].rtv14_desc=NULL
        END IF 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rtv.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i132_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtv TO s_rtv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i132_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY             
 
      ON ACTION previous
         CALL i132_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION jump
         CALL i132_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY             
 
      ON ACTION next
         CALL i132_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY             
 
      ON ACTION last
         CALL i132_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY              
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    
         IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
       # IF g_rtu.rtu900='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF  #  TQC-AB0337 
         CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"","",g_chr,"")    
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
#@    ON ACTION 送簽
#      ON ACTION easyflow_approval     
#         LET g_action_choice="easyflow_approval"
#         EXIT DISPLAY
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 廢止
      ON ACTION feizhi 
         LET g_action_choice="feizhi"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
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
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #@ON ACTION 簽核狀況
#       ON ACTION approval_status  
#         LET g_action_choice="approval_status"
#         EXIT DISPLAY
#
#      ON ACTION agree
#         LET g_action_choice = 'agree'
#         EXIT DISPLAY
#
#      ON ACTION deny
#         LET g_action_choice = 'deny'
#         EXIT DISPLAY
#
#      ON ACTION modify_flow
#         LET g_action_choice = 'modify_flow'
#         EXIT DISPLAY
#
#      ON ACTION withdraw
#         LET g_action_choice = 'withdraw'
#         EXIT DISPLAY
#
#      ON ACTION org_withdraw
#         LET g_action_choice = 'org_withdraw'
#         EXIT DISPLAY
#
#      ON ACTION phrase
#         LET g_action_choice = 'phrase'
#         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document        
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i132_copy()
DEFINE
    l_newno         LIKE rtu_file.rtu01,
    l_oldno         LIKE rtu_file.rtu01,
    li_result       LIKE type_file.num5 
#DEFINE g_t1 LIKE type_file.chr3               #FUN-AA0046  mark
DEFINE g_t1 LIKE type_file.chr3               #FUN-AA0046
    
    IF s_shut(0) THEN RETURN END IF
    IF g_rtu.rtu01 IS NULL  OR g_rtu.rtu02 IS NULL OR g_rtu.rtuplant IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
   
    #只可對簽定機構為當前機構的采購協議進行促銷協議維護                                                                
  #  LET l_cnt=0                                                                                                             
  #  SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                               
  #    WHERE rts01=g_rtu.rtu04                                                                                           
  #    AND rtsconf='Y'      AND rts02=g_plant                                                                     
  #  IF l_cnt=0 THEN                                                                                                     
  #     CALL cl_err('','art-110',1)                                                                                    
  #     RETURN                                                                                                          
  #  END IF            
  # 
     LET l_newno   = NULL              
     LET g_before_input_done = FALSE   
     CALL i132_set_entry('a')         
     LET g_before_input_done = TRUE 
 
     CALL cl_set_head_visible("","YES")     
     INPUT l_newno FROM rtu01 
 
        BEFORE INPUT
            CALL cl_set_docno_format("rtu01") 
            CALL cl_set_comp_entry("rtu01,rtu04",TRUE)    
        AFTER FIELD rtu01
           IF cl_null(l_newno) THEN
              NEXT FIELD rtu01
           ELSE
#             CALL s_check_no('axm',l_newno,'','A5','rtu_file','rtu01,rtu02,rtuplant','')  #FUN-A70130 mark
              CALL s_check_no('art',l_newno,'','A5','rtu_file','rtu01,rtu02,rtuplant','')  #FUN-A70130 mod
                   RETURNING li_result,l_newno
              IF (NOT li_result) THEN
                 NEXT FIELD rtu01
              ELSE
                 BEGIN WORK
#                CALL s_auto_assign_no('axm',l_newno,g_today,'A5','rtu_file','rtu01,rtu02,rtuplant','','','') #FUN-A70130 mark
                 CALL s_auto_assign_no('art',l_newno,g_today,'A5','rtu_file','rtu01,rtu02,rtuplant','','','') #FUN-A70130 mod
                      RETURNING li_result,l_newno
                 IF (NOT li_result) THEN
                    ROLLBACK WORK 
                    NEXT FIELD rtu01
                 ELSE
                    COMMIT WORK           
                 END IF 
              END IF
           END IF 
           DISPLAY l_newno TO rtu01
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtu01)
               LET g_t1=s_get_doc_no(l_newno)
               CALL q_oay(false,false,g_t1,'A5','art')                  #FUN-A70130       
                  RETURNING g_t1
               LET l_newno=g_t1
               DISPLAY l_newno TO rtu01
               NEXT FIELD rtu01
         END CASE
       
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       ROLLBACK WORK       
       DISPLAY BY NAME g_rtu.rtu01
       RETURN
    END IF
 
    #單頭
    DROP TABLE y
    SELECT * FROM rtu_file
     WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02
       AND rtuplant=g_rtu.rtuplant
      INTO TEMP y
 
    #==>單頭複製
    UPDATE y SET rtu01=l_newno,        #新的鍵值
                 rtuuser=g_user,       #資料所有者
                 rtugrup=g_grup,       #資料所有者所屬群
                 rtumodu=NULL,         #資料修改日期
                 rtudate=NULL,        #資料建立日期
                 rtucrat=g_today,
                 rtuacti='Y',          #有效資料
                 rtuconf='N',          #確認
                 rtu02=g_plant,
                 rtuoriu=g_user,     #TQC-A30028 ADD
                 rtuorig=g_grup,     #TQC-A30028 ADD
                 rtuplant=g_plant,
                 rtu11=NULL,
                 rtucond=NULL,
                 rtuconu=NULL
 
    INSERT INTO rtu_file SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rtu_file","","",SQLCA.sqlcode,"","",1) 
        LET g_success = 'N'
        ROLLBACK WORK
        RETURN
    END IF
    
    #單身                                                                                                                          
    DROP TABLE x                                                                                                                    
    SELECT * FROM rtv_file                                                                                                          
     WHERE rtv01=g_rtu.rtu01 AND rtv02=g_rtu.rtu02            
       AND rtvplant=g_rtu.rtuplant                                             
      INTO TEMP x      
    #==>單身複製
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)
       RETURN
    END IF
    UPDATE x SET rtv01=l_newno
    INSERT INTO rtv_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","rtv_file","","",SQLCA.sqlcode,"","INSERT INTO rtv_file",1)  
       ROLLBACK WORK
       RETURN
    ELSE
       COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]                                                                                                   
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'     
    LET l_oldno = g_rtu.rtu01
    SELECT rtu_file.* INTO g_rtu.* FROM rtu_file 
      WHERE rtu01 = l_newno AND rtu02=g_plant
                                                                       
    CALL i132_u()
    CALL i132_b()
 
    #SELECT rtu_file.* INTO g_rtu.* FROM rtu_file #FUN-C80046
    # WHERE rtu01 = l_oldno AND rtu02=g_plant     #FUN-C80046
 
    #CALL i132_show()  #FUN-C80046
 
END FUNCTION
 
#FUNCTION i132_z()
#   DEFINE  l_rtv           RECORD LIKE rtv_file.*
#
#   IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL OR g_rtu.rtuplant IS NULL THEN RETURN END IF
#    SELECT * INTO g_rtu.* FROM rtu_file
#     WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant
#   IF g_rtu.rtuconf='X' THEN CALL cl_err(g_rtu.rtuconf,'9024',0) RETURN END IF
#   IF g_rtu.rtuconf='N' THEN RETURN END IF
#   IF g_rtu.rtu900 = 'S' THEN
#      CALL cl_err(g_rtu.rtu900,'apm-030',1)
#      RETURN
#   END IF
#
#   IF NOT cl_confirm('axm-109') THEN RETURN END IF
#   BEGIN WORK
#
#   OPEN i132_cl USING g_rtu_rowid
#   #--Add exception check during OPEN CURSOR
#   IF STATUS THEN
#      CALL cl_err("OPEN i132_cl:", STATUS, 1)
#      CLOSE i132_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH i132_cl INTO g_rtu.*               # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   LET g_success = 'Y'
#   LET g_rtu.rtu900 = '0'
# 
#    UPDATE rtu_file SET rtuconf='N',
#                       rtu900 = g_rtu.rtu900
#                WHERE rtu01=g_rtu.rtu01
#                 AND  rtu02=g_rtu.rtu02
#                 AND  rtuplant=g_rtu.rtuplant     
# 
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#      CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"","art-215","","upd rtu_file",1)
#      LET g_success='N'
#   END IF
# 
#   IF g_rtu.rtumksg = 'N' AND g_rtu.rtu900 = '1' THEN
#      LET g_rtu.rtu900 = '0'
#      UPDATE rtu_file SET rtu900 = g_rtu.rtu900 WHERE rtu01 = g_rtu.rtu01
#                   AND rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"","art-215","","upd rtu_file",1)  
#         LET g_success = 'N'
#      END IF
#   END IF
#
#   IF g_success = 'Y' THEN
#      LET g_rtu.rtuconf='N'
#      COMMIT WORK
#      DISPLAY BY NAME g_rtu.rtuconf
#      DISPLAY BY NAME g_rtu.rtu900
#   ELSE
#      LET g_rtu.rtuconf='Y'
#      DISPLAY BY NAME g_rtu.rtuconf
#      DISPLAY BY NAME g_rtu.rtu900
#      ROLLBACK WORK
#   END IF
#    IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
#   IF g_rtu.rtu900='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#    CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"","",g_chr,"")         
#END FUNCTION
 
FUNCTION i132_x()                                                                                                           
                                                                                                                            
   IF s_shut(0) THEN                                                                                                       
      RETURN                                                                                                             
   END IF                                                                                                                 
                                                                                                                        
   IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL OR g_rtu.rtuplant IS NULL THEN                                         
      CALL cl_err("",-400,0)                                                                                                
      RETURN                                                                                                           
   END IF                                                                                                               
             
   IF g_rtu.rtuconf='Y' THEN CALL cl_err('','art-468',0) RETURN END IF
 
   IF g_rtu.rtuconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
 
   #只可對簽定機構為當前機構的采購協議進行促銷協議維護                                                                      
    LET l_cnt=0                                                                                                        
    SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                               
      WHERE rts01=g_rtu.rtu04                                                                                            
      AND rtsconf='Y'      AND rts02=g_plant                                                                      
    IF l_cnt=0 THEN                                                                                                     
       CALL cl_err('','art-110',1)                                                                                         
       RETURN                                                                                                             
    END IF                                                                                                             
   BEGIN WORK                                                                                                               
                                                                                                                        
   OPEN i132_cl USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant                                                                                       
   IF STATUS THEN                                                                                                          
      CALL cl_err("OPEN i132_cl:", STATUS, 1)                                                                              
      CLOSE i132_cl                                                                                                     
      ROLLBACK WORK                                                                                                     
      RETURN                                                                                                               
   END IF                                                                                                              
                                                                                                                     
   FETCH i132_cl INTO g_rtu.*               # 鎖住將被更改或取消的資料                                                  
   IF SQLCA.sqlcode THEN                                                                                              
      CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)          #資料被他人LOCK                                                 
       ROLLBACK WORK                                                                                                  
      RETURN                                                                                                          
   END IF                                                                                                             
                                                                                                                            
   LET g_success = 'Y'                                                                                                      
                                                                                                                           
   CALL i132_show()                                                                                                       
                                                                                                                       
   IF cl_exp(0,0,g_rtu.rtuacti) THEN                   #確認一下                                                     
      LET g_chr=g_rtu.rtuacti                                                                                     
      IF g_rtu.rtuacti='Y' THEN                                                                                         
         LET g_rtu.rtuacti='N'                                                                                           
      ELSE                                                                                                                  
         LET g_rtu.rtuacti='Y'                                                                                            
      END IF                                                                                                           
                                                                                                                      
      UPDATE rtu_file SET rtuacti=g_rtu.rtuacti,                                                                     
                          rtumodu=g_user,                                                                             
                          rtudate=g_today                                                                               
       WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02         
         AND rtuplant=g_rtu.rtuplant                                 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                       
         CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","",1)                                   
         LET g_rtu.rtuacti=g_chr      
       END IF                                                                                                               
   END IF                                                                                                                 
                                                                                                                      
   CLOSE i132_cl                                                                                                           
                                                                                                                        
   IF g_success = 'Y' THEN                                                                                             
      COMMIT WORK                                                                                                       
      CALL cl_flow_notify(g_rtu.rtu01,'V')                                                                      
   ELSE                                                                                                                   
      ROLLBACK WORK                                                                                                       
   END IF                                                                                                                 
                                                                                                                      
   SELECT rtuacti,rtumodu,rtudate                                                                                          
     INTO g_rtu.rtuacti,g_rtu.rtumodu,g_rtu.rtudate FROM rtu_file                                                          
    WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02        
      AND rtuplant=g_rtu.rtuplant                                     
   DISPLAY BY NAME g_rtu.rtuacti,g_rtu.rtumodu,g_rtu.rtudate                                                              
                                                                                                                       
END FUNCTION                                            
                                                
FUNCTION i132_feizhi()
   DEFINE  l_rtv           RECORD LIKE rtv_file.*
   IF g_rtu.rtu01 IS NULL OR g_rtu.rtu02 IS NULL OR g_rtu.rtuplant IS NULL THEN RETURN END IF
   SELECT * INTO g_rtu.* FROM rtu_file
    WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02
      AND rtuplant=g_rtu.rtuplant
   #尚未審核，不能廢止！
   IF g_rtu.rtuconf!='Y' THEN CALL cl_err('','art-081',1) RETURN END IF  
 
   #只可對簽定機構為當前機構的采購協議進行促銷協議維護 
    LET l_cnt=0                                                                                           
    SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                         
      WHERE rts01=g_rtu.rtu04                                                                                          
      AND rtsconf='Y'      AND rts02=g_plant                                                                    
    IF l_cnt=0 THEN                                                                                                     
       CALL cl_err('','art-110',1)                                                                                      
       RETURN                                                                                                             
    END IF                                                                                                                  
   BEGIN WORK
   LET g_success = 'Y'
#  IF g_rtu.rtu900 matches '[Ss1]' THEN #  TQC-AB0337          
#        CALL cl_err("","mfg3557",0)  #  TQC-AB0337 
#        LET g_success='N'           #  TQC-AB0337 
#        RETURN                      #  TQC-AB0337     
#  END IF                            #  TQC-AB0337 
   OPEN i132_cl USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant
   IF STATUS THEN
      CALL cl_err("OPEN i132_cl:", STATUS, 1)
      CLOSE i132_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i132_cl INTO g_rtu.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_rtu.rtuconf) THEN
      LET g_rtu.rtuconf='X'
      #LET g_rtu.rtu900='9'
      UPDATE rtu_file SET
             rtuconf=g_rtu.rtuconf,
             rtumodu=g_user,
             rtudate=g_today,
             #rtu900 =g_rtu.rtu900,
             rtu11  =g_today  
       WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02
         AND rtuplant=g_rtu.rtuplant
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"","art-215","","upd rtu_file",1)
         LET g_success='N'
      END IF
   END IF
   CALL i132_transfer1() 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rtu.rtu01,'V')
      DISPLAY BY NAME g_rtu.rtuconf
#     DISPLAY BY NAME g_rtu.rtu900    #  TQC-AB0337 
   ELSE
      LET g_rtu.rtuconf= g_rtu_t.rtuconf
 #    LET g_rtu.rtu900 = g_rtu_t.rtu900   #  TQC-AB0337 
      DISPLAY BY NAME g_rtu.rtuconf
 #    DISPLAY BY NAME g_rtu.rtu900         #  TQC-AB0337 
      ROLLBACK WORK
   END IF
 
   SELECT rtuconf,rtumodu,rtudate,rtu11
     INTO g_rtu.rtuconf,g_rtu.rtumodu,g_rtu.rtudate,g_rtu.rtu11 FROM rtu_file
    WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02
      AND rtuplant=g_rtu.rtuplant 
    DISPLAY BY NAME g_rtu.rtuconf,g_rtu.rtumodu,g_rtu.rtudate,g_rtu.rtu11
    IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF 
  # IF g_rtu.rtu900='1'  THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF   #  TQC-AB0337 
    CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"","",g_chr,"") 
END FUNCTION
 
 
#FUNCTION i132_ef()
#
#   CALL aws_condition()                            #判斷送簽資料
#   IF g_success = 'N' THEN
#         RETURN
#   END IF
#
##########
# CALL aws_efcli()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
#   IF aws_efcli2(base.TypeInfo.create(g_rtu),base.TypeInfo.create(g_rtv),'','','','')
#   THEN
#      LET g_success = 'Y'
#      LET g_rtu.rtu06 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
#      DISPLAY BY NAME g_rtu.rtu06
#   ELSE
#      LET g_success = 'N'
#   END IF
#
#END FUNCTION
 
FUNCTION i132_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rtu01,rtu02,rtu04",TRUE)
    END IF
    IF NOT cl_null(g_rtu.rtu07) THEN 
       CALL cl_set_comp_entry("rtu08",TRUE)
    END IF 
END FUNCTION
 
FUNCTION i132_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
  DEFINE l_n     LIKE type_file.num5 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rtu01,rtu02,rtu04",FALSE)
    END IF
    IF cl_null(g_rtu.rtu07) THEN                                                                                                
       CALL cl_set_comp_entry("rtu08",FALSE)                                                                                        
    END IF    
END FUNCTION
 
FUNCTION i132_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
  IF g_gec07='Y' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("rtv07t",TRUE)                                                                     
  END IF                            
  
  IF g_gec07='N' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("rtv07",TRUE)                                                                                          
  END IF                              
 
END FUNCTION
 
FUNCTION i132_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
  IF g_gec07='Y' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("rtv07",FALSE)                                                                                    
  END IF                                  
  
  IF g_gec07='N' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("rtv07t",FALSE)                                                                                       
  END IF   
        
END FUNCTION
 
FUNCTION i132_y_chk()
DEFINE l_cnt       LIKE type_file.num5    
DEFINE l_rtu09     LIKE rtu_file.rtu09
DEFINE l_rtu10     LIKE rtu_file.rtu10
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 ------------ add ------------- begin
   IF cl_null(g_rtu.rtu01) OR cl_null(g_rtu.rtu02) OR cl_null(g_rtu.rtuplant) THEN
      CALL cl_err('',-400,0)
      LET g_success='N'
      RETURN
   END IF

   IF g_rtu.rtuconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_rtu.rtuconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_rtu.rtuacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm" THEN       #按「確認」時
      IF NOT cl_confirm('axm-108') THEN LET g_success='N' RETURN END IF
   END IF
#CHI-C30107 ------------ add ------------- end
   SELECT * INTO g_rtu.* FROM rtu_file WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02
                                         AND rtuplant=g_rtu.rtuplant
   IF cl_null(g_rtu.rtu01) OR cl_null(g_rtu.rtu02) OR cl_null(g_rtu.rtuplant) THEN
      CALL cl_err('',-400,0)
      LET g_success='N' 
      RETURN 
   END IF
 
   IF g_rtu.rtuconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_rtu.rtuconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_rtu.rtuacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
   
   #只可對簽定機構為當前機構的采購協議進行促銷協議維護                                                                  
    LET l_cnt=0                                                                                                         
    SELECT COUNT(*) INTO l_cnt FROM rts_file                                                                          
      WHERE rts01=g_rtu.rtu04                                                                                          
      AND rtsconf='Y'      AND rts02=g_plant                                                                     
    IF l_cnt=0 THEN                                                                                                  
       CALL cl_err('','art-110',1)                                                                                   
       RETURN                                                                                                        
    END IF                     
 
   #控管單身未輸入資料
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rtv_file
    WHERE rtv01=g_rtu.rtu01 AND rtv02=g_rtu.rtu02  
      AND rtvplant=g_rtu.rtuplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF
   
   #一份采購協議同一時間只可有一份促銷協議                                                                                 
   LET l_cnt=0                                                                                                             
   SELECT COUNT(*) INTO l_cnt FROM rtu_file                                                                                
    WHERE rtu04=g_rtu.rtu04 AND rtu02=g_rtu.rtu02                                                                          
      AND rtuplant=g_rtu.rtuplant AND rtuconf='Y'                                                                              
   IF l_cnt <>0 THEN                                                                                                       
      LET g_sql = "SELECT rtu09,rtu10 FROM rtu_file WHERE rtu02=? ",                                       
                  "   AND rtu04=? AND rtuplant=? ",                                         
                  "   AND rtuconf='Y' "                                                                                    
      DECLARE i132_cur2 CURSOR FROM g_sql
      OPEN i132_cur2 USING g_rtu.rtu02,g_rtu.rtu04,g_rtu.rtuplant                                                             
      FETCH i132_cur2 INTO l_rtu09,l_rtu10                                                                               
      IF g_rtu.rtu10>=l_rtu09 AND g_rtu.rtu10<=l_rtu10 THEN                                                             
         CALL cl_err('','art-109',1)
         CLOSE i132_cur2                                                                                   
         LET g_success='N'
         RETURN
      END IF                                                                                                            
   END IF   
                   
END FUNCTION
 
FUNCTION i132_y_upd()
   DEFINE  l_cnt           LIKE type_file.num5 
 
   LET g_success = 'Y'
#CHI-C30107 -------------- mark --------------- begin
#  IF g_action_choice CLIPPED = "confirm" THEN       #按「確認」時
#     #IF g_rtu.rtumksg='Y' THEN
#     #   IF g_rtu.rtu900 != '1' THEN
#     #      CALL cl_err('','aws-078',1)
#     #      LET g_success = 'N'
#     #      RETURN
#     #    END IF
#     #END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF
#  END IF
#CHI-C30107 -------------- mark --------------- end
   DROP TABLE rtu_temp
   DROP TABLE rtv_temp
   SELECT * FROM rtu_file WHERE 1=0 INTO TEMP rtu_temp
   SELECT * FROM rtv_file WHERE 1=0 INTO TEMP rtv_temp
   BEGIN WORK
 
   OPEN i132_cl USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i132_cl:", STATUS, 1)
      CLOSE i132_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i132_cl INTO g_rtu.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(g_rtu.rtu01,SQLCA.sqlcode,0)
      CLOSE i132_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE rtu_file SET rtuconf='Y',rtuconu=g_user,rtucond=g_today 
    WHERE rtu01=g_rtu.rtu01 AND rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant  
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"","art-215","","upd rtu_file",1)
      LET g_success='N'
   END IF
#  IF g_rtu.rtumksg = 'N' AND g_rtu.rtu900 = '0' THEN   #  TQC-AB0337 
#     #LET g_rtu.rtu900 = '1'                      #  TQC-AB0337 
#     UPDATE rtu_file SET rtu900 = g_rtu.rtu900   #  TQC-AB0337 
#      WHERE rtu01 = g_rtu.rtu01 AND rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant   #  TQC-AB0337 
#     IF SQLCA.sqlcode THEN                                                           #  TQC-AB0337 
#        CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"","art-215","","upd rtu_file",1) #  TQC-AB0337 
#        LET g_success = 'N'          #  TQC-AB0337 
#     END IF                          #  TQC-AB0337 
#  END IF                             #  TQC-AB0337 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO g_cnt FROM rtv_file
       WHERE rtv01 = g_rtu.rtu01 AND rtv02=g_rtu.rtu02 AND rtvplant=g_rtu.rtuplant  
      IF g_cnt = 0 AND g_rtu.rtumksg = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
   END IF
 
#   IF g_success = 'Y' THEN
#      IF g_rtu.rtumksg = 'Y' THEN
#         CASE aws_efapp_formapproval()
#            WHEN 0  #呼叫 EasyFlow 簽核失敗
#               LET g_rtu.rtuconf="N"
#               LET g_success = "N"
#               ROLLBACK WORK
#               RETURN
#            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
#               LET g_rtu.rtuconf="N"
#               ROLLBACK WORK
#               RETURN
#         END CASE
#      END IF
 
      CALL i132_transfer() #拋轉     
      IF g_success='Y' THEN
        #LET g_rtu.rtu900='1'
         LET g_rtu.rtuconf='Y'
         LET g_rtu.rtuconu=g_user
         LET g_rtu.rtucond=g_today
         COMMIT WORK
         CALL cl_flow_notify(g_rtu.rtu01,'Y')
  #      DISPLAY BY NAME g_rtu.rtu900     #  TQC-AB0337 
         DISPLAY BY NAME g_rtu.rtuconf
         DISPLAY BY NAME g_rtu.rtuconu
         DISPLAY BY NAME g_rtu.rtucond
      ELSE
         LET g_rtu.rtuconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
#
#   ELSE
#      LET g_rtu.rtuconf='N'
#      LET g_success = 'N'
#      ROLLBACK WORK
#   END IF
 
   #CKP
   SELECT * INTO g_rtu.* FROM rtu_file 
      WHERE rtu01 = g_rtu.rtu01 AND  rtu02=g_rtu.rtu02 AND rtuplant=g_rtu.rtuplant 
   IF g_rtu.rtuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
 # IF g_rtu.rtu900='1' OR                                               #  TQC-AB0337    
 #    g_rtu.rtu900='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF   #  TQC-AB0337 
 # IF g_rtu.rtu900='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF   #  TQC-AB0337 
   CALL cl_set_field_pic(g_rtu.rtuconf,g_chr2,"",g_chr3,g_chr,g_rtu.rtuacti)
   CALL i132_rtuconu('d') 
END FUNCTION
 
FUNCTION i132_transfer()
DEFINE l_rts04  LIKE rts_file.rts04
DEFINE l_rtp05  LIKE rtp_file.rtp05
DEFINE l_azp03  LIKE azp_file.azp03   
DEFINE ll_azp03 LIKE azp_file.azp03   
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_legal  LIKE rts_file.rtslegal
 
   SELECT azp03 INTO ll_azp03 FROM azp_file
    WHERE azp01=g_rtu.rtuplant
   IF SQLCA.sqlcode THEN
      CALL cl_err('','art-116',1)
      LET g_success='N' 
      ROLLBACK WORK
      RETURN
   END IF
 
   #在采購協議中尋找合同編號
   SELECT rts04 INTO l_rts04 FROM rts_file WHERE rts01=g_rtu.rtu04 
    AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant AND rtsconf='Y'
    AND rts03= (SELECT MAX(rts03) FROM rts_file WHERE rts01=g_rtu.rtu04
                AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant)             #TQC-AC0106
   IF SQLCA.sqlcode=100 THEN 
      CALL cl_err('','art-112',1) 
      LET g_success='N'
      ROLLBACK WORK 
      RETURN 
   END IF
   #在采購合同中尋找生效機構
   DECLARE i132_trans_cs1 CURSOR FOR SELECT rtp05  FROM rtp_file,rto_file WHERE rtp01=rto01 
    AND rtp02=rto02 AND rtp03=rto03 AND rtpplant=rtoplant AND rtoconf='Y' 
    AND rtp01=l_rts04 AND rtp03=g_rtu.rtu02 AND rtpplant=g_rtu.rtuplant 
   FOREACH i132_trans_cs1 INTO l_rtp05
      IF SQLCA.sqlcode THEN
         CALL cl_err('','art-113',1)
         LET g_success='N'
         EXIT FOREACH
         ROLLBACK WORK
         RETURN
      END IF
 
     #根據生效機構尋找數據庫
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_rtp05                                                 
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err('','art-114',1)                                                                                                
         LET g_success='N'                                                                                                          
         EXIT FOREACH                                                                                                               
         ROLLBACK WORK                                                                                                              
         RETURN                                                                                                                     
      END IF          
      SELECT azw02 INTO l_legal FROM azw_file WHERE azw01=l_rtp05      
     IF l_rtp05=g_rtu.rtuplant THEN
         IF l_azp03<>ll_azp03 THEN
            LET l_cnt=0
           #LET g_sql = "SELECT COUNT(*) FROM ",s_dbstring(l_azp03 CLIPPED),"rtu_file",         #FUN-A50102 mark
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtp05,'rtu_file'),        #FUN-A50102  
                        " WHERE rtu01=? AND rtu02 =? AND rtuplant=?  "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102 
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql   #FUN-A50102
            PREPARE selec_prep FROM g_sql
            EXECUTE selec_prep INTO l_cnt USING g_rtu.rtu01,g_rtu.rtu02,l_rtp05
            IF l_cnt<> 0 THEN
               CALL cl_err('','art-117',1)
               EXIT FOREACH
               ROLLBACK WORK
               RETURN
            ELSE
              #LET g_sql="INSERT INTO ",s_dbstring(l_azp03 CLIPPED),"rtu_file",         #FUN-A50102 mark
               LET g_sql="INSERT INTO ",cl_get_target_table(l_rtp05,'rtu_file'),        #FUN-A50102                                                   
                   " SELECT * FROM rtu_file WHERE rtu01=? ",                                                               
                   " AND rtu02=? AND rtuplant=? "                                                                           
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql  #FUN-A50102
               PREPARE inser_prep FROM g_sql                                                                                
               EXECUTE inser_prep USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant                                              
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                             
                  CALL cl_err3("ins","rtu_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","rtu",1)                                   
                  EXIT FOREACH                                                                                        
                  ROLLBACK WORK                                                                                      
                  RETURN                                                                                              
               END IF 
              #LET g_sql="INSERT INTO ",s_dbstring(l_azp03 CLIPPED),"rtv_file",   #FUN-A50102 mark
               LET g_sql="INSERT INTO ",cl_get_target_table(l_rtp05,'rtv_file'),  #FUN-A50102                                                     
                   " SELECT * FROM rtv_file WHERE rtv01=? ",                                                                
                   " AND rtv02=? AND rtvplant=? "                                                                          
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql     #FUN-A50102 
               PREPARE inse_prep FROM g_sql                                                                              
               EXECUTE inse_prep USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant                                                
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                              
                  CALL cl_err3("ins","rtv_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","rtv",1)                                   
                  EXIT FOREACH                                                                                             
                  ROLLBACK WORK                                                                                          
                  RETURN                                                                                                
               END IF                               
            END IF
         END IF
      ELSE
         LET l_cnt=0
        #LET g_sql="SELECT COUNT(*) FROM ",s_dbstring(l_azp03 CLIPPED),"rtu_file",     #FUN-A50102 mark
         LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_rtp05,'rtu_file'),    #FUN-A50102 
                   " WHERE rtu01=? AND rtu02=? ",
                   "   AND rtuplant=? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql    #FUN-A50102
         PREPARE i132_pre1 FROM g_sql
         EXECUTE i132_pre1 INTO l_cnt USING g_rtu.rtu01,g_rtu.rtu02,l_rtp05
         IF l_cnt=0 THEN
            DELETE FROM rtu_temp
            INSERT INTO rtu_temp SELECT * FROM rtu_file 
                                  WHERE rtu01 = g_rtu.rtu01 AND rtu02=g_rtu.rtu02 
                                    AND rtuplant=g_rtu.rtuplant
            UPDATE rtu_temp SET rtuplant=l_rtp05,
                                rtulegal=l_legal
           #LET g_sql ="INSERT INTO ",s_dbstring(l_azp03 CLIPPED),"rtu_file",     #FUN-A50102 mark
            LET g_sql ="INSERT INTO ",cl_get_target_table(l_rtp05,'rtu_file'),    #FUN-A50102 
                       " SELECT * FROM rtu_temp "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql  #FUN-A50102
            PREPARE i132_ins FROM g_sql
            EXECUTE i132_ins
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                  
               CALL cl_err3("ins","rtu_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","rtu",1)                                      
               EXIT FOREACH                                                                                               
               ROLLBACK WORK                                                                                            
               RETURN                                                                                                    
            END IF
            DELETE FROM rtv_temp
            INSERT INTO rtv_temp SELECT * FROM rtv_file WHERE rtv01 = g_rtu.rtu01 AND rtv02=g_rtu.rtu02     
                                                          AND rtvplant= g_rtu.rtuplant 
            UPDATE rtv_temp SET rtvplant=l_rtp05,
                                rtvlegal=l_legal      
           #LET g_sql="INSERT INTO ",s_dbstring(l_azp03 CLIPPED),"rtv_file",    #FUN-A50102 mark
            LET g_sql="INSERT INTO ",cl_get_target_table(l_rtp05,'rtv_file'),   #FUN-A50102                                                             
                      " SELECT * FROM rtv_temp "                                                                    
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql   #FUN-A50102
            PREPARE inse_prep1 FROM g_sql                                                                                         
            EXECUTE inse_prep1                                                          
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                        
               CALL cl_err3("ins","rtv_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","rtv",1)                                            
               EXIT FOREACH                                                                                                      
               ROLLBACK WORK                                                                                                     
               RETURN                                                                                                            
            END IF              
         END IF
      END IF                
      LET l_rtp05=''
      LET l_azp03=''
   END FOREACH                    
 
END FUNCTION
 
FUNCTION i132_transfer1()
DEFINE l_rts04  LIKE rts_file.rts04                                                                                         
DEFINE l_rtp05  LIKE rtp_file.rtp05                                                                                         
DEFINE l_azp03  LIKE azp_file.azp03                                                                                        
DEFINE ll_azp03 LIKE azp_file.azp03                                                                                       
DEFINE l_cnt    LIKE type_file.num5                                                                                     
                                                                                                                            
   #尋找當前DB                                                                                                              
   SELECT azp03 INTO ll_azp03 FROM azp_file                                                                       
    WHERE azp01=g_rtu.rtuplant                                                               
   IF SQLCA.sqlcode THEN                                                                                                   
      CALL cl_err('','art-116',1)                                                                                        
      ROLLBACK WORK                                                                                                         
      RETURN                                                                                                               
   END IF                                                                                                                   
                                                                                                                        
   #在采購協議中尋找合同編號                                                   
   SELECT rts04 INTO l_rts04 FROM rts_file WHERE rts01=g_rtu.rtu04                                                       
    AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant AND rtsconf='Y'               
    AND rts03 = (SELECT MAX(rts03) FROM rts_file WHERE rts01=g_rtu.rtu04
                AND rts02=g_rtu.rtu02 AND rtsplant=g_rtu.rtuplant)         #TQC-AC0106                                        
   IF SQLCA.sqlcode=100 THEN
      CALL cl_err('','art-112',1)  
      ROLLBACK WORK                                                                                                         
      RETURN                                                                                                                
   END IF                                                                                                                  
   #在采購合同中尋找生效機構                                                                                           
   DECLARE i132_trans_cs2 CURSOR FOR SELECT rtp05  FROM rtp_file,rto_file WHERE rtp01=rto01                                
    AND rtp02=rto02 AND rtp03=rto03 AND rtpplant=rtoplant AND rtoconf='Y'                                                    
    AND rtp01=l_rts04 AND rtp03=g_rtu.rtu02 AND rtpplant=g_rtu.rtuplant                                                      
   FOREACH i132_trans_cs2 INTO l_rtp05                                                                                
      IF SQLCA.sqlcode THEN                                                                                              
         CALL cl_err('','art-113',1)                                                                                   
         EXIT FOREACH                                                                                                 
         ROLLBACK WORK                                                                                                   
         RETURN                                                                                                        
      END IF                                                                                                         
 
      #根據生效機構尋找數據庫	
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_rtp05                                                
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err('','art-114',1)                                                                                                
         EXIT FOREACH                                                                                                               
         ROLLBACK WORK                                                                                                              
         RETURN                                                                                                                     
      END IF                                                                                                                    
      IF l_rtp05=g_rtu.rtuplant THEN                                                                                          
         IF l_azp03<>ll_azp03 THEN   
            LET l_cnt=0
           #LET g_sql="SELECT COUNT(*)  FROM ",s_dbstring(l_azp03 CLIPPED),"rtu_file ",  #FUN-A50102 mark
            LET g_sql="SELECT COUNT(*)  FROM ",cl_get_target_table(l_rtp05,'rtu_file'),  #FUN-A50102
                       " WHERE rtu01=? AND rtu02=? AND rtuplant=? ",
                       " AND rtuconf=? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102 
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql #FUN-A50102  
            PREPARE i132_sel FROM g_sql
            EXECUTE i132_sel INTO l_cnt USING g_rtu.rtu01,g_rtu.rtu02,g_rtu.rtuplant,'Y'  
           IF l_cnt<>0 THEN                            
           #LET g_sql="UPDATE ",s_dbstring(l_azp03 CLIPPED),"rtu_file",   #FUN-A50102 mark
            LET g_sql="UPDATE ",cl_get_target_table(l_rtp05,'rtu_file'),  #FUN-A50102                                                         
                      " SET rtuconf='X',rtumodu='",g_user,"',rtudate='",g_today,"', ",
                      " rtu11='",g_today,"' ",
                      " WHERE rtu01=? ",                                                             
                      " AND rtu02=? AND rtuplant=? "                                                                            
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql #FUN-A50102
            PREPARE updat_prep FROM g_sql                                                                                
            EXECUTE updat_prep USING g_rtu.rtu01,g_rtu.rtu02,l_rtp05  
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                            
               CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","rtu",1)                                   
               EXIT FOREACH                                                                                              
               ROLLBACK WORK                                                                                             
               RETURN                                                                                                 
            END IF
           END IF                                                                                                  
         END IF                                                                                                           
      ELSE
        LET l_cnt=0                                                                                                             
       #LET g_sql="SELECT COUNT(*)  FROM ",s_dbstring(l_azp03 CLIPPED),"rtu_file ",     #FUN-A50102 mark
        LET g_sql="SELECT COUNT(*)  FROM ",cl_get_target_table(l_rtp05,'rtu_file'),     #FUN-A50102                                                      
                  " WHERE rtu01=? AND rtu02=? AND rtuplant=? ",                                     
                  " AND rtuconf=? "                                                                                          
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql   #FUN-A50102
        PREPARE i132_sel1 FROM g_sql                                                                                             
        EXECUTE i132_sel1 INTO l_cnt USING g_rtu.rtu01,g_rtu.rtu02,l_rtp05,'Y'                                                      
        IF l_cnt<>0 THEN       
        # LET g_sql="UPDATE ",s_dbstring(l_azp03 CLIPPED),"rtu_file",                   #FUN-A50102 mark                                                                     
          LET g_sql="UPDATE ",cl_get_target_table(l_rtp05,'rtu_file'),                  #FUN-A50102
                    " SET rtuconf='X',rtumodu='",g_user,"',rtudate='",g_today,"', ",                                               
                    " rtu11='",g_today,"' ",                                                                                 
                    " WHERE rtu01=? ",                                                                                            
                    " AND rtu02=? AND rtuplant=? "                                                                                  
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql   #FUN-A50102
          PREPARE updat_prep1 FROM g_sql                                                                                         
          EXECUTE updat_prep1 USING g_rtu.rtu01,g_rtu.rtu02,l_rtp05                                                               
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                           
             CALL cl_err3("upd","rtu_file",g_rtu.rtu01,"",SQLCA.sqlcode,"","rtu",1)                                               
             EXIT FOREACH                                                                                                         
             ROLLBACK WORK                                                                                                        
             RETURN                                                                                                               
          END IF                                                                                                                  
        END IF
      END IF                                                                                                              
      LET l_rtp05=''   
      LET l_azp03=''                                                                                                  
   END FOREACH                                                                                                            
                             
END FUNCTION
#No.FUN-870007
