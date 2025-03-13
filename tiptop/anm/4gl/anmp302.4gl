# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmp302.4gl
# Descriptions...: 網銀整批支付作業 
# Date & Author..: No.FUN-740007 07/03/27 By wujie 
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改程序內有'(+)'的語法
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-870067 08/07/17 By douzh
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0232 09/11/30 By wujie 調整開窗
# Modify.........: No.FUN-9C0008 09/12/01 By alex 調整環境變量
# Modify.........: No:FUN-A30035 10/03/09 by dxfwo  GP5.2 使用unix2dos 需區分只有UNIX可用
# Modify.........: No:MOD-A80006 10/08/03 By Dido nps07 開窗抓取邏輯調整 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    g_nps         DYNAMIC ARRAY OF RECORD
        b         LIKE type_file.chr1,
        c         LIKE type_file.chr1,
        nps01     LIKE nps_file.nps01,
        nme22     LIKE nme_file.nme22,
        nme13     LIKE nme_file.nme13,
        nps03     LIKE nps_file.nps03,
        nps05     LIKE nps_file.nps05,
        nps14     LIKE nps_file.nps14,
        nps07     LIKE nps_file.nps07,
        nps08     LIKE nps_file.nps08,
        nps09     LIKE nps_file.nps09,
        nps26     LIKE nps_file.nps26,   #No.FUN-870067
        nps10     LIKE nps_file.nps10,
        nps11     LIKE nps_file.nps11,
        nps27     LIKE nps_file.nps27,   #No.FUN-870067 
        nps12     LIKE nps_file.nps12,
        nps13     LIKE nps_file.nps13,
        nps20     LIKE nps_file.nps20,
        nps15     LIKE nps_file.nps15,
        nps16     LIKE nps_file.nps16,
        nps17     LIKE nps_file.nps17
                  END RECORD,
    g_nps_t       RECORD                 #程式變數 (舊值)
        b         LIKE type_file.chr1,
        c         LIKE type_file.chr1,
        nps01     LIKE nps_file.nps01,
        nme22     LIKE nme_file.nme22,
        nme13     LIKE nme_file.nme13,
        nps03     LIKE nps_file.nps03,
        nps05     LIKE nps_file.nps05,
        nps14     LIKE nps_file.nps14,
        nps07     LIKE nps_file.nps07,
        nps08     LIKE nps_file.nps08,
        nps09     LIKE nps_file.nps09,
        nps26     LIKE nps_file.nps26,   #No.FUN-870067
        nps10     LIKE nps_file.nps10,
        nps11     LIKE nps_file.nps11,
        nps27     LIKE nps_file.nps27,   #No.FUN-870067 
        nps12     LIKE nps_file.nps12,
        nps13     LIKE nps_file.nps13,
        nps20     LIKE nps_file.nps20,
        nps15     LIKE nps_file.nps15,
        nps16     LIKE nps_file.nps16,
        nps17     LIKE nps_file.nps17
                  END RECORD,
    g_nps_o       RECORD                 #程式變數 (舊值)
        b         LIKE type_file.chr1,
        c         LIKE type_file.chr1,
        nps01     LIKE nps_file.nps01,
        nme22     LIKE nme_file.nme22,
        nme13     LIKE nme_file.nme13,
        nps03     LIKE nps_file.nps03,
        nps05     LIKE nps_file.nps05,
        nps14     LIKE nps_file.nps14,
        nps07     LIKE nps_file.nps07,
        nps08     LIKE nps_file.nps08,
        nps09     LIKE nps_file.nps09,
        nps26     LIKE nps_file.nps26,   #No.FUN-870067
        nps10     LIKE nps_file.nps10,
        nps11     LIKE nps_file.nps11,
        nps27     LIKE nps_file.nps27,   #No.FUN-870067 
        nps12     LIKE nps_file.nps12,
        nps13     LIKE nps_file.nps13,
        nps20     LIKE nps_file.nps20,
        nps15     LIKE nps_file.nps15,
        nps16     LIKE nps_file.nps16,
        nps17     LIKE nps_file.nps17
                  END RECORD,
    g_wc,g_wc2,g_sql    string,  
    g_rec_b         LIKE type_file.num5,            #單身筆數
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT
DEFINE     g_nme         DYNAMIC ARRAY OF RECORD
               a         LIKE type_file.chr1,
               nme01     LIKE nme_file.nme01,
               nma02     LIKE nma_file.nma02,
               nme22     LIKE nme_file.nme22,
               nme12     LIKE nme_file.nme12,
               nme21     LIKE nme_file.nme21,
               nme04     LIKE nme_file.nme04,
               nma10     LIKE nma_file.nma10,
               nme14     LIKE nme_file.nme14,
               nml02     LIKE nml_file.nml02,
               nme03     LIKE nme_file.nme03,
               nmc02     LIKE nmc_file.nmc02,
               nme25     LIKE nme_file.nme25,
               nme13     LIKE nme_file.nme13,
               nme16     LIKE nme_file.nme16,
               nme05     LIKE nme_file.nme05
                  END RECORD
DEFINE     g_nme1        DYNAMIC ARRAY OF RECORD
               a         LIKE type_file.chr1,
               nme01     LIKE nme_file.nme01,
               nma02     LIKE nma_file.nma02,
               nme22     LIKE nme_file.nme22,
               nme12     LIKE nme_file.nme12,
               nme21     LIKE nme_file.nme21,
               nme04     LIKE nme_file.nme04,
               nma10     LIKE nma_file.nma10,
               nme14     LIKE nme_file.nme14,
               nml02     LIKE nml_file.nml02,
               nme03     LIKE nme_file.nme03,
               nmc02     LIKE nmc_file.nmc02,
               nme25     LIKE nme_file.nme25,
               nme13     LIKE nme_file.nme13,
               nme16     LIKE nme_file.nme16,               
               nme05     LIKE nme_file.nme05,
               nme15     LIKE nme_file.nme15,                 #No.FUN-870067               
               nme23     LIKE nme_file.nme23
                  END RECORD
DEFINE     g_npt         DYNAMIC ARRAY OF RECORD
               npt01     LIKE npt_file.npt01,
               npt03     LIKE npt_file.npt03,
               npt04     LIKE npt_file.npt04,
               npt05     LIKE npt_file.npt05,
               npt06     LIKE npt_file.npt06
                  END RECORD
DEFINE     g_npt_t       RECORD
               npt01     LIKE npt_file.npt01,
               npt03     LIKE npt_file.npt03,
               npt04     LIKE npt_file.npt04,
               npt05     LIKE npt_file.npt05,
               npt06     LIKE npt_file.npt06
                  END RECORD,
           g_rec_b1      LIKE type_file.num5,            #單身筆數
           g_rec_b2      LIKE type_file.num5,            #單身筆數
           g_rec_b3      LIKE type_file.num5,            #單身筆數
           l_ac1    LIKE type_file.num5             #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt             LIKE type_file.num10     
DEFINE g_i               LIKE type_file.num5 
DEFINE g_nps01           LIKE nps_file.nps01
DEFINE g_nmv             RECORD LIKE nmv_file.*   
DEFINE g_str             STRING
DEFINE g_flag            LIKE type_file.chr1
 
MAIN 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time              
 
   OPEN WINDOW p302_w WITH FORM "anm/42f/anmp302"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL p302_menu()
 
   CLOSE WINDOW p302_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time                #NO.FUN-6A0094             
END MAIN
 
FUNCTION p302_menu()
 
   WHILE TRUE
      CALL p302_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p302_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_nps[1].nps01 IS NOT NULL THEN
                  CALL p302_b()
               ELSE
                  LET g_action_choice = NULL
               END IF
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nps),'','')
            END IF
         WHEN "direct_pay"
            IF cl_chk_act_auth() THEN
               CALL p302_direct()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "landing_pay"
            IF cl_chk_act_auth() THEN
               CALL p302_landing()
            ELSE
               LET g_action_choice = NULL
            END IF 
         WHEN "pay_command"
            IF cl_chk_act_auth() THEN
               CALL p302_command()
            ELSE
               LET g_action_choice = NULL
            END IF         
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p302_q()
 
   CALL p302_b_askkey()
 
END FUNCTION
 
FUNCTION p302_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
          l_n             LIKE type_file.num5,                #檢查重復用    
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否    
          p_cmd           LIKE type_file.chr1,                #處理狀態      
          l_allow_insert  LIKE type_file.num5,                #可新增否      
          l_allow_delete  LIKE type_file.num5                 #可刪除否      
   DEFINE l_i,i           LIKE type_file.num5                
   DEFINE l_nps19         LIKE nps_file.nps19
   DEFINE l_nme25         LIKE nme_file.nme25
   DEFINE l_nma39         LIKE nma_file.nma39
   DEFINE l_result        STRING
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
    
   LET g_forupd_sql = "SELECT 'N','N',nps01,'','',nps03,nps05,nps14,nps07,",  
                      "       nps08,nps09,nps26,nps10,nps11,nps27,nps12,nps13,nps20,nps15,nps16,nps17",  #No.FUN-870067
                      "  FROM nps_file WHERE nps01 =? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p302_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nps WITHOUT DEFAULTS FROM s_nps.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'        
 
         IF g_rec_b >= l_ac THEN
            LET g_nps_t.* = g_nps[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN p302_bcl USING g_nps_t.nps01
            IF STATUS THEN
               CALL cl_err("OPEN p302_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH p302_bcl INTO g_nps[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nps_t.nps01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nme13,nme22 INTO g_nps[l_ac].nme13,g_nps[l_ac].nme22 FROM nme_file 
                WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[l_ac].nps01
               IF g_nps[l_ac].nps14 =cl_getmsg('anm-801','2') THEN
                  LET g_nps[l_ac].nps14 =1
               END IF
               IF g_nps[l_ac].nps14 =cl_getmsg('anm-802','2') THEN
                  LET g_nps[l_ac].nps14 =2
               END IF  
               CALL cl_set_comp_entry("nps14,nps07,nps15,nps16",TRUE)             
               IF g_nps[l_ac].nps17 NOT MATCHES '[19]' THEN
                  CALL cl_set_comp_entry("nps14,nps07,nps15,nps16",FALSE)
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL cl_show_fld_cont()   
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nps[l_ac].* TO NULL     
         LET g_nps_t.* = g_nps[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                    
         CALL cl_show_fld_cont()     
         NEXT FIELD b
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO nps_file(nps01,nps03,nps05,nps14,nps07,
                              nps08,nps09,nps10,nps11,nps12,nps13,nps20,nps15,nps16,nps17,nps26,nps27)   #No.FUN-870067            
              VALUES(g_nps[l_ac].nps01,g_nps[l_ac].nps03,
                     g_nps[l_ac].nps05,g_nps[l_ac].nps14,
                     g_nps[l_ac].nps07,g_nps[l_ac].nps08,
                     g_nps[l_ac].nps09,g_nps[l_ac].nps10,
                     g_nps[l_ac].nps11,g_nps[l_ac].nps12,
                     g_nps[l_ac].nps13,g_nps[l_ac].nps20,
                     g_nps[l_ac].nps15,g_nps[l_ac].nps16,
                     g_nps[l_ac].nps17,g_nps[l_ac].nps26,                                  #No.FUN-870067
                     g_nps[l_ac].nps27)                                                    #No.FUN-870067
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nps_file",g_nps[l_ac].nps01,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cnt  
         END IF
 
      BEFORE FIELD b
         CALL cl_set_comp_entry("b,c",TRUE)
         SELECT nps19 INTO l_nps19 FROM nps_file WHERE nps01 =g_nps[l_ac].nps01
         IF l_nps19  <>g_aza.aza74 THEN
            CALL cl_set_comp_entry("b,c",FALSE)
            CALL cl_err('','anm-906',1)
         END IF
         IF g_nps[l_ac].nps17 <>'1' AND g_nps[l_ac].nps17 <>'9' THEN
            LET g_nps[l_ac].b ='N'
         END IF
         IF g_nps[l_ac].c ='Y' THEN
            CALL cl_set_comp_entry("b",FALSE)
         END IF         
 
                  
      AFTER FIELD b
         IF g_nps[l_ac].b <> g_nps_t.b  THEN
            IF g_nps[l_ac].nps03 MATCHES 'N03*' THEN 
               CALL p302_check_npt()
            END IF
            IF g_nps[l_ac].nps03 MATCHES 'N02*' THEN  
               LET l_n =0           
               FOR i=1 TO g_nps.getLength()
                   IF g_nps[i].b ='Y' AND g_nps[i].nps03 =g_nps[l_ac].nps03 THEN
                      LET l_n =l_n+1
                   END IF
               END FOR
               IF l_n >30 THEN
                  CALL cl_err('','anm-907',1)
               END IF
            END IF 
            IF g_nps[l_ac].b ='Y' THEN
               CALL cl_set_comp_entry("c",FALSE)
            ELSE
            	 CALL cl_set_comp_entry("c",TRUE)
            END IF
         END IF
         IF g_nps[l_ac].nps17 <>'1' AND g_nps[l_ac].nps17 <>'9' AND g_nps[l_ac].b ='Y' THEN
            LET g_nps[l_ac].b ='N'
            CALL cl_err('','anm-811',1)
         END IF
            
      AFTER FIELD c
         IF g_nps[l_ac].c <> g_nps_t.c  THEN
            IF g_nps[l_ac].nps03 MATCHES 'N03*' THEN 
               CALL p302_check_npt()
            END IF            
            IF g_nps[l_ac].nps03 MATCHES 'N02*' THEN  
               LET l_n =0           
               FOR i=1 TO g_nps.getLength()
                   IF g_nps[i].c ='Y' AND g_nps[i].nps03 =g_nps[l_ac].nps03 THEN
                      LET l_n =l_n+1
                   END IF
               END FOR
               IF l_n >30 THEN
                  CALL cl_err('','anm-907',1)
               END IF  
            END IF
#No.FUN-870067--begin
            IF g_nps[l_ac].c ='Y' THEN
               SELECT nps19 INTO l_nps19 FROM nps_file WHERE nps01 = g_nps[l_ac].nps01
               IF g_aza.aza78 IS NOT NULL AND g_aza.aza78 = l_nps19 THEN                                                                                    
                  CALL cl_set_comp_required("nps05,nps07,nps26,nps27",TRUE)
                  IF cl_null(g_nps[l_ac].nps26) OR cl_null(g_nps[l_ac].nps27) THEN
                     CALL cl_err('','anm-148',0)
                     IF cl_null(g_nps[l_ac].nps26) THEN
                        NEXT FIELD nps26
                     ELSE
                     	 NEXT FIELD nps27
                     END IF 	  
                  END IF                                                                                  
               ELSE                                                                                  
                  CALL cl_set_comp_required("nps05,nps07,nps26,nps27",FALSE)                                                                                
               END IF
            END IF      
#No.FUN-870067--end                  
         END IF
         IF g_nps[l_ac].c ='N' THEN
            CALL cl_set_comp_entry("b",TRUE)
         END IF
         IF g_nps[l_ac].nps17 <>'1' AND g_nps[l_ac].nps17 <>'9' AND g_nps[l_ac].c ='Y' THEN
            LET g_nps[l_ac].c ='N'
            CALL cl_err('','anm-811',1)
         END IF
 
      BEFORE FIELD nps03
         CALL p302_combo()
         CALL cl_set_comp_entry("nps03,nps07,nps14",TRUE)
         CALL cl_set_comp_required("nps07,nps14",FALSE)
         IF g_nps[l_ac].nps03 ='N02031' 
            OR g_nps[l_ac].nps03 ='N02041'
            OR g_nps[l_ac].nps03 ='N02020'
            OR g_nps[l_ac].nps03 ='N03030'  THEN
            CALL cl_set_comp_entry("nps03",FALSE) 
         END IF                                         
 
      AFTER FIELD nps03
         IF g_nps_t.nps03 ='N03010' 
            OR g_nps_t.nps03 ='N03020'  THEN
            IF g_nps[l_ac].nps03 <>'N03010'
               AND g_nps[l_ac].nps03 <>'N03020' THEN
               CALL cl_err('','anm-908',1)
               LET g_nps[l_ac].nps03 =g_nps_t.nps03
               NEXT FIELD nps03
            END IF
         END IF
         IF g_nps[l_ac].nps03 <> g_nps_t.nps03 
            AND (g_nps[l_ac].nps03 ='N02031' OR g_nps[l_ac].nps03 ='N02041' OR g_nps[l_ac].nps03 ='N02020') THEN
            CALL cl_set_comp_required("nps07",TRUE)
         END IF
         IF g_nps[l_ac].nps03 <> g_nps_t.nps03 
            AND (g_nps[l_ac].nps03 MATCHES 'N03*') THEN
            CALL cl_set_comp_entry("nps07,nps14",FALSE)
         END IF
         IF g_nps[l_ac].nps03 <> g_nps_t.nps03 
            AND (g_nps[l_ac].nps03 NOT MATCHES 'N03*') THEN
            CALL cl_set_comp_required("nps14",TRUE)
         END IF
 
      BEFORE FIELD nps07
         IF g_nps[l_ac].nps03 ='N02031' OR g_nps[l_ac].nps03 ='N02041' OR g_nps[l_ac].nps03 ='N02020' THEN
            CALL cl_set_comp_required("nps07",TRUE)
         END IF
         IF g_nps[l_ac].nps03 MATCHES 'N03*' THEN
            CALL cl_set_comp_entry("nps07",FALSE)
         END IF
         
      AFTER FIELD nps07
         IF g_nps[l_ac].nps07 <> g_nps_t.nps07 THEN
            CALL p302_nps07()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nps[l_ac].nps07,g_errno,1)
               LET g_nps[l_ac].nps07 =g_nps_t.nps07
               NEXT FIELD nps07
            END IF
            IF g_nps[l_ac].nps07 =g_nps[l_ac].nps05 THEN
               CALL cl_err(g_nps[l_ac].nps07,'',1)
               LET g_nps[l_ac].nps07 =g_nps_t.nps07
               NEXT FIELD nps07
            END IF
         END IF
 
      BEFORE FIELD nps14
         IF g_nps[l_ac].nps03 MATCHES 'N03*' THEN
            CALL cl_set_comp_entry("nps14",FALSE)
         ELSE
#No.FUN-870067--begin
            IF g_nps[l_ac].nps01 IS NOT NULL THEN
               SELECT nps19 INTO l_nps19 FROM nps_file
                WHERE nps01=g_nps[l_ac].nps01
               IF l_nps19 =  g_aza.aza78   THEN
                  CALL cl_set_comp_entry("nps14",FALSE)
               ELSE
                  CALL cl_set_comp_required("nps14",TRUE)
               END IF
            END IF
#No.FUN-870067--end
         END IF
               
#No.FUN-870067--begin
      AFTER FIELD nps27
         IF g_nps[l_ac].nps26 ='CN' THEN
            LET g_nps[l_ac].nps27 = 'OUR' 
            DISPLAY BY NAME g_nps[l_ac].nps27
            CALL cl_set_comp_entry("nps27",FALSE)
         ELSE
            CALL cl_set_comp_required("nps27",TRUE)
         END IF
#No.FUN-870067--end
 
      BEFORE DELETE                            #是否取消單身 
         IF g_nps[l_ac].nps17 <>'1' AND g_nps[l_ac].nps17 <>'9' THEN
            CALL cl_err('','anm-808',1)
            CANCEL DELETE
         END IF
         IF NOT cl_delete() THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN 
            CALL cl_err("", -263, 1) 
            CANCEL DELETE 
         END IF
         
         DELETE FROM nps_file WHERE nps01 = g_nps_t.nps01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","nps_file",g_nps_t.nps01,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE 
         END IF
 
         UPDATE nme_file SET nme24 ='9'
          WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) = g_nps_t.nps01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","nme_file",g_nps_t.nps01,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE 
         END IF
         
         LET g_rec_b=g_rec_b-1
         DISPLAY g_rec_b TO FORMONLY.cnt 
         MESSAGE "Delete OK"
         CLOSE p302_bcl
         COMMIT WORK 
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nps[l_ac].* = g_nps_t.*
            CLOSE p302_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nps[l_ac].nps01,-263,1)
            LET g_nps[l_ac].* = g_nps_t.*
         ELSE
           IF g_nps[l_ac].nps17 ='1' OR g_nps[l_ac].nps17 ='9' THEN
             CASE g_nps[l_ac].nps14
                WHEN '1'
                     LET g_nps[l_ac].nps14=cl_getmsg('anm-801','2') 
                WHEN '2'
                     LET g_nps[l_ac].nps14=cl_getmsg('anm-802','2') 
             END CASE
              UPDATE nps_file SET
                    nps01 = g_nps[l_ac].nps01,
                    nps03 = g_nps[l_ac].nps03,
                    nps05 = g_nps[l_ac].nps05,
                    nps14 = g_nps[l_ac].nps14,
                    nps07 = g_nps[l_ac].nps07,
                    nps08 = g_nps[l_ac].nps08,
                    nps09 = g_nps[l_ac].nps09,
                    nps10 = g_nps[l_ac].nps10,
                    nps11 = g_nps[l_ac].nps11,
                    nps12 = g_nps[l_ac].nps12,
                    nps13 = g_nps[l_ac].nps13,
                    nps20 = g_nps[l_ac].nps20,
                    nps15 = g_nps[l_ac].nps15,
                    nps16 = g_nps[l_ac].nps16,
                    nps17 = g_nps[l_ac].nps17,
                    nps26 = g_nps[l_ac].nps26,     #No.FUN-870067 
                    nps27 = g_nps[l_ac].nps27      #No.FUN-870067 
              WHERE nps01 =g_nps_t.nps01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nps_file",g_nps_t.nps01,"",SQLCA.sqlcode,"","",1)  
                 LET g_nps[l_ac].* = g_nps_t.*
              ELSE
                 COMMIT WORK
                 CASE g_nps[l_ac].nps14
                    WHEN cl_getmsg('anm-801','2')
                         LET g_nps[l_ac].nps14='1'
                    WHEN cl_getmsg('anm-801','2')
                         LET g_nps[l_ac].nps14='2'
                 END CASE
              END IF
           ELSE
           	  CALL cl_err('','anm-811',0)
           END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_nps[l_ac].* = g_nps_t.*
            END IF
            CLOSE p302_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_rec_b <> 0  AND l_ac <> 1 AND g_rec_b > l_ac THEN
            IF cl_null(g_nps[l_ac].nps01) THEN
               NEXT FIELD nps01
            END IF
            IF cl_null(g_nps[l_ac].nme22) THEN
               NEXT FIELD nme22
            END IF
            IF cl_null(g_nps[l_ac].nps03) THEN
               NEXT FIELD nps03
            END IF
            IF cl_null(g_nps[l_ac].nps05) THEN
               NEXT FIELD nps05
            END IF
            IF cl_null(g_nps[l_ac].nps12) THEN
               NEXT FIELD nps12
            END IF
            IF cl_null(g_nps[l_ac].nps13) THEN
               NEXT FIELD nps13
            END IF
            IF cl_null(g_nps[l_ac].nps15) THEN
               NEXT FIELD nps15
            END IF
         END IF
         CLOSE p302_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nps01) AND l_ac > 1 THEN
            LET g_nps[l_ac].* = g_nps[l_ac-1].*
            NEXT FIELD nps01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         IF INFIELD(nps07) THEN
            IF g_nps[l_ac].nps03 ='N02031' OR g_nps[l_ac].nps03 ='N0041' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nps07_02"
               SELECT nme25 INTO l_nme25 FROM nme_file
                WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[l_ac].nps01
               LET g_qryparam.arg1 =l_nme25
               LET g_qryparam.default1 = g_nps[l_ac].nps07
               CALL cl_create_qry() RETURNING g_nps[l_ac].nps07
               DISPLAY BY NAME g_nps[l_ac].nps07
               NEXT FIELD nps07
            END IF
            IF g_nps[l_ac].nps03 ='N02020' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nps07_01"
               SELECT nma39 INTO l_nma39 FROM nma_file,nme_file
                WHERE nma01 =nme01 AND nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[l_ac].nps01
               LET g_qryparam.arg1 =l_nma39
               LET g_qryparam.default1 = g_nps[l_ac].nps07
               CALL cl_create_qry() RETURNING g_nps[l_ac].nps07
               DISPLAY BY NAME g_nps[l_ac].nps07
               NEXT FIELD nps07
            END IF
         END IF 
#No.FUN-870067--begin
           CASE
             WHEN INFIELD(nps26)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_geb'
               LET g_qryparam.default1 = g_nps[l_ac].nps26
               CALL cl_create_qry() RETURNING g_nps[l_ac].nps26
               DISPLAY g_nps[l_ac].nps26 TO nps26 
             OTHERWISE
                    EXIT CASE  
           END CASE 
#No.FUN-870067--end
               
 
 
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
 
      ON ACTION private 
         CALL p302_private()
   END INPUT
 
   CLOSE p302_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION p302_b_askkey()
DEFINE   l_nme25       LIKE nme_file.nme25
DEFINE   l_nma39       LIKE nma_file.nma39
DEFINE   l_nps01       LIKE nps_file.nps01        #MOD-A80006
DEFINE   l_nps03       LIKE nps_file.nps03        #MOD-A80006
 
   CLEAR FORM
   CALL g_nps.clear()
 
   CONSTRUCT g_wc2 ON nps01,nps03,nps05,nps14,nps07,nps08,nps09,
                      nps26,nps10,nps11,nps27,nps12,nps13,nps15,nps16,nps17            #No.FUN-870067
           FROM s_nps[1].nps01,s_nps[1].nps03,s_nps[1].nps05,s_nps[1].nps14,s_nps[1].nps07,s_nps[1].nps08,s_nps[1].nps09,  
                s_nps[1].nps26,s_nps[1].nps10,s_nps[1].nps11,s_nps[1].nps27,s_nps[1].nps12,s_nps[1].nps13,s_nps[1].nps15,
                s_nps[1].nps16,s_nps[1].nps17
 
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
    
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
          
      ON ACTION qbe_save
		   CALL cl_qbe_save()
 
      ON ACTION CONTROLP
 
         IF INFIELD(nps01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps01
            NEXT FIELD nps01
         END IF
 
         IF INFIELD(nps05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps05"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps05
            NEXT FIELD nps05
         END IF
 
#No.TQC-9B0232 --begin
        #-MOD-A80006-remark-
         IF INFIELD(nps07) THEN
           CALL GET_FLDBUF(nps01) RETURNING l_nps01                             #MOD-A80006
           CALL GET_FLDBUF(nps03) RETURNING l_nps03                             #MOD-A80006
          #IF g_nps[l_ac].nps03 ='N02031' OR g_nps[l_ac].nps03 ='N0041' THEN    #MOD-A80006 mark
           IF l_nps03 ='N02031' OR l_nps03 ='N0041' THEN                        #MOD-A80006 mark
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_nps07_02"
               SELECT nme25 INTO l_nme25 FROM nme_file
               #WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[l_ac].nps01  #MOD-A80006 mark
                WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =l_nps01            #MOD-A80006
               LET g_qryparam.arg1= l_nme25
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nps07
               NEXT FIELD nps07
            END IF
           #IF g_nps[l_ac].nps03 ='N02020' THEN                                  #MOD-A80006 mark 
            IF l_nps03 ='N02020' THEN                                            #MOD-A80006
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_nps07_01"
               SELECT nma39 INTO l_nma39 FROM nma_file,nme_file
               #WHERE nma01 =nme01 AND nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[l_ac].nps01     #MOD-A80006 mark 
                WHERE nma01 =nme01 AND nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =l_nps01               #MOD-A80006
               LET g_qryparam.arg1 =l_nma39
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nps07
               NEXT FIELD nps07
            END IF
         END IF 
        #-MOD-A80006-end-
#No.TQC-9B0232 --end
 
         IF INFIELD(nps09) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps09"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps09
            NEXT FIELD nps09
         END IF
                
         IF INFIELD(nps10) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps10"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps10
            NEXT FIELD nps10
         END IF
 
         IF INFIELD(nps11) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps11"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps11
            NEXT FIELD nps11
         END IF
 
         IF INFIELD(nps13) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps13"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps13
            NEXT FIELD nps13
         END IF
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL p302_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p302_b_fill(p_wc2)              #BODY FILL UP
   DEFINE #p_wc2   LIKE type_file.chr1000
          p_wc2    STRING      #NO.FUN-910082       
 
   LET g_sql = "SELECT 'N','N',nps01,'','',nps03,nps05,nps14,nps07,",  
               "       nps08,nps09,nps26,nps10,nps11,nps27,nps12,nps13,nps20,nps15,nps16,nps17",        #No.FUN-870067
               "  FROM nps_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY nps01"
   PREPARE p302_pb FROM g_sql
   DECLARE nps_curs CURSOR FOR p302_pb
 
   CALL g_nps.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH nps_curs INTO g_nps[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF g_nps[g_cnt].nps14 =cl_getmsg('anm-801','2') THEN
         LET g_nps[g_cnt].nps14 =1
      END IF
      IF g_nps[g_cnt].nps14 =cl_getmsg('anm-802','2') THEN
         LET g_nps[g_cnt].nps14 =2
      END IF
 
      SELECT nme13,nme22 INTO g_nps[g_cnt].nme13,g_nps[g_cnt].nme22 FROM nme_file 
       WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[g_cnt].nps01
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_nps.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p302_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nps TO s_nps.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
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
          CALL cl_show_fld_cont()                  
 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION exit
         LET g_action_choice="exit"
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
 
      ON ACTION direct_pay
         LET g_action_choice = 'direct_pay'
         EXIT DISPLAY
         
      ON ACTION landing_pay
         LET g_action_choice = 'landing_pay'
         EXIT DISPLAY
                 
      ON ACTION pay_command
         LET g_action_choice = 'pay_command'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p302_nps07()   
DEFINE l_n         LIKE type_file.num5,
       l_pmf04     LIKE pmf_file.pmf04,
       l_nmt02     LIKE nmt_file.nmt02,
       l_nmt06     LIKE nmt_file.nmt06,
       l_nmt07     LIKE nmt_file.nmt07,
       l_nma02     LIKE nma_file.nma02
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_nmt12     LIKE nmt_file.nmt12      #No.FUN-870067
DEFINE l_nmt13     LIKE nmt_file.nmt13      #No.FUN-870067
 
 
  LET g_errno = ''
  IF g_aza.aza78 IS NULL THEN
    IF g_nps[l_ac].nps03 ='N02031' OR g_nps[l_ac].nps03 ='N02041' THEN
	     SELECT COUNT(*) INTO l_n 
         FROM pmf_file,nme_fle
        WHERE pmfacti ='Y'
          AND nme22||'_'||nme12||'_'||nmr21 =g_nps[l_ac].nps01
          AND pmf03 =g_nps[l_ac].nps07
       
       IF l_cnt=0 THEN
          LET g_errno ='100'
          RETURN
       END IF
       SELECT pmf04,nmt02,nmt06,nmt07,nmt12,nmt13 INTO l_pmf04,l_nmt02,l_nmt06,l_nmt07,l_nmt12,l_nmt13         #No.FUN-870067
         FROM pmf_file,nmt_file,nme_file 
        WHERE pmf01=nme25
          AND pmfacti ='Y'
          AND nmt01=pmf02
          AND nme22||'_'||nme12||'_'||nmr21 =g_nps[l_ac].nps01
          AND pmf03 =g_nps[l_ac].nps07
       IF NOT cl_null(l_pmf04) AND NOT cl_null(l_nmt02) AND NOT cl_null(l_nmt06) AND NOT cl_null(l_nmt07) THEN
          DISPLAY l_pmf04 TO g_nps[l_ac].nps08
          DISPLAY l_nmt02 TO g_nps[l_ac].nps09
          DISPLAY l_nmt13 TO g_nps[l_ac].nps26                                                   #No.FUN-870067 
          DISPLAY l_nmt06 TO g_nps[l_ac].nps10
          DISPLAY l_nmt07 TO g_nps[l_ac].nps11
       ELSE
          LET g_errno ='-100'
          RETURN    	 
       END IF
    END IF
    IF g_nps[l_ac].nps03 ='N02020' THEN
	     SELECT COUNT(*) INTO l_n 
         FROM nma_file,nme_fle
        WHERE nma01 = nme01
          AND nme22||'_'||nme12||'_'||nmr21 =g_nps[l_ac].nps01
          AND nma01 =g_nps[l_ac].nps07
          AND nmaacti ='Y'
       
       IF l_cnt=0 THEN
          LET g_errno ='-100'
          RETURN
       END IF
       SELECT nma02,nmt02,nmt06,nmt07,nmt12,nmt13  INTO l_nma02,l_nmt02,l_nmt06,l_nmt07,l_nmt12,l_nmt13     #No.FUN-870067 
         FROM nma_file,nmt_file,nme_file 
        WHERE nma01 = nme01
          AND nme22||'_'||nme12||'_'||nmr21 =g_nps[l_ac].nps01
          AND nma01 =g_nps[l_ac].nps07
          AND nmaacti ='Y'
          AND nmt01 =nma39
          
       IF NOT cl_null(l_nma02) AND NOT cl_null(l_nmt02) AND NOT cl_null(l_nmt06) AND NOT cl_null(l_nmt07) THEN
          DISPLAY l_nma02 TO g_nps[l_ac].nps08
          DISPLAY l_nmt02 TO g_nps[l_ac].nps09
          DISPLAY l_nmt13 TO g_nps[l_ac].nps26                                                #No.FUN-870067 
          DISPLAY l_nmt06 TO g_nps[l_ac].nps10
          DISPLAY l_nmt07 TO g_nps[l_ac].nps11
       ELSE
          LET g_errno ='-100'
          RETURN    	 
       END IF
    END IF
 ELSE 
#No.FUN-870067--begin
    IF g_nps[l_ac].nps26 IS NOT NULL THEN
       IF g_aza.aza78 IS NOT NULL AND l_nmt12 = g_aza.aza78 THEN
          IF g_nps[l_ac].nps26 ='CN' THEN
             LET g_nps[l_ac].nps27 = 'OUR' 
             DISPLAY BY NAME g_nps[l_ac].nps27
             CALL cl_set_comp_entry("nps27",FALSE)
          ELSE
             CALL cl_set_comp_entry("nps27",TRUE)
          END IF
       ELSE
          CALL cl_set_comp_entry("nps27",FALSE)
       END IF
     END IF
 END IF
#No.FUN-870067--begin
 
END FUNCTION
 
FUNCTION p302_check_npt()
         DEFINE l_n         LIKE type_file.num5,
                l_npt05     LIKE npt_file.npt05
         DEFINE l_cnt       LIKE type_file.num5
 
 
	  LET g_errno = ''
	  SELECT COUNT(*) INTO l_n 
      FROM npt_file
     WHERE npt01 =g_nps[l_ac].nps01
    
    IF l_n=0 THEN
       CALL cl_err('','anm-909',1)
       IF INFIELD(b) THEN
          LET g_nps[l_ac].b ='N'
       END IF
       IF INFIELD(c) THEN
          LET g_nps[l_ac].c ='N'
       END IF       
       CALL p302_private()
    END IF
    SELECT SUM(npt05) INTO l_npt05 FROM npt_file
     WHERE npt01 =g_nps[l_ac].nps01
 
    IF g_nps[l_ac].nps12 <> l_npt05 THEN
       CALL cl_err('','anm-910',1)
       IF INFIELD(b) THEN
          LET g_nps[l_ac].b ='N'
       END IF
       IF INFIELD(c) THEN
          LET g_nps[l_ac].c ='N'
       END IF       
       CALL p302_private()
    END IF       
END FUNCTION
 
FUNCTION p302_command()
 
   OPEN WINDOW p302_p_w WITH FORM "anm/42f/anmp302_c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CONSTRUCT g_wc  ON nme22,nme01,nme12,nme21,nme16       
           FROM nme22_q,nme01_q,nme12_q,nme21_q,nme16_q
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
    
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
          
      ON ACTION qbe_save
		   CALL cl_qbe_save()
 
      ON ACTION CONTROLP
 
         IF INFIELD(nme01_q) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nme01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nme01_q
            NEXT FIELD nme01_q
         END IF
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      CLOSE WINDOW p302_p_w 
      RETURN
   END IF
 
   IF g_aza.aza78 IS NULL THEN
      LET g_sql="SELECT 'N',nme01,nma02,nme22,nme12,nme21,nme04,nma10,nme14,nml02,nme03,nmc02,nme25,nme13,nme16,nme05,nme23,nme15",
#               "  FROM nme_file,nma_file,nmc_file,nmt_file,aza_file,nml_file",                             #No.TQC-780054
                "  FROM nme_file LEFT OUTER JOIN nml_file ON nme14 = nml01,nma_file,nmc_file,nmt_file,aza_file",                       #No.TQC-780054
                " WHERE (nme01 =nma01 AND nma43 ='Y' AND nmaacti ='Y' AND nma37 ='1')",
                "   AND ((nme22 <='04' AND nme23 ='2') OR ((nme22 ='05' OR nme22 ='06') AND nme23 ='01')",
                "    OR (nme22 ='07' AND (nme23 ='0' OR nme23 ='1' ) AND (nme25!='EMPL' or nme25 is null)))",
                "   AND (nme03 =nmc01 AND nmc03 ='2')",
                "   AND nme24 ='9' AND nmeacti ='Y'",
                "   AND nmt01 =nma39 AND nmt12 =aza74 AND nmtacti ='Y'",
#               "   AND nme14 =nml01(+)",                                                                   #No.TQC-780054
                "   AND ",g_wc,
                " UNION ",
                "SELECT 'N',nme01,nma02,nme22,nme12,nme21,nme04,nma10,nme14,nml02,nme03,nmc02,nme25,nme13,nme16,nme05,nme23,nme15",
#               "  FROM nme_file,nma_file,nmc_file,nmt_file,aza_file,nml_file",                             #No.TQC-780054
                "  FROM nme_file LEFT OUTER JOIN nml_file ON nme14 = nml01,nma_file,nmc_file,nmt_file,aza_file",                       #No.TQC-780054
                " WHERE (nme01 =nma01 AND nma43 ='Y' AND nmaacti ='Y' AND nma37 ='1')",
                "   AND (nme22 ='07' AND (nme23 ='0' OR nme23 ='1') AND nme25 ='EMPL')",
                "   AND (nme03 =nmc01)",
                "   AND nme24 ='9' AND nmeacti ='Y'",
                "   AND nmt01 =nma39 AND nmt12 =aza74 AND nmtacti ='Y'",
#               "   AND nme14 =nml01(+)",                                                                   #No.TQC-780054
                "   AND ",g_wc
#No.FUN-870067--begin
   ELSE
      LET g_sql="SELECT 'N',nme01,nma02,nme22,nme12,nme21,nme04,nma10,nme14,nml02,nme03,nmc02,nme25,nme13,nme16,nme05,nme23,nme15",
                "  FROM nme_file LEFT OUTER JOIN nml_file ON nme14 = nml01,nma_file,nmc_file,nmt_file,aza_file",          
                " WHERE (nme01 =nma01 AND nma43 ='Y' AND nmaacti ='Y' AND nma37 ='1')",
                "   AND ((nme22 <='04' AND nme23 ='2') OR ((nme22 ='05' OR nme22 ='06') AND nme23 ='01')",
                "    OR (nme22 ='07' AND (nme23 ='0' OR nme23 ='1' ) AND (nme25!='EMPL' or nme25 is null)))",
                "   AND (nme03 =nmc01 AND nmc03 ='2')",
                "   AND nme24 ='9' AND nmeacti ='Y'",
                "   AND nmt01 =nma39 AND nmt12 =aza78 AND nmtacti ='Y'",
                "   AND ",g_wc,
                " UNION ",
                "SELECT 'N',nme01,nma02,nme22,nme12,nme21,nme04,nma10,nme14,nml02,nme03,nmc02,nme25,nme13,nme16,nme05,nme23,nme15",
                "  FROM nme_file LEFT OUTER JOIN nml_file ON nme14 = nml01,nma_file,nmc_file,nmt_file,aza_file",      
                " WHERE (nme01 =nma01 AND nma43 ='Y' AND nmaacti ='Y' AND nma37 ='1')",
                "   AND (nme22 ='07' AND (nme23 ='0' OR nme23 ='1') AND nme25 ='EMPL')",
                "   AND (nme03 =nmc01)",
                "   AND nme24 ='9' AND nmeacti ='Y'",
                "   AND nmt01 =nma39 AND nmt12 =aza78 AND nmtacti ='Y'",
                "   AND ",g_wc
   END IF
#No.FUN-870067--end
   PREPARE p302_c_prepare FROM g_sql
   DECLARE p302_c CURSOR FOR p302_c_prepare
 
   CALL g_nme.clear()
   
   LET g_cnt = 1
   LET g_rec_b1 = 0
   
   FOREACH p302_c INTO g_nme[g_cnt].*,g_nme1[g_cnt].nme23,g_nme1[g_cnt].nme15  #單身 ARRAY 填充 --#No.FUN-870067
     IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
     END IF
     LET g_nme1[g_cnt].a     = g_nme[g_cnt].a    
     LET g_nme1[g_cnt].nme01 = g_nme[g_cnt].nme01        
     LET g_nme1[g_cnt].nma02 = g_nme[g_cnt].nma02        
     LET g_nme1[g_cnt].nme22 = g_nme[g_cnt].nme22        
     LET g_nme1[g_cnt].nme12 = g_nme[g_cnt].nme12        
     LET g_nme1[g_cnt].nme21 = g_nme[g_cnt].nme21        
     LET g_nme1[g_cnt].nme04 = g_nme[g_cnt].nme04        
     LET g_nme1[g_cnt].nma10 = g_nme[g_cnt].nma10        
     LET g_nme1[g_cnt].nme14 = g_nme[g_cnt].nme14        
     LET g_nme1[g_cnt].nml02 = g_nme[g_cnt].nml02        
     LET g_nme1[g_cnt].nme03 = g_nme[g_cnt].nme03        
     LET g_nme1[g_cnt].nme25 = g_nme[g_cnt].nme25        
     LET g_nme1[g_cnt].nme13 = g_nme[g_cnt].nme13        
     LET g_nme1[g_cnt].nme16 = g_nme[g_cnt].nme16          
     LET g_nme1[g_cnt].nme05 = g_nme[g_cnt].nme05
 
       
              
     LET g_cnt = g_cnt + 1
     
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
     
   END FOREACH
   CALL g_nme.deleteElement(g_cnt)
   CALL g_nme1.deleteElement(g_cnt)
   LET g_rec_b1=g_cnt -1
   
   WHILE TRUE
      INPUT ARRAY g_nme WITHOUT DEFAULTS FROM s_nme.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
 
        BEFORE ROW
          LET l_ac1= ARR_CURR()
          CALL cl_show_fld_cont()                   
        
        AFTER FIELD a
          IF cl_null(g_nme[l_ac1].a) THEN
             NEXT FIELD a
          END IF
          
        AFTER ROW
            LET l_ac1 = ARR_CURR()
 
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION controlg      
           CALL cl_cmdask()  
 
        ON ACTION accept
           CALL p302_insert_nps()
           LET INT_FLAG =1  
           EXIT INPUT
 
      END INPUT
      LET g_rec_b1=ARR_COUNT()
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         CLOSE WINDOW p302_p_w
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p302_insert_nps()
DEFINE i,j        LIKE type_file.num5
DEFINE l_nps      RECORD LIKE nps_file.*
DEFINE l_npt      RECORD LIKE npt_file.*
DEFINE l_nmc03    LIKE nmc_file.nmc03
 
 
   LET j=1
   CALL g_nps.clear()
   FOR i =1 TO g_nme1.getLength()
       IF g_nme[i].a ='Y' THEN
          LET g_str =g_nme1[i].nme21
          LET l_nps.nps01 = g_nme1[i].nme22 CLIPPED,'_',g_nme1[i].nme12 CLIPPED,'_',g_str.trim()            
          SELECT rtrim(ltrim(nmt09)) INTO l_nps.nps06 FROM nmt_file,nma_file WHERE nmt01 = nma39 AND nma01 = g_nme1[i].nme01          
          SELECT nma04 INTO l_nps.nps05 FROM nma_file WHERE nma01 = g_nme1[i].nme01          
          LET l_nps.nps12 =g_nme1[i].nme04          
          LET l_nps.nps16 =g_nme1[i].nme05
          LET l_nps.nps29 =g_nme1[i].nme15
          SELECT nmt09 INTO l_nps.nps18 FROM nmt_file,nma_file WHERE nmt01 = nma39 AND nma01 =g_nme1[i].nme01            
          SELECT nmt12 INTO l_nps.nps19 FROM nmt_file,nma_file WHERE nmt01 = nma39 AND nma01 =g_nme1[i].nme01
#No.FUN-870067--begin          
          IF g_aza.aza78 IS NOT NULL AND g_aza.aza78 = l_nps.nps19 THEN
             IF (g_nme1[i].nme22 ='01' OR g_nme1[i].nme22 ='03') AND g_nme1[i].nme25 ='EMPL' THEN
                LET l_nps.nps03 ='ACH-CR'
             END IF
             IF (g_nme1[i].nme22 ='01' OR g_nme1[i].nme22 ='03') AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='LTR'
             END IF
             IF (g_nme1[i].nme22 ='02' OR g_nme1[i].nme22 ='04') AND g_nme1[i].nme25 ='EMPL' THEN
                LET l_nps.nps03 ='ACH-CR'
             END IF
             IF (g_nme1[i].nme22 ='02' OR g_nme1[i].nme22 ='04') AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='ACH-CR'
             END IF
             IF (g_nme1[i].nme22 ='05' OR g_nme1[i].nme22 ='06') AND g_nme1[i].nme23 ='01' THEN
                LET l_nps.nps03 ='LTR'
             END IF
             IF g_nme1[i].nme22 ='07' AND g_nme1[i].nme23 ='01' AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='LTR'
             END IF
             IF g_nme1[i].nme22 ='07' AND g_nme1[i].nme25 ='EMPL' THEN
                LET l_nps.nps03 ='ACH-CR'
             END IF 
             IF g_nme1[i].nme22 ='07' OR g_nme1[i].nme23 ='0' AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='IAT'
             END IF                          
             LET l_nps.nps13 = g_nme1[i].nma10
             IF l_nps.nps03 = 'LTR' THEN             
                SELECT pmf03 INTO l_nps.nps07 FROM pmf_file WHERE pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti = 'Y'
                SELECT pmf04 INTO l_nps.nps08 FROM pmf_file WHERE pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti = 'Y'
                SELECT nmt02 INTO l_nps.nps09 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
                SELECT nmt06 INTO l_nps.nps10 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
                SELECT nmt07 INTO l_nps.nps11 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
                SELECT nmt13 INTO l_nps.nps26 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
                IF l_nps.nps26 = 'CN' THEN
                   LET l_nps.nps27 = 'OUR'
                END IF                                 
             END IF
             IF l_nps.nps03 ='ACH-CR' THEN
                #-----TQC-B90211---------
                #SELECT cqf03 INTO l_nps.nps07 FROM cqf_file WHERE cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti = 'Y'
                #SELECT cqf04 INTO l_nps.nps08 FROM cqf_file WHERE cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti = 'Y'
                #SELECT nmt02 INTO l_nps.nps09 FROM nmt_file,cqf_file WHERE nmt01 =cqf02 AND cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'
                #SELECT nmt06 INTO l_nps.nps10 FROM nmt_file,cqf_file WHERE nmt01 =cqf02 AND cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'
                #SELECT nmt07 INTO l_nps.nps11 FROM nmt_file,cqf_file WHERE nmt01 =cqf02 AND cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'
                #SELECT nmt13 INTO l_nps.nps26 FROM nmt_file,cqf_file WHERE nmt01 =cqf02 AND cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'                 
                #-----END TQC-B90211-----
             END IF 
             IF l_nps.nps03 = 'IAT' OR l_nps.nps03 = 'LTR' THEN            
                LET l_nps.nps14 =cl_getmsg('anm-801','2')         
             END IF    
          ELSE                       
             IF (g_nme1[i].nme22 ='01' OR g_nme1[i].nme22 ='03') AND g_nme1[i].nme25 ='EMPL' THEN
                LET l_nps.nps03 ='N03010'
             END IF
             IF (g_nme1[i].nme22 ='01' OR g_nme1[i].nme22 ='03') AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='N02031'
             END IF
             IF (g_nme1[i].nme22 ='02' OR g_nme1[i].nme22 ='04') AND g_nme1[i].nme25 ='EMPL' THEN
                LET l_nps.nps03 ='N03010'
             END IF
             IF (g_nme1[i].nme22 ='02' OR g_nme1[i].nme22 ='04') AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='N03020'
             END IF
             IF (g_nme1[i].nme22 ='05' OR g_nme1[i].nme22 ='06') AND g_nme1[i].nme23 ='01' THEN
                LET l_nps.nps03 ='N02031'
             END IF
             IF g_nme1[i].nme22 ='07' AND g_nme1[i].nme23 ='01' AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='N02031'
             END IF
             IF g_nme1[i].nme22 ='07' AND g_nme1[i].nme25 ='EMPL' THEN
                SELECT nmc03 INTO l_nmc03 FROM nmc_file WHERE nmc01 =g_nme1[i].nme03
                IF l_nmc03 ='2' THEN
                   LET l_nps.nps03 ='N03030'
                ELSE
                   LET l_nps.nps03 ='N03030'
                END IF
             END IF
             IF g_nme1[i].nme22 ='07' OR g_nme1[i].nme23 ='0' AND g_nme1[i].nme25 !='EMPL' THEN
                LET l_nps.nps03 ='N02020'
             END IF          
             IF l_nps.nps03 = 'N02031' OR l_nps.nps03 = 'N02041' THEN
                SELECT pmf03 INTO l_nps.nps07 FROM pmf_file WHERE pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti = 'Y'
                SELECT pmf04 INTO l_nps.nps08 FROM pmf_file WHERE pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti = 'Y'
                SELECT nmt02 INTO l_nps.nps09 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
                SELECT nmt06 INTO l_nps.nps10 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
                SELECT nmt07 INTO l_nps.nps11 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 =g_nme1[i].nme25 AND pmf05 ='Y' AND pmfacti ='Y'
             END IF
             IF l_nps.nps03 MATCHES 'N02*' THEN 
                LET l_nps.nps14 =cl_getmsg('anm-801','2')
             END IF
             SELECT azi02 INTO l_nps.nps13 FROM azi_file WHERE azi01 =g_nme1[i].nma10
          END IF
#No.FUN-870067--end                                      
          LET l_nps.nps17 ='9'
          INSERT INTO nps_file VALUES(l_nps.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","nps_file",l_nps.nps01,"",SQLCA.sqlcode,"","",1) 
             EXIT FOR 
          ELSE
             UPDATE nme_file SET nme24 ='5' WHERE nme12 =g_nme1[i].nme12 AND nme21 = g_nme1[i].nme21 AND nme22 = g_nme1[i].nme22
             LET g_nps[j].b     = 'N'
             LET g_nps[j].c     = 'N'
             LET g_nps[j].nps01 = l_nps.nps01
             LET g_nps[j].nps03 = l_nps.nps03
             LET g_nps[j].nps05 = l_nps.nps05
             LET g_nps[j].nps14 = l_nps.nps14
             LET g_nps[j].nps07 = l_nps.nps07
             LET g_nps[j].nps08 = l_nps.nps08
             LET g_nps[j].nps09 = l_nps.nps09
             LET g_nps[j].nps26 = l_nps.nps26      #No.FUN-870067
             LET g_nps[j].nps10 = l_nps.nps10
             LET g_nps[j].nps11 = l_nps.nps11
             LET g_nps[j].nps27 = l_nps.nps27      #No.FUN-870067
             LET g_nps[j].nps12 = l_nps.nps12
             LET g_nps[j].nps13 = l_nps.nps13
             LET g_nps[j].nps20 = l_nps.nps20
             LET g_nps[j].nps15 = l_nps.nps15
             LET g_nps[j].nps16 = l_nps.nps16
             LET g_nps[j].nps17 = l_nps.nps17
             IF g_nps[j].nps14 =cl_getmsg('anm-801','2') THEN
                LET g_nps[j].nps14 =1
             END IF
             IF g_nps[j].nps14 =cl_getmsg('anm-802','2') THEN
                LET g_nps[j].nps14 =2
             END IF
             SELECT nme13,nme22 INTO g_nps[j].nme13,g_nps[j].nme22 FROM nme_file 
             WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[j].nps01
             LET j=j+1
          END IF
#No.FUN-870067--begin          
          IF g_aza.aza78 IS NOT NULL AND g_aza.aza78 = l_nps.nps19 THEN          
             IF l_nps.nps03 ='ACH-CR' THEN
                LET l_npt.npt01 = l_nps.nps01
                #-----TQC-B90211---------
                #SELECT cqf03 INTO l_npt.npt03 FROM cqf_file WHERE cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'
                #SELECT cqf04 INTO l_npt.npt04 FROM cqf_file WHERE cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'              
                #-----END TQC-B90211-----
                LET l_npt.npt05 =g_nme1[i].nme04
                INSERT INTO npt_file VALUES(l_npt.*)
             END IF 
          ELSE       
             IF l_nps.nps03 MATCHES 'N03*' THEN
                LET l_npt.npt01 = l_nps.nps01
                #-----TQC-B90211---------
                #SELECT cqf03 INTO l_npt.npt03 FROM cqf_file WHERE cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'
                #SELECT cqf04 INTO l_npt.npt04 FROM cqf_file WHERE cqf01 =g_nme1[i].nme25 AND cqf05 ='Y' AND cqfacti ='Y'              
                #-----END TQC-B90211-----
                LET l_npt.npt05 =g_nme1[i].nme04
                INSERT INTO npt_file VALUES(l_npt.*)
             END IF             	
          END IF	
       END IF
   END FOR
   CALL g_nps.deleteElement(j)
   LET g_rec_b =j-1
END FUNCTION
 
FUNCTION p302_private()
DEFINE l_npt05         LIKE npt_file.npt05
DEFINE l_ac1_t         LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,                #檢查重復用    
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否    
       p_cmd           LIKE type_file.chr1,                #處理狀態      
       l_allow_insert  LIKE type_file.num5,                #可新增否      
       l_allow_delete  LIKE type_file.num5                 #可刪除否
DEFINE l_nme25         LIKE nme_file.nme25
   
 
    IF g_nps[l_ac].nps03 MATCHES 'N02*' THEN
       RETURN
    END IF

    OPEN WINDOW p302_p_w1 WITH FORM "anm/42f/anmp302_p"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    LET g_sql = "SELECT npt01,npt03,npt04,npt05,npt06",  
                "  FROM npt_file",
                " WHERE npt01 ='",g_nps[l_ac].nps01,"'",                     #單身
                " ORDER BY npt01,npt03"
    PREPARE p302_pt FROM g_sql
    DECLARE npt_curs CURSOR FOR p302_pt
   
    CALL g_npt.clear()
   
    LET g_cnt = 1
    MESSAGE "Searching!" 
   
    FOREACH npt_curs INTO g_npt[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF      
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
   
    CALL g_npt.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cnt2  
    LET g_cnt = 0
   
 
 
 
   LET g_forupd_sql = "SELECT npt01,npt03,npt04,npt05,npt06",  
                      "  FROM npt_file WHERE npt01 =? AND npt03 =? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p302_bcl1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
 
   INPUT ARRAY g_npt WITHOUT DEFAULTS FROM s_npt.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=TRUE,
                   APPEND ROW=TRUE)
            
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
         CALL cl_set_comp_entry("npt01",FALSE)
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac1 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'        
 
         IF g_rec_b2 >= l_ac1 THEN
            LET g_npt_t.* = g_npt[l_ac1].*  #BACKUP
            LET p_cmd='u'
            OPEN p302_bcl1 USING g_npt_t.npt01,g_npt_t.npt03
            IF STATUS THEN
               CALL cl_err("OPEN p302_bcl1:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH p302_bcl1 INTO g_npt[l_ac1].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_npt_t.npt01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL cl_show_fld_cont()   
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_npt[l_ac1].* TO NULL     
         LET g_npt_t.* = g_npt[l_ac1].*         #新輸入資料
         LET g_npt[l_ac1].npt01 =g_nps[l_ac].nps01
         LET g_before_input_done = FALSE                                    
         CALL cl_show_fld_cont()     
         NEXT FIELD npt03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         SELECT SUM(npt05) INTO l_npt05 FROM npt_file WHERE npt01 =g_nps[l_ac].nps01 AND npt03 <> g_npt[l_ac1].npt03
         IF cl_null(l_npt05) THEN
            LET l_npt05 =0
         END IF
         IF l_npt05+g_npt[l_ac1].npt05 > g_nps[l_ac].nps12 THEN 
            CALL cl_err(l_npt05+g_npt[l_ac1].npt05,'anm-812',1)
            LET g_npt[l_ac1].npt05 =g_npt_t.npt05
            NEXT FIELD npt05
         ELSE
            INSERT INTO npt_file(npt01,npt03,npt04,npt05,npt06)              
                 VALUES(g_npt[l_ac1].npt01,
                        g_npt[l_ac1].npt03,
                        g_npt[l_ac1].npt04,
                        g_npt[l_ac1].npt05,
                        g_npt[l_ac1].npt06)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","npt_file",g_npt[l_ac1].npt01,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cnt2  
            END IF
         END IF
 
      AFTER FIELD npt03
         IF p_cmd ='a' OR (p_cmd ='u' AND g_npt[l_ac1].npt03 <> g_npt_t.npt03) THEN
            SELECT COUNT(*) INTO l_n FROM npt_file WHERE npt01 =g_npt[l_ac1].npt01 AND npt03 =g_npt[l_ac1].npt03
            IF l_n >0 THEN 
               CALL cl_err(g_npt[l_ac1].npt03,'anm-911',1)
               LET g_npt[l_ac1].npt03 =g_npt_t.npt03
               NEXT FIELD npt03
            END IF
            LET l_n =0
            #-----TQC-B90211---------
            #SELECT cqf04 INTO g_npt[l_ac1].npt04 FROM cqf_file,nme_file
            # WHERE cqf03 = g_npt[l_ac1].npt03 AND cqfacti ='Y'
            #   AND cqf01 =nme25
            #   AND nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_npt[l_ac1].npt01
            #IF SQLCA.sqlcode ='-100' THEN
            #   CALL cl_err(g_npt[l_ac1].npt03,'anm-912',1)
            #   LET g_npt[l_ac1].npt03 =g_npt_t.npt03
            #   NEXT FIELD npt03
            #END IF 
            #-----END TQC-B90211----- 
         END IF
                  
      AFTER FIELD npt05
         IF p_cmd ='a' OR (p_cmd ='u' AND g_npt[l_ac1].npt05 <> g_npt_t.npt05) THEN
            SELECT SUM(npt05) INTO l_npt05 FROM npt_file WHERE npt01 =g_nps[l_ac].nps01 AND npt03 <> g_npt[l_ac1].npt03
            IF cl_null(l_npt05) THEN
               LET l_npt05 =0
            END IF
            IF (l_npt05+g_npt[l_ac1].npt05) > g_nps[l_ac].nps12 THEN 
               CALL cl_err(l_npt05+g_npt[l_ac1].npt05,'anm-913',1)
               LET g_npt[l_ac1].npt05 =g_npt_t.npt05
               NEXT FIELD npt05
            END IF               
         END IF
            
               
 
      BEFORE DELETE                            #是否取消單身 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
          
            DELETE FROM npt_file WHERE npt01 = g_npt_t.npt01 AND npt03 =g_npt_t.npt03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","npt_file",g_npt_t.npt01,"",SQLCA.sqlcode,"","",1)  
               CANCEL DELETE 
            END IF
 
            
            LET g_rec_b2=g_rec_b2-1
            DISPLAY g_rec_b2 TO FORMONLY.cnt2 
            MESSAGE "Delete OK"
            CLOSE p302_bcl1
 
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_npt[l_ac1].* = g_npt_t.*
            CLOSE p302_bcl1
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_npt[l_ac1].npt01,-263,1)
            LET g_npt[l_ac1].* = g_npt_t.*
         ELSE
            SELECT SUM(npt05) INTO l_npt05 FROM npt_file WHERE npt01 =g_nps[l_ac].nps01 AND npt03 <> g_npt[l_ac1].npt03
            IF cl_null(l_npt05) THEN
               LET l_npt05 =0
            END IF
            IF l_npt05+g_npt[l_ac1].npt05 > g_nps[l_ac].nps12 THEN 
               CALL cl_err(l_npt05+g_npt[l_ac1].npt05,'anm-812',1)
               LET g_npt[l_ac1].npt05 =g_npt_t.npt05
               NEXT FIELD npt05
            ELSE
               UPDATE npt_file SET
                     npt01 = g_npt[l_ac1].npt01,
                     npt03 = g_npt[l_ac1].npt03,
                     npt04 = g_npt[l_ac1].npt04,
                     npt05 = g_npt[l_ac1].npt05,
                     npt06 = g_npt[l_ac1].npt06
               WHERE npt01 =g_npt_t.npt01
                 AND npt03 =g_npt_t.npt03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","npt_file",g_npt_t.npt01,"",SQLCA.sqlcode,"","",1)  
                  LET g_npt[l_ac1].* = g_npt_t.*
               END IF
            END IF 
         END IF
 
      AFTER ROW
         LET l_ac1 = ARR_CURR()
         LET l_ac1_t = l_ac1
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_npt[l_ac1].* = g_npt_t.*
            END IF
            CLOSE p302_bcl
            EXIT INPUT
         END IF
         CLOSE p302_bcl
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(npt01) AND l_ac1 > 1 THEN
            LET g_npt[l_ac1].* = g_npt[l_ac1-1].*
            NEXT FIELD npt01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         IF INFIELD(npt03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_npt03"
            SELECT nme25 INTO l_nme25 FROM nme_file
             WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_npt[l_ac1].npt01
            LET g_qryparam.arg1=l_nme25
            LET g_qryparam.default1 = g_npt[l_ac1].npt03
            CALL cl_create_qry() RETURNING g_npt[l_ac1].npt03
            DISPLAY BY NAME g_npt[l_ac1].npt03
            NEXT FIELD npt03
         END IF  
 
 
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
 
      AFTER INPUT 
 
   END INPUT
   CLOSE p302_bcl1
   CLOSE WINDOW p302_p_w1
 
END FUNCTION
 
FUNCTION p302_landing()
DEFINE     l_channel              base.Channel
DEFINE     l_channel1             base.Channel
DEFINE     i,j                    LIKE type_file.num5
DEFINE     l_total                LIKE type_file.num5
DEFINE     l_total1               STRING
DEFINE     l_name                 LIKE type_file.chr1000 
DEFINE     l_name1                STRING 
DEFINE     l_name2                LIKE type_file.chr1000
DEFINE     l_sequ1                LIKE npu_file.npu03
DEFINE     l_sequ                 STRING
DEFINE     l_str                  STRING
DEFINE     l_syscode              LIKE nps_file.nps19
DEFINE     l_version              LIKE nmt_file.nmt11
DEFINE     l_sum1                 LIKE nps_file.nps12
DEFINE     l_sum                  STRING
DEFINE     l_type                 LIKE type_file.chr18
DEFINE     l_operator             LIKE zx_file.zx02
DEFINE     l_status               LIKE type_file.num10
DEFINE     l_nps                  RECORD LIKE nps_file.*
DEFINE     l_nps01                LIKE nps_file.nps01 
DEFINE     l_nps03                LIKE nps_file.nps03
DEFINE     l_nps05                LIKE nps_file.nps05 
DEFINE     l_nps06                LIKE nps_file.nps06 
DEFINE     l_nps07                LIKE nps_file.nps07 
DEFINE     l_nps08                LIKE nps_file.nps08 
DEFINE     l_nps09                LIKE nps_file.nps09 
DEFINE     l_nps26                LIKE nps_file.nps26    #No.FUN-870067
DEFINE     l_nps10                LIKE nps_file.nps10 
DEFINE     l_nps11                LIKE nps_file.nps11 
DEFINE     l_nps27                LIKE nps_file.nps27    #No.FUN-870067
DEFINE     l_nps12_1              LIKE nps_file.nps12
DEFINE     l_nps12                STRING
DEFINE     l_nps13                like nps_file.nps13 
DEFINE     l_nps14                like nps_file.nps14 
DEFINE     l_nps15                like nps_file.nps15 
DEFINE     l_nps16                like nps_file.nps16 
DEFINE     l_nps19                like nps_file.nps19
DEFINE     l_nps20                like nps_file.nps20
DEFINE     l_npt03                like npt_file.npt03
DEFINE     l_npk05                like npk_file.npk05
DEFINE     l_npt06                like npt_file.npt06
DEFINE     l_npt04                like npt_file.npt04
DEFINE     l_npu03                like npu_file.npu03
DEFINE     unix_path,window_path  STRING   
DEFINE     l_cmd                  STRING
DEFINE     l_n                    LIKE type_file.chr1
DEFINE     l_nmv                  RECORD LIKE nmv_file.*   #No.FUN-870067
DEFINE     l_total2               LIKE type_file.num5      #No.FUN-870067
DEFINE     l_count                LIKE type_file.num5      #No.FUN-870067
DEFINE     l_num                  LIKE type_file.num5      #No.FUN-870067
DEFINE     l_time                 LIKE type_file.chr8      #No.FUN-870067
DEFINE     l_fprNo                LIKE nps_file.nps01      #No.FUN-870067
DEFINE     l_fprNo1               LIKE nps_file.nps01      #No.FUN-870067
DEFINE     l_nmv06                LIKE nmv_file.nmv06      #No.FUN-870067
DEFINE     l_nmv09                LIKE nmv_file.nmv09      #No.FUN-870067
DEFINE     l_nmv10                LIKE nmv_file.nmv10      #No.FUN-870067
DEFINE     l_nmv12                LIKE nmv_file.nmv12      #No.FUN-870067
DEFINE     l_nmv15                LIKE nmv_file.nmv15      #No.FUN-870067
DEFINE     l_nmv16                LIKE nmv_file.nmv16      #No.FUN-870067
DEFINE     l_nmv17                LIKE nmv_file.nmv17      #No.FUN-870067
DEFINE     l_nmv19                LIKE nmv_file.nmv19      #No.FUN-870067
DEFINE     f_pmc01                LIKE pmc_file.pmc01      #No.FUN-870067
DEFINE     s_pmc01                LIKE pmc_file.pmc01      #No.FUN-870067
DEFINE     s_pmc03                LIKE pmc_file.pmc03      #No.FUN-870067
DEFINE     s_pmc081               LIKE pmc_file.pmc081     #No.FUN-870067
DEFINE     s_pmc082               LIKE pmc_file.pmc082     #No.FUN-870067
DEFINE     s_pmc22                LIKE pmc_file.pmc22      #No.FUN-870067
DEFINE     s_pmf06                LIKE pmf_file.pmf06      #No.FUN-870067
DEFINE     l_nmt02                LIKE nmt_file.nmt02      #No.FUN-870067
DEFINE     l_nmt04                LIKE nmt_file.nmt04      #No.FUN-870067
DEFINE     l_nmt05                LIKE nmt_file.nmt05      #No.FUN-870067
DEFINE     l_nma08                LIKE nma_file.nma08      #No.FUN-870067 
DEFINE     l_nme22                LIKE nme_file.nme22      #No.FUN-870067
DEFINE     l_pmf02                LIKE pmf_file.pmf02      #No.FUN-870067
#-----TQC-B90211---------
#DEFINE     l_cqf01                LIKE cqf_file.cqf01      #No.FUN-870067
#DEFINE     l_cqf01_t              LIKE cqf_file.cqf01      #No.FUN-870067
#DEFINE     l_cqf02                LIKE cqf_file.cqf02      #No.FUN-870067
#DEFINE     l_cqf06                LIKE cqf_file.cqf06      #No.FUN-870067
#DEFINE     l_cqf08                LIKE cqf_file.cqf08      #No.FUN-870067 
#DEFINE     l_cqf09                LIKE cqf_file.cqf09      #No.FUN-870067 
#-----END TQC-B90211----- 
DEFINE     l_gen02                LIKE gen_file.gen02      #No.FUN-870067
DEFINE     l_nmx03                LIKE nmx_file.nmx03      #No.FUN-870067
DEFINE     l_tot                  LIKE type_file.num5      #No.FUN-870067
DEFINE     l_tot2                 LIKE type_file.num5      #No.FUN-870067
DEFINE     l_tot3                 LIKE type_file.num5      #No.FUN-870067
DEFINE     l_chr                  STRING                   #No.FUN-870067
DEFINE     l_endchr               STRING                   #No.FUN-870067
DEFINE     l_company              LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_string1              STRING                   #No.FUN-870067
DEFINE     l_string2              STRING                   #No.FUN-870067
DEFINE     l_country              LIKE nps_file.nps26      #No.FUN-870067
DEFINE     l_company1             LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_company2             LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_company3             LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_company4             LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_address1             LIKE zo_file.zo041       #No.FUN-870067
DEFINE     l_address2             LIKE zo_file.zo042       #No.FUN-870067
DEFINE     l_cn                   LIKE type_file.num5      #No.FUN-870067
DEFINE     l_cnt                  LIKE type_file.num5      #No.FUN-870067
DEFINE     l_n2                   LIKE type_file.num5      #No.FUN-870067
DEFINE     l_n3                   LIKE type_file.num5      #No.FUN-870067
DEFINE     l_n4                   LIKE type_file.num5      #No.FUN-870067
DEFINE     l_amt                  LIKE nps_file.nps12      #No.FUN-870067
DEFINE     l_npt                  RECORD LIKE npt_file.*   #No.FUN-870067
DEFINE     l_paymentcode          LIKE nmx_file.nmx03      #No.FUN-870067
DEFINE     l_colum1               LIKE ze_file.ze03        #No.FUN-870067
DEFINE     l_colum2               LIKE ze_file.ze03        #No.FUN-870067
DEFINE     l_colum3               LIKE ze_file.ze03        #No.FUN-870067
DEFINE     l_colum4               LIKE ze_file.ze03        #No.FUN-870067
DEFINE     l_colum5               LIKE ze_file.ze03        #No.FUN-870067
DEFINE     l_empid                LIKE type_file.chr12     #No.FUN-870067
DEFINE     l_typeCode             LIKE type_file.chr3      #No.FUN-870067
DEFINE     l_bankinf1             LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_bankinf2             LIKE type_file.chr30     #No.FUN-870067
DEFINE     l_len1                 LIKE type_file.num5      #No.FUN-870067
DEFINE     l_len2                 LIKE type_file.num5      #No.FUN-870067
                                                                                                         
   DROP TABLE x
   LET g_flag ='N'
   FOR i =1 TO g_nps.getLength()
       IF g_nps[i].c ='Y' THEN
          LET g_flag ='Y'
          SELECT * FROM nps_file WHERE 1=2 INTO TEMP x
          INSERT INTO x SELECT * FROM nps_file WHERE nps01 =g_nps[i].nps01
          UPDATE x SET nps15 = g_nps[i].nps15  WHERE nps01 =g_nps[i].nps01
          IF SQLCA.sqlcode THEN                                                                                                  
             CALL cl_err('',SQLCA.sqlcode,1) 
             RETURN                                                                                
          END IF 
       END IF
   END FOR 
   IF g_flag ='N' THEN
      CALL cl_err('','anm-803',0)
      RETURN
   END IF
 
#No.FUN-870067--begin
    SELECT COUNT(*) INTO l_n2 FROM x WHERE nps19 = g_aza.aza78
      IF l_n2 >0 THEN 
#for public
         SELECT COUNT(*) INTO l_total FROM x WHERE nps03 MATCHES 'LTR' 
                         OR nps03 MATCHES 'IAT' OR nps03 MATCHES 'FTR'
         IF l_total >0 THEN
            SELECT npu03+1 INTO l_sequ1 FROM npu_file WHERE npu01 ='0' AND npu02 =TODAY 
            IF cl_null(l_sequ1) OR l_sequ1 =0 THEN
               LET l_sequ1 =1
            END IF
            LET l_sequ = l_sequ1 
            LET l_name = 'iFile_Local_HVP',TODAY USING 'YYMMDD','-',l_sequ.trim(),".txt"
            LET l_name1 =l_name CLIPPED 
            LET l_name2 =l_name CLIPPED
            LET l_channel = base.Channel.create()

            LET l_name = os.Path.join(FGL_GETENV('TEMPDIR') CLIPPED,l_name CLIPPED )
            CALL l_channel.openFile(l_name,"w" )
            LET l_cmd = "test -e ",l_name
            RUN l_cmd RETURNING l_n 
            IF l_n <> '0' THEN 
               CALL cl_err('','anm-809',0)
               RETURN
            END IF
            SELECT nmv06,nmv09,nmv10,nmv12,nmv15,nmv16,nmv17,nmv19
              INTO l_nmv06,l_nmv09,l_nmv10,l_nmv12,l_nmv15,l_nmv16,l_nmv17,l_nmv19
             FROM nmv_file
             WHERE nmv01 = g_aza.aza78
            SELECT COUNT(*) INTO l_tot FROM x WHERE nps19 = g_aza.aza78
            SELECT COUNT(*) INTO l_tot2 FROM npt_file,x WHERE npt01=nps01 AND nps19 = g_aza.aza78
            LET l_tot3 = l_tot2 + l_total 
            IF l_nmv19 = 'Y' THEN
                LET l_count = 1+l_tot * 1 + l_tot3*6
            ELSE
            	LET l_count = 1+l_tot * 1 + l_tot3*1
            END IF
            IF l_nmv15 = '1' THEN
               LET l_fprNo = l_nmv12 CLIPPED,TODAY USING "YYYYMMDD",'_',l_sequ.trim()
            END IF
            IF l_nmv15 = '2' THEN
               LET l_fprNo = l_nmv12 CLIPPED,TODAY USING "YYYYMM",'_',l_sequ.trim()
            END IF 
            IF l_nmv15 = '3' THEN
               LET l_fprNo = l_nmv12 CLIPPED,'_',l_sequ.trim()
            END IF               
            LET l_time = TIME
            IF g_aza.aza26 ='0' THEN   
               LET l_str ="IFH,IFILE,CSV,",l_nmv09 CLIPPED,",",l_nmv10 CLIPPED,",",l_fprNo CLIPPED,",",g_today USING "YYYY/MM/DD",",",l_time,",",l_nmv16 CLIPPED,",",
                           l_nmv17 CLIPPED,",",l_count USING "<<<<<",",BG51"
               CALL l_channel.writeline(l_str)
            END IF             
            IF g_aza.aza26 ='2' THEN   
               LET l_str ="IFH,IFILE,CSV,",l_nmv09 CLIPPED,",",l_nmv10 CLIPPED,",",l_fprNo CLIPPED,",",g_today USING "YYYY/MM/DD",",",l_time,",",l_nmv16 CLIPPED,",",
                           l_nmv17 CLIPPED,",",l_count USING "<<<<<"
               CALL l_channel.writeline(l_str)
            END IF
            DECLARE p302_p6 CURSOR FOR
               SELECT * FROM nmv_file,x
                WHERE nmv01 = nps19
                  AND nps19 =g_aza.aza78
                  AND nps03 != 'ACH-CR' 
                ORDER BY nps03 DESC   
            FOREACH p302_p6 INTO  l_nmv.*,l_nps.* 
               IF SQLCA.sqlcode THEN                                                                                                  
                  CALL cl_err('',SQLCA.sqlcode,1) 
                  RETURN                                                                                
               END IF 
               LET l_num = l_sequ.trim()
               IF l_nmv15 = '1' THEN
                  LET l_fprNo1 = l_nmv12 CLIPPED,TODAY USING "YYYYMMDD",'_',l_sequ.trim() 
               END IF
               IF l_nmv15 = '2' THEN
                  LET l_fprNo1 = l_nmv12 CLIPPED,TODAY USING "YYYYMM",'_',l_sequ.trim() 
               END IF 
               IF l_nmv15 = '3' THEN
                  LET l_fprNo1 = l_nmv12 CLIPPED,'_',l_sequ.trim() 
               END IF
               IF g_aza.aza26 ='0' THEN
                  LET l_nps.nps12 = cl_digcut(l_nps.nps12,0)
               END IF               
               LET l_chr= l_nps.nps12 USING '-------------------------&.&&'
               SELECT zo07,zo041,zo042 INTO l_company,l_address1,l_address2 FROM zo_file WHERE zo01 = g_lang
               IF g_aza.aza26 = '0' THEN
                  IF l_nps.nps13 != g_aza.aza17 THEN               #當為外幣交易支付時
                     SELECT zo07,zo041,zo042 INTO l_company,l_address1,l_address2 FROM zo_file WHERE zo01 ='1'
                     LET l_country='TW'
                  ELSE
                  	 LET l_country=l_nps.nps26       
                  END IF               
                  LET l_company1=NULL
                  LET l_company2=NULL
                  LET l_company3=NULL
                  LET l_company4=NULL
                  
               ELSE
               	  LET l_country=l_nps.nps26
                  LET l_string1 = l_address1
                  LET l_string2 = l_address2
                  LET l_company1 = l_string1.subString(1,22)
                  LET l_company2 = l_string1.subString(23,l_string1.getLength())
                  LET l_company3 = l_string2.subString(1,22)
                  LET l_company4 = l_string2.subString(23,l_string2.getLength())               
               END IF
               LET l_str="BATHDR,",l_nps.nps03 CLIPPED,",1,,,,,,,@1ST@,",TODAY USING "YYYYMMDD",",",
                         l_nps.nps05 CLIPPED,",",l_nps.nps13 CLIPPED,",",l_chr.trim(),",,,",l_country CLIPPED,",HBAP,",
                         g_aza.aza17 CLIPPED,",,",l_company CLIPPED,",",l_company1 CLIPPED,",",l_company2 CLIPPED,",",l_company3 CLIPPED,",",l_company4 CLIPPED,
                         ",,",l_fprNo CLIPPED
               CALL l_channel.writeline(l_str)
               SELECT pmc01,pmc03,pmc081,pmc082,pmc22,pmf06 
                 INTO s_pmc01,s_pmc03,s_pmc081,s_pmc082,s_pmc22,s_pmf06
                 FROM pmc_file,pmf_file
                WHERE pmf01 = pmc01
                  AND pmf03 = l_nps.nps07
               IF g_aza.aza26 = '0' THEN
                  LET l_string1 = s_pmc081
                  LET l_len1=l_string1.getLength()
                  CASE WHEN l_len1>105
                            LET l_company1 = l_string1.subString(1,35)
                            LET l_company2 = l_string1.subString(36,l_string1.getLength()-70)
                            LET l_company3 = l_string1.subString(71,l_string1.getLength()-105)
                            LET l_company4 = l_string1.subString(106,l_string1.getLength())                  
                       WHEN 71<l_len1<105
                            LET l_company1 = l_string1.subString(1,35)
                            LET l_company2 = l_string1.subString(36,l_string1.getLength()-70)
                            LET l_company3 = l_string1.subString(71,l_string1.getLength())
                            LET l_company4 = NULL                            
                       WHEN 35<l_len1<70
                            LET l_company1 = l_string1.subString(1,35)
                            LET l_company2 = l_string1.subString(36,l_string1.getLength())
                            LET l_company3 = NULL
                            LET l_company4 = NULL                      
                       WHEN l_len1<=35
                            LET l_company1 = l_string1.subString(1,l_len1)
                            LET l_company2 = NULL
                            LET l_company3 = NULL
                            LET l_company4 = NULL
                  OTHERWISE EXIT CASE                            
                  END CASE                   
               END IF                                
               IF l_nps.nps13 != g_aza.aza17 THEN               #當為外幣交易支付時
                  SELECT nmt04,nmt05 INTO l_nmt04,l_nmt05 FROM nmt_file,pmf_file
                   WHERE nmt01 = pmf02
                     AND pmf03 = l_nps.nps07
               ELSE
               	  LET l_nmt04=NULL
               	  LET l_nmt05=NULL
               END IF   
               SELECT pmf02,nmt02 INTO l_pmf02,l_nmt02 FROM nmt_file,pmf_file
                WHERE nmt01 = pmf02
                  AND pmf03 = l_nps.nps07
               IF g_aza.aza26 = '0' THEN
                  LET l_nps.nps12 = cl_digcut(l_nps.nps12,0) 
                  LET l_chr=l_nps.nps12 USING '-------------------------&.&&'
                  IF l_nps.nps13 != g_aza.aza17 THEN 
                      LET l_nmt04 = 'SWF'
                      LET l_bankinf1='/REC/ CBC 121'
                      LET l_bankinf2='/REC/ Rate4.1 Jack'
                      LET l_endchr=",,,,,,,",l_bankinf1 CLIPPED,",",l_bankinf2 CLIPPED
                  ELSE    
                      LET l_nmt04 = 'BCD'
                      LET l_endchr= NULL
                  END IF
                  LET l_str="SECPTY,",l_nps.nps07 CLIPPED,",",l_company1 CLIPPED,",,,,,",l_chr.trim(),",,,",l_company2 CLIPPED,",",l_company3 CLIPPED,
                            ",",l_company4 CLIPPED,",,",l_nmv.nmv19,",N,,,,,,@HVP@,,",l_nps.nps13 CLIPPED,",,,,,,,,,,,",l_nmt04 CLIPPED,",",l_nmt05 CLIPPED,",,,,,,",
                            l_nps.nps26 CLIPPED,",,",l_nps.nps15 CLIPPED,",",l_nps.nps16 CLIPPED,",,,",l_nps.nps27 CLIPPED,l_endchr CLIPPED
                  CALL l_channel.writeline(l_str)               
               END IF 
               IF g_aza.aza26 = '2' THEN
                  LET l_chr=l_nps.nps12 USING '-------------------------&.&&'  
                  LET l_str="SECPTY,",l_nps.nps07 CLIPPED,",",s_pmc03 CLIPPED,",,,,,",l_chr.trim(),",,,",s_pmc081 CLIPPED,",",s_pmc082 CLIPPED,
                            ",,,",l_nmv.nmv19,",N,,,,,,@HVP@,,",l_nps.nps13 CLIPPED,",,,,,,,,,,,",l_nmt04 CLIPPED,",",l_nmt05 CLIPPED,",",l_nmt02 CLIPPED,",,,,,",
                            l_nps.nps26 CLIPPED,",,",l_nps.nps15 CLIPPED,",",l_nps.nps16 CLIPPED,",,,",l_nps.nps27 CLIPPED
                  CALL l_channel.writeline(l_str)
               END IF   
               IF l_nmv.nmv19 = 'Y' THEN
                  SELECT nma08 INTO l_nma08 FROM nma_file WHERE nma04 = l_nps.nps07
                  LET l_str="ADV,,,,,,,1,1,",l_nma08 CLIPPED,",M,,,,,,F,",l_nmv.nmv19 CLIPPED,",",l_nmv.nmv20 CLIPPED,",",
                            s_pmf06 CLIPPED,",,",l_nps.nps26 CLIPPED
                  CALL l_channel.writeline(l_str)
                  IF l_nps.nps15 IS NOT NULL AND l_nps.nps16 IS NOT NULL THEN
                     LET l_str="ADV-FREETXT,1,,,,",l_nps.nps15 CLIPPED
                     CALL l_channel.writeline(l_str)
                     LET l_str="ADV-FREETXT,2,,,,",l_nps.nps16 CLIPPED
                     CALL l_channel.writeline(l_str)
                  END IF
                  IF g_aza.aza26 = '0' THEN
                     IF l_nps.nps13 != g_aza.aza17 THEN                 
                        SELECT ze03 INTO l_colum1 FROM ze_file WHERE ze01 = 'anm-163' AND ze02 = '1'
                        SELECT ze03 INTO l_colum2 FROM ze_file WHERE ze01 = 'anm-164' AND ze02 = '1'
                        SELECT ze03 INTO l_colum3 FROM ze_file WHERE ze01 = 'anm-165' AND ze02 = '1'
                        SELECT ze03 INTO l_colum4 FROM ze_file WHERE ze01 = 'anm-166' AND ze02 = '1'
                        SELECT ze03 INTO l_colum5 FROM ze_file WHERE ze01 = 'anm-167' AND ze02 = '1'
                     ELSE
                        SELECT ze03 INTO l_colum1 FROM ze_file WHERE ze01 = 'anm-163' AND ze02 = g_lang
                        SELECT ze03 INTO l_colum2 FROM ze_file WHERE ze01 = 'anm-164' AND ze02 = g_lang
                        SELECT ze03 INTO l_colum3 FROM ze_file WHERE ze01 = 'anm-165' AND ze02 = g_lang
                        SELECT ze03 INTO l_colum4 FROM ze_file WHERE ze01 = 'anm-166' AND ze02 = g_lang
                        SELECT ze03 INTO l_colum5 FROM ze_file WHERE ze01 = 'anm-167' AND ze02 = g_lang                    	
                     END IF	   
                  ELSE
                     SELECT ze03 INTO l_colum1 FROM ze_file WHERE ze01 = 'anm-163' AND ze02 = g_lang
                     SELECT ze03 INTO l_colum2 FROM ze_file WHERE ze01 = 'anm-164' AND ze02 = g_lang
                     SELECT ze03 INTO l_colum3 FROM ze_file WHERE ze01 = 'anm-165' AND ze02 = g_lang
                     SELECT ze03 INTO l_colum4 FROM ze_file WHERE ze01 = 'anm-166' AND ze02 = g_lang
                     SELECT ze03 INTO l_colum5 FROM ze_file WHERE ze01 = 'anm-167' AND ze02 = g_lang                  	    
                  END IF   
                  LET l_str="ADV-TBLTXT,5,10,L,",l_colum1 CLIPPED,",10,L,",l_colum2 CLIPPED,",15,R,",l_colum3 CLIPPED,
                            ",20,L,",l_colum4 CLIPPED,",20,L,",l_colum5 CLIPPED
                  CALL l_channel.writeline(l_str)                         
                  LET l_str="ADV-TBLBDY,",s_pmc01 CLIPPED,",10,",l_nps.nps13 CLIPPED,",10,",l_chr.trim(),",15,",l_nps.nps16 CLIPPED,",20,",l_nps.nps15 CLIPPED,",20,"
                  CALL l_channel.writeline(l_str)                          
                                       
               END IF                  
            END FOREACH 
            #大陸支付時,要求產生PP的同時也可生成ACH-CR的內容 
            IF g_aza.aza26 = '2' THEN
               SELECT COUNT(*) INTO l_n2 FROM x WHERE nsp19 = g_aza.aza78 AND nps03= 'ACH-CR'    
               IF l_n2 > 0 THEN
                  LET j = 0                                 
                  DECLARE p302_p12 CURSOR FOR
                     SELECT * FROM nmv_file,x
                      WHERE nmv01 = nps19
                        AND nps19 IN (SELECT nps19 FROM x)
                        AND nps03 ='ACH-CR'
                      ORDER BY nps03 DESC
                  FOREACH p302_p12 INTO  l_nmv.*,l_nps.* 
                     IF SQLCA.sqlcode THEN                                                                                                  
                        CALL cl_err('',SQLCA.sqlcode,1) 
                        RETURN                                                       
                     END IF
                     SELECT nmv06,nmv09,nmv10,nmv12,nmv16,nmv17,nmv19
                       INTO l_nmv06,l_nmv09,l_nmv10,l_nmv12,l_nmv16,l_nmv17,l_nmv19
                       FROM nmv_file
                      WHERE nmv01 = g_aza.aza78              
                     SELECT SUM(npt05) INTO l_amt FROM npt_file 
                      WHERE npt01 = l_nps.nps01
                     LET l_chr= l_amt USING '-------------------------&.&&' 
                     SELECT COUNT(*) INTO l_cnt FROM nmx_file 
                      WHERE nmx01 =g_aza.aza78 AND nmx02 = l_nmv06
                        AND nmx05 = 'N'
                     IF l_cnt > 0 THEN
                        SELECT nmx03 INTO l_paymentcode FROM nmx_file 
                         WHERE nmx06 IN (SELECT MIN(nmx06) FROM nmx_file WHERE nmx05='N')
                     ELSE
                     	  CALL cl_err('','anm-125',0)
                        RETURN
                     END IF                    
                     SELECT zo07 INTO l_company FROM zo_file WHERE zo01 = g_lang
                     SELECT COUNT(*) INTO l_n4 FROM npt_file WHERE npt01 = l_nps.nps01                      
                     LET l_fprNo1 = l_nmv12 CLIPPED,TODAY USING "YYYYMMDD",'_',l_sequ.trim()                
                     LET l_str="BATHDR,ACH-CR,",l_n4 USING "<<<<<",",",l_nmv12,"ACR,,,,,,@1ST@,",TODAY USING"YYYYMMDD",",",l_nps.nps05 CLIPPED,",",
                               l_nps.nps13 CLIPPED,",",l_chr.trim(),",,,,,,,",l_company CLIPPED,",,,,,",l_paymentcode CLIPPED,",",l_fprNo CLIPPED
                     CALL l_channel.writeline(l_str)         
                     DECLARE p302_p11 CURSOR FOR
                     SELECT * FROM npt_file
                      WHERE npt01 = l_nps.nps01 
                     FOREACH p302_p11 INTO l_npt.*                                                
                         #-----TQC-b90211---------
                         #SELECT cqf01,gen02,cqf02,cqf06 INTO l_cqf01,l_gen02,l_cqf02,l_cqf06 FROM gen_file,cqf_file
                         # WHERE cqf01 = gen01
                         #   AND cqf03 = l_npt.npt03
                         #SELECT nmt02 INTO l_nmt02 FROM nmt_file WHERE nmt01 = l_cqf02 
                         #-----END TQC-B90211-----
                         LET l_chr= l_npt.npt05 USING '-------------------------&.&&'                       
                         #-----TQC-B90211---------
                         #IF l_empid IS NULL OR l_cqf01!=l_cqf01_t THEN   
                         #   LET l_empid=l_cqf01                         
                         #ELSE
                         #	 LET j = j+1
                         #	 LET l_empid=l_cqf01 CLIPPED,"_",j USING"<<<<<"   
                         #END IF                      
                         IF l_empid IS NULL THEN   
                            LET l_empid=''                         
                         ELSE
                         	 LET j = j+1
                         	 LET l_empid='' CLIPPED,"_",j USING"<<<<<"   
                         END IF                      
                         #-----END TQC-B90211----- 
                         LET l_str="SECPTY,",l_npt.npt03 CLIPPED,",",l_gen02 CLIPPED,",",l_empid CLIPPED,",,,,",l_chr.trim(),",,,",l_nmv.nmv11,",",l_nps.nps15 CLIPPED,
                                   ",",l_nmt02 CLIPPED,",,",l_nmv.nmv19,",N"
                         CALL l_channel.writeline(l_str) 
                         #LET l_cqf01_t = l_cqf01    #TQC-B90211                                            
                         IF l_nmv.nmv19 = 'Y' THEN
                            LET l_str="ADV,,,,,,,1,1,",l_gen02 CLIPPED,",M,,,,,,F,",l_nmv.nmv19 CLIPPED,",",l_nmv.nmv20 CLIPPED,",",
                                      #l_cqf06 CLIPPED,",,CN"   #TQC-B90211                                                       
                                      '' CLIPPED,",,CN"   #TQC-B90211                                                       
                            CALL l_channel.writeline(l_str)
                            IF l_nps.nps15 IS NOT NULL AND l_nps.nps16 IS NOT NULL THEN
                               LET l_str="ADV-FREETXT,1,,,,",l_nps.nps15 CLIPPED
                               CALL l_channel.writeline(l_str)
                               LET l_str="ADV-FREETXT,2,,,,",l_nps.nps16 CLIPPED
                               CALL l_channel.writeline(l_str)
                            END IF                                                                             
                         END IF
                     END FOREACH                                        
                  END FOREACH
               END IF
            END IF          
#               UPDATE nps_file SET nps17 ='0',nps25 =l_name2,nps23 =TODAY
#                WHERE nps01 =l_nps.nps01
#               UPDATE nme_file SET nme24 ='0',nme02 =TODAY
#                WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21))=l_nps.nps01                 
            CALL l_channel.close()
            LET l_cmd = "test -s ",l_name
            RUN l_cmd RETURNING l_n 
            IF l_n <> '0' THEN 
               CALL cl_err('','anm-809',0)
               RETURN 
            END IF         
            UPDATE npu_file SET npu03 = l_sequ1 WHERE npu01 ='0' AND npu02 =TODAY 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               INSERT INTO npu_file VALUES('0',TODAY,l_sequ1)
            END IF

            LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),l_name1 CLIPPED)   #FUN-9C0008
            IF os.Path.separator() = "/" THEN   #FOR UNIX專用    #NO.FUN-A30035
               LET l_cmd ="unix2dos <",unix_path,"> $TEMPDIR/landing_tmp"
               RUN l_cmd
               IF g_aza.aza26 = '2' THEN 
                  LET l_cmd = "big5_to_gb2312.lux <$TEMPDIR/landing_tmp >",unix_path 
                  RUN l_cmd
               END IF                
            END IF                                               #NO.FUN-A30035 

            LET window_path = "c:\\tiptop\\",l_name1
            LET status = cl_download_file(unix_path,window_path) 
            IF status THEN 
               CALL cl_err('','anm-810',0)
            ELSE
               CALL cl_err('','anm-809',0)
            END IF                          
         END IF 
#for private
         SELECT COUNT(*) INTO l_total2 FROM x WHERE nps03 = 'ACH-CR' AND nps19 = g_aza.aza78
         IF l_total2 >0 THEN
            LET j = 0 
            SELECT npu03+1 INTO l_sequ1 FROM npu_file WHERE npu01 ='0' AND npu02 =TODAY 
            IF cl_null(l_sequ1) OR l_sequ1 =0 THEN
               LET l_sequ1 =1
            END IF
            LET l_sequ = l_sequ1 
            LET l_name = 'ACH_Payment',TODAY USING 'YYMMDD','-',l_sequ.trim(),".txt"
            LET l_name1 =l_name CLIPPED 
            LET l_name2 =l_name CLIPPED
            LET l_channel = base.Channel.create()

            LET l_name = os.Path.join(FGL_GETENV('TEMPDIR') CLIPPED,l_name CLIPPED )
            CALL l_channel.openFile(l_name,"w" )
            LET l_cmd = "test -e ",l_name
            RUN l_cmd RETURNING l_n 
            IF l_n <> '0' THEN 
               CALL cl_err('','anm-809',0)
               RETURN 
            END IF
            SELECT nmv06,nmv09,nmv10,nmv12,nmv16,nmv17,nmv19
              INTO l_nmv06,l_nmv09,l_nmv10,l_nmv12,l_nmv16,l_nmv17,l_nmv19
             FROM nmv_file
             WHERE nmv01 = g_aza.aza78 
            SELECT COUNT(*) INTO l_n3 FROM x,npt_file
             WHERE nps01=npt01 AND nps19 = g_aza.aza78
               AND nps03 = 'ACH-CR'       
            IF l_nmv19 = 'Y' THEN
                LET l_count = 1+l_total2 * 1+l_n3*4
            ELSE
            	  LET l_count = 1+l_total2 * 1+l_n3*1
            END IF
            SELECT COUNT(*) INTO l_cnt FROM nmx_file 
             WHERE nmx01 =g_aza.aza78 AND nmx02 = l_nmv06
               AND nmx05 = 'N'
            IF l_cnt > 0 THEN
               SELECT nmx03 INTO l_paymentcode FROM nmx_file 
                WHERE nmx06 IN (SELECT MIN(nmx06) FROM nmx_file WHERE nmx05='N')
            ELSE
            	 CALL cl_err('','anm-125',0)
               RETURN     
            END IF            
            LET l_fprNo = l_nmv12 CLIPPED,TODAY USING "YYYYMMDD",'_',l_sequ.trim()
            LET l_time = TIME    
            LET l_str ="IFH,IFILE,CSV,",l_nmv09 CLIPPED,",",l_nmv10 CLIPPED,",",l_fprNo CLIPPED,",",g_today USING "YYYY/MM/DD",",",l_time,",",l_nmv16 CLIPPED,",",
                       l_nmv17 CLIPPED,",",l_count USING "<<<<<"
            CALL l_channel.writeline(l_str)
            LET l_num = l_sequ.trim()           
            DECLARE p302_p7 CURSOR FOR
               SELECT * FROM nmv_file,x
                WHERE nmv01 = nps19
                  AND nps19 IN (SELECT nps19 FROM x)
                  AND nps03 = 'ACH-CR'
            FOREACH p302_p7 INTO  l_nmv.*,l_nps.*
               SELECT SUM(npt05) INTO l_amt FROM npt_file 
                WHERE npt01 = l_nps.nps01
               LET l_chr= l_amt USING '-------------------------&.&&'
               IF g_aza.aza26 = '0' THEN  
                  SELECT zo06 INTO l_company FROM zo_file WHERE zo01 = g_lang
               ELSE
                  SELECT zo07 INTO l_company FROM zo_file WHERE zo01 = g_lang               	
               END IF	    
               SELECT COUNT(*) INTO l_n4 FROM npt_file WHERE npt01 = l_nps.nps01
               IF g_aza.aza26 = '0' THEN
                  LET l_fprNo1 = l_nmv12 CLIPPED,TODAY USING "YYMMDD",l_sequ.trim()
                  IF cl_null(l_nps.nps29) THEN
                     LET l_nps.nps29 = '00000'
                  END IF 
                  LET l_typeCode='101'    
                  LET l_str="BATHDR,ACH-CR,",l_n4 USING "<<<<<",",",l_nmv12,"ACR,,,,,,@1ST@,",TODAY USING"YYYYMMDD",",",l_nps.nps05 CLIPPED,",",
                            l_nps.nps13 CLIPPED,",",l_chr.trim(),",,,",l_nps.nps26 CLIPPED,",HBAP,",l_nps.nps13 CLIPPED,",,,",l_company CLIPPED,",,,,",l_nps.nps29 CLIPPED,",",l_fprNo1 CLIPPED,
                            ",",l_typeCode CLIPPED
                  CALL l_channel.writeline(l_str)               	  
               END IF
               IF g_aza.aza26 = '2' THEN                
                  LET l_fprNo1 = l_nmv12 CLIPPED,TODAY USING "YYYYMMDD",'_',l_sequ.trim()
                  LET l_str="BATHDR,ACH-CR,",l_n4 USING "<<<<<",",",l_nmv12,"ACR,,,,,,@1ST@,",TODAY USING"YYYYMMDD",",",l_nps.nps05 CLIPPED,",",
                            l_nps.nps13 CLIPPED,",",l_chr.trim(),",,,,,,,,",l_company CLIPPED,",,,,,",l_paymentcode CLIPPED,",",l_fprNo1 CLIPPED
                  CALL l_channel.writeline(l_str)
               END IF
               DECLARE p302_p10 CURSOR FOR
                SELECT * FROM npt_file
                 WHERE npt01 = l_nps.nps01
               FOREACH p302_p10 INTO  l_npt.*                         
                  #-----TQC-B90211---------
                  #SELECT cqf01,gen02,cqf02,cqf06,cqf08,cqf09 INTO l_cqf01,l_gen02,l_cqf02,l_cqf06,l_cqf08,l_cqf09 FROM gen_file,cqf_file
                  # WHERE cqf01 = gen01
                  #   AND cqf03 = l_npt.npt03
                  #SELECT nmt02 INTO l_nmt02 FROM nmt_file
                  # WHERE nmt01 = l_cqf02 
                  #-----END TQC-B90211-----
                  LET l_chr= l_npt.npt05 USING '-------------------------&.&&'	
                  #-----TQC-B90211---------
                  #IF l_empid IS NULL OR l_cqf01!=l_cqf01_t THEN   
                  #   LET l_empid=l_cqf01
                  #ELSE
                  #	 LET j = j+1
                  #	 LET l_empid=l_cqf01 CLIPPED,"_",j USING"<<<<<"   
                  #END IF
                  IF l_empid IS NULL THEN   
                     LET l_empid=''
                  ELSE
                  	 LET j = j+1
                  	 LET l_empid='' CLIPPED,"_",j USING"<<<<<"   
                  END IF
                  #-----END TQC-B90211-----
                  IF g_aza.aza26 ='0' THEN
                     LET l_nmt02 = NULL
                     #LET l_str="SECPTY,",l_npt.npt03 CLIPPED,",,",l_cqf08 CLIPPED,",",l_cqf02 CLIPPED,",,,",l_chr.trim(),",",TODAY USING "YYYYMMDD",",",l_nps.nps15 CLIPPED,   #TQC-B90211
                     LET l_str="SECPTY,",l_npt.npt03 CLIPPED,",,",'' CLIPPED,",",'' CLIPPED,",,,",l_chr.trim(),",",TODAY USING "YYYYMMDD",",",l_nps.nps15 CLIPPED,   #TQC-B90211
                               ",,,,",l_nmt02 CLIPPED,",",l_nmv.nmv19,",N"
                     CALL l_channel.writeline(l_str)
                  ELSE
                     LET l_str="SECPTY,",l_npt.npt03 CLIPPED,",",l_gen02 CLIPPED,",",l_empid CLIPPED,",,,,",l_chr.trim(),",,,",l_nmv.nmv11,",",l_nps.nps15 CLIPPED,
                               ",",l_nmt02 CLIPPED,",,",l_nmv.nmv19,",N"
                     CALL l_channel.writeline(l_str)                 	    
                  END IF
                  #LET l_cqf01_t = l_cqf01                          #TQC-B90211
                  IF l_nmv.nmv19 = 'Y' THEN
                     IF g_aza.aza26 = '0' THEN
                        #LET l_gen02=l_cqf09   #TQC-B90211
                        LET l_gen02=''   #TQC-B90211
                     END IF
                     LET l_str="ADV,,,,,,,1,1,",l_gen02 CLIPPED,",M,,,,,,F,",l_nmv.nmv19 CLIPPED,",",l_nmv.nmv20 CLIPPED,",",
                               #l_cqf06 CLIPPED,",,",l_nps.nps26 CLIPPED   #TQC-B90211
                               '' CLIPPED,",,",l_nps.nps26 CLIPPED   #TQC-B90211
                     CALL l_channel.writeline(l_str)
                     IF l_nps.nps15 IS NOT NULL AND l_nps.nps16 IS NOT NULL THEN
                        LET l_str="ADV-FREETXT,1,,,,",l_nps.nps15 CLIPPED
                        CALL l_channel.writeline(l_str)
                        LET l_str="ADV-FREETXT,2,,,,",l_nps.nps16 CLIPPED
                        CALL l_channel.writeline(l_str)
                     END IF                     
                  END IF
               END FOREACH                                          
#               UPDATE nps_file SET nps17 ='0',nps25 =l_name2,nps23 =TODAY
#                WHERE nps01 =l_nps.nps01
#               UPDATE nme_file SET nme24 ='0',nme02 =TODAY
#                WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21))=l_nps.nps01
#               UPDATE nmv_file SET nmv13 = l_fprNo1,nmv14 = g_today WHERE nmv01 = g_aza.aza78                                   
            END FOREACH
            CALL l_channel.close()
            LET l_cmd = "test -s ",l_name
            RUN l_cmd RETURNING l_n 
            IF l_n <> '0' THEN 
               CALL cl_err('','anm-809',0)
               RETURN 
            END IF         
            UPDATE npu_file SET npu03 = l_sequ1 WHERE npu01 ='0' AND npu02 =TODAY 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               INSERT INTO npu_file VALUES('0',TODAY,l_sequ1)
            END IF

            LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),l_name1 CLIPPED)     #FUN-9C0008
            IF os.Path.separator() = "/" THEN    #FOR UNIX   #NO.FUN-A30035
               LET l_cmd ="unix2dos <",unix_path,"> $TEMPDIR/landing_tmp"
               RUN l_cmd            
               IF g_aza.aza26 = '2' THEN
                  LET l_cmd = "big5_to_gb2312.lux <$TEMPDIR/landing_tmp >",unix_path 
                  RUN l_cmd
               END IF                                        #NO.FUN-A30035
            END IF  

            LET window_path = "c:\\tiptop\\",l_name1
            LET status = cl_download_file(unix_path,window_path) 
            IF status THEN 
               CALL cl_err('','anm-810',0)
            ELSE
               CALL cl_err('','anm-809',0)
            END IF        
         END IF
         IF l_paymentcode IS NOT NULL THEN
            UPDATE nmx_file SET nmx05 = 'Y' 
             WHERE nmx01 = g_aza.aza78 
               AND nmx02 = l_nmv.nmv06 
               AND nmx03 = l_paymentcode 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('','anm-291',0)
               RETURN
            END IF
         END IF
         CALL p302_ftp()                     
      ELSE
#No.FUN-870067--end   	 	
#for public
         SELECT COUNT(*) INTO l_total FROM x WHERE nps03 MATCHES 'N02*' 
         IF l_total >0 THEN 
            DECLARE p302_p5 CURSOR FOR
               SELECT nps19,nmt11 FROM nps_file,nmt_file 
                WHERE nps19 = nmt12
                  AND nps03 LIKE 'N02%' 
                  AND nps01 IN(SELECT nps01 FROM x)
                GROUP BY nps19,nmt11
            FOREACH p302_p5 INTO l_syscode,l_version 
               SELECT npu03+1 INTO l_sequ1 FROM npu_file WHERE npu01 ='1' AND npu02 =TODAY 
               IF cl_null(l_sequ1) OR l_sequ1 =0 THEN
                  LET l_sequ1 =1
               END IF 
               LET l_sequ = l_sequ1
               LET l_name = TODAY USING 'YYMMDD','-',l_sequ.trim(),".pam"
               LET l_name1 =l_name CLIPPED 
               LET l_name2 =l_name CLIPPED
               LET l_channel = base.Channel.create()

               LET l_name = os.Path.join(FGL_GETENV('TEMPDIR') CLIPPED,l_name CLIPPED )
               CALL l_channel.openFile(l_name,"w" )
               LET l_cmd = "test -e ",l_name
               RUN l_cmd RETURNING l_n 
               IF l_n <> '0' THEN 
                  CALL cl_err('','anm-809',0)
                  RETURN 
               END IF
               SELECT SUM(nps12) INTO l_sum1 FROM x WHERE nps19 =l_syscode
               LET l_sum =l_sum1
               SELECT zx02 INTO l_operator FROM zx_file WHERE zx01 =g_user
               LET l_total1 =l_total
               LET l_str ="#SYSCODE=",l_syscode CLIPPED," ;VERSION=",l_version CLIPPED," ;SUM=",l_sum.trim() CLIPPED," ;TYPE=PAYMENT ;MAKEDATE=",TODAY USING 'YYMMDD'," ;OPERATOR=",l_operator CLIPPED," ;TOTAL=",l_total1.trim(),"\r\n"
               CALL l_channel.writeline(l_str)
               DECLARE p302_tmp_c CURSOR FOR SELECT nps01,nps05,nps06,nps07,nps08,nps09,nps10,
                                                    nps11,nps12,nps13,nps14,nps15,nps16
                                               FROM x
                                              WHERE nps03 MATCHES 'N02*'
               FOREACH p302_tmp_c INTO l_nps01,l_nps05,l_nps06,l_nps07,l_nps08,l_nps09,l_nps10,l_nps11,l_nps12_1,l_nps13,l_nps14,l_nps15,l_nps16
                       LET l_nps12 =l_nps12_1
                       LET l_str ="YURREF=",l_nps01 CLIPPED," ;DBTACC=",l_nps05 CLIPPED," ;DBTBBK=",l_nps06 CLIPPED," ;TRSAMT=",l_nps12.trim() CLIPPED,
                                  " ;C_CCYNBR=",l_nps13 CLIPPED," ;C_STLCHN=",l_nps14 CLIPPED," ;NUSAGE=",l_nps15 CLIPPED," ;BUSNAR=",l_nps16 CLIPPED," ;CRTACC=",l_nps07 CLIPPED,
                                  " ;CRTNAM=",l_nps08 CLIPPED," ;CRTBNK=",l_nps09 CLIPPED," ;CRTPVC=",l_nps10 CLIPPED," ;CRTCTY=",l_nps11 CLIPPED,"\r\n"
                       CALL l_channel.writeline(l_str)
                       UPDATE nps_file SET nps17 ='0',nps25 =l_name2,nps23 =TODAY
                        WHERE nps01 =l_nps01
                       UPDATE nme_file SET nme24 ='0',nme02 =TODAY
                        WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21))=l_nps01  
               END FOREACH  
               CALL l_channel.close()
               LET l_cmd = "test -s ",l_name
               RUN l_cmd RETURNING l_n 
               IF l_n <> '0' THEN 
                  CALL cl_err('','anm-809',0)
                  RETURN 
               END IF         
               UPDATE npu_file SET npu03 = l_sequ1 WHERE npu01 ='1' AND npu02 =TODAY 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  INSERT INTO npu_file VALUES('1',TODAY,l_sequ1)
               END IF

               LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),l_name1 CLIPPED)   #FUN-9C0008
               IF os.Path.separator() = "/" THEN      #NO.FUN-A30035
                  LET l_cmd ="unix2dos <",unix_path,"> $TEMPDIR/landing_tmp"
                  RUN l_cmd
                  LET l_cmd ="cat $TEMPDIR/landing_tmp >",unix_path
                  RUN l_cmd
               END IF                                 #NO.FUN-A30035
  
               LET window_path = "c:\\tiptop\\",l_name1
               LET status = cl_download_file(unix_path,window_path) 
               IF status THEN 
                  CALL cl_err('','anm-810',0)
               ELSE
                  CALL cl_err('','anm-809',0)
               END IF
            END FOREACH
            FOR i =1 TO g_nps.getLength()
                IF g_nps[i].c ='Y' THEN
                   LET g_nps[i].c ='N'
                   SELECT nps17 INTO g_nps[i].nps17 FROM nps_file WHERE nps01 =g_nps[i].nps01
                END IF
            END FOR
         END IF 
#for private
         DECLARE p302_p CURSOR FOR 
                                   SELECT nps01,nps03,nps05,nps06,nps12,nps13,nps15,nps16,nps19,nps20
                                     FROM nps_file 
                                    WHERE nps03 LIKE 'N03%'
                                    ORDER BY nps01
         FOREACH p302_p INTO l_nps01,l_nps03,l_nps05,l_nps06,l_nps12_1,l_nps13,l_nps15,l_nps16,l_nps19,l_nps20              
            LET l_nps12 =l_nps12_1
            LET l_npu03 =NULL 
            IF l_nps03 ='N03010' OR l_nps03 ='N03020' THEN 
               SELECT npu03+1 INTO l_sequ1 FROM npu_file WHERE npu01 ='2' AND npu02 =TODAY 
            END IF 
            IF l_nps03 ='N03030' THEN
               SELECT npu03+1 INTO l_sequ1 FROM npu_file WHERE npu01 ='3' AND npu02 =TODAY 
            END IF 
            IF cl_null(l_sequ1) OR l_sequ1 =0 THEN
               LET l_sequ1 =1
            END IF 
            LET l_sequ = l_sequ1
            LET l_name = TODAY USING 'YYMMDD','-',l_sequ.trim(),".eapy"
            LET l_name1 =l_name CLIPPED 
            LET l_name2 =l_name CLIPPED
            LET l_channel1 = base.Channel.create()

            LET l_name = os.Path.join(FGL_GETENV('TEMPDIR') CLIPPED,l_name CLIPPED)  #FUN-9C0008
            CALL l_channel1.openFile(l_name,"w" )
           #LET l_cmd = "test -e ",l_name
           #RUN l_cmd RETURNING l_n 
           #IF l_n <> '0' THEN 
            IF NOT os.Path.exists(l_name CLIPPED) THEN   #FUN-9C0008
               CALL cl_err('','anm-809',0)
               RETURN 
            END IF

            SELECT nmt10,nmt11 INTO l_syscode,l_version FROM nmt_file 
             WHERE nmt12 =l_nps19
             GROUP BY nmt10,nmt11
            SELECT zx02 INTO l_operator FROM zx_file WHERE zx01 =g_user
            IF l_nps03 ='N03010' OR l_nps03 ='N03020' THEN 
               LET l_type ='AGENTP'
            END IF
            IF l_nps03 ='N03030' THEN 
               LET l_type ='AGENTC'
            END IF 
            LET l_total1 = l_nps20
            LET l_str ="#SYSCODE=",l_syscode CLIPPED," ;VERSION=",l_version CLIPPED," ;TYPE=",l_type CLIPPED," ;MAKEDATE=",TODAY USING 'YYMMDD',
                       " ;OPERATOR=",l_operator CLIPPED," ;DBTACC=",l_nps05 CLIPPED," ;CURRENCY=",l_nps13 CLIPPED," ;BANKAREA=",l_nps06 CLIPPED,
                       " ;SUM=",l_nps12.trim() CLIPPED," ;TOTAL=",l_total1.trim()," ;MEMO=",l_nps15 CLIPPED," ;YURREF=",l_nps01 CLIPPED,"\n"
            CALL l_channel1.writeline(l_str)
               DECLARE p302_p4 CURSOR FOR SELECT npt03,npt04,npk05,npt06 
                                            FROM npt_file,npk_file
                                           WHERE npt01=npk01
                                             AND npt01=l_nps01
               FOREACH p302_p4 INTO l_npt03,l_npt04,l_npk05,l_npt06
                 LET l_str="ACCNBR=",l_npt03 CLIPPED," ;CLTNAM=",l_npt04 CLIPPED," ;TRSAMT=",l_npk05 CLIPPED," ;TRSDSP=",l_npt06 CLIPPED,"\n"
                 CALL l_channel1.writeline(l_str)
               END FOREACH 
                 CALL l_channel1.close()
                 LET l_cmd = "test -s ",l_name
                 RUN l_cmd RETURNING l_n 
                 IF l_n <> '0' THEN 
                    CALL cl_err('','anm-809',0)
                    RETURN 
                 END IF 
                 UPDATE nps_file SET nps17 ='0',nps25 =l_name2,nps23 =TODAY
                  WHERE nps01 =l_nps01
                 UPDATE nme_file SET nme24 ='0',nme02 =TODAY
                  WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21))=l_nps01  
                 IF l_nps03 ='N03010' OR l_nps03 ='N03020' THEN 
                    UPDATE npu_file SET npu03 = l_sequ1 WHERE npu01 ='2' AND npu02 =TODAY 
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      INSERT INTO npu_file VALUES('2',TODAY,l_sequ1)
                   END IF
                 END IF 
                 IF l_nps03 ='N03030' THEN
                    UPDATE npu_file SET npu03 = l_sequ1 WHERE npu01 ='3' AND npu02 =TODAY 
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      INSERT INTO npu_file VALUES('3',TODAY,l_sequ1)
                   END IF
                 END IF 
                 LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),l_name1 CLIPPED)    #FUN-9C0008
                 IF os.Path.separator() = "/" THEN  #NO.FUN-A30035
                    LET l_cmd ="unix2dos <",unix_path,"> $TEMPDIR/landing_tmp"
                    RUN l_cmd
                    LET l_cmd ="cat $TEMPDIR/landing_tmp >",unix_path
                    RUN l_cmd
                 END IF                              #NO.FUN-A30035
                 LET window_path = "c:\\tiptop\\",l_name1
                 LET status = cl_download_file(unix_path,window_path) 
                 IF status THEN 
                    CALL cl_err('','anm-810',0)
                 ELSE
                    CALL cl_err('','anm-809',0)
                 END IF                 
         END FOREACH
         FOR i =1 TO g_nps.getLength()
             IF g_nps[i].c ='Y' THEN
                LET g_nps[i].c ='N'
                SELECT nps17 INTO g_nps[i].nps17 FROM nps_file WHERE nps01 =g_nps[i].nps01
             END IF
         END FOR
       END IF                                 #No.FUN-870067 
       
END FUNCTION
 
FUNCTION p302_ftp()
DEFINE pubkey DYNAMIC ARRAY OF RECORD  #存放查出來的所有已簽名的公匙和用戶ID和對應的私匙ID摮
                UID STRING,
                KID STRING 
                END RECORD 
DEFINE seckey DYNAMIC ARRAY OF RECORD  #存放所有查出來的私鑰的用戶ID和對應的私鑰ID
                UID STRING,
                KID STRING                                                    
                END RECORD 
DEFINE skid               STRING       #TIPTOP私鑰ID
       ,passphrase        STRING       #TIPTOP私鑰的passphrase
       ,pkid              STRING       #HSBC公鑰的子ID
       ,ifile             STRING       #生成ifile文件路徑
       ,sfile             STRING       #ifile文件加密后存入的路徑
       ,host              STRING       #HSBC FTP服務器
       ,name              STRING       #HSBC FTP服務器的賬號
       ,password          STRING       #HSBC FTP服務器的口令
       ,remotedir         STRING       #ifile存放路徑
       ,saveasname        STRING       #ifile存放的名稱
 
 
DEFINE li_i   LIKE type_file.num10
 
   LET passphrase ="tiptop"               #用戶輸入
   LET ifile      ="/u1/out/ifile"        #程序生成
   LET sfile      ="/u1/out/ifile.pgp"    #程序生成,若相同則加密后覆蓋原明文
   LET host       ="192.168.100.254"      #配置作業
   LET name       ="tiptop"               #配置作業
   LET password   ="tiptop"               #自定義
   LET remotedir  ="./ifiles/"            #配置作業
   LET saveasname ="tiptop.gpg"           #按需求
  
   CALL getseckey(seckey)                 #得到所有私鑰的用戶ID和密鑰ID
   CALL getpubkey(pubkey)                 #得到所有公鑰的用戶ID和密鑰的子ID
  
   DISPLAY "\nsec--------\n"
   FOR li_i=1 TO seckey.getLength()
      IF seckey[li_i].UID = "tiptop"      #用戶通過combox選擇
      THEN 
        LET skid = seckey[li_i].KID
      END IF
      DISPLAY seckey[li_i].UID ," & ",seckey[li_i].KID,"\n"  #顯示
   END FOR
  
   DISPLAY "pub sub----\n"
   FOR li_i=1 TO pubkey.getLength()
  
      IF pubkey[li_i].UID = "HSBC_TEST"                      #用戶通過combox選擇
      THEN 
        LET pkid = pubkey[li_i].KID
      END IF
      DISPLAY pubkey[li_i].UID, " & ", pubkey[li_i].KID,"\n" #顯示
   END FOR
  
   DISPLAY "encrypt(",skid,",",passphrase,",",pkid,",",ifile,",",sfile,")"
#臨時mark by douzh
 # IF NOT encrypt(skid,passphrase,pkid,ifile,sfile) THEN
 #       DISPLAY "加密失敗"
 #       RETURN
 # ELSE
         DISPLAY "加密成功"
 # END IF
#臨時mark by douzh
  
   DISPLAY "\nupload(",host,",",name,",",password,",",remotedir,",",saveasname,",",sfile,")\n"
   CASE upload(host,name,password,remotedir,saveasname,sfile)
      WHEN 0
         DISPLAY "\n傳輸成功"                                          
      WHEN 1
         DISPLAY "\n連接失敗"                                          
      WHEN 2
         DISPLAY "\n登錄失敗"
      WHEN 3
         DISPLAY "\n服務器目錄失敗"
      WHEN 4
         DISPLAY "\n發送失敗"                                          
      WHEN 5
         DISPLAY "\n接受失敗"                                          
      WHEN 6
         DISPLAY "\n斷開失敗" 
   END CASE 
END FUNCTION
 
FUNCTION p302_direct()
DEFINE    i                LIKE type_file.num5
DEFINE    l_nps            RECORD LIKE nps_file.*
DEFINE    l_name	         LIKE type_file.chr20
DEFINE    l_summary        STRING
DEFINE    l_data           STRING
DEFINE    l_busmod         STRING
DEFINE    l_modals         STRING
DEFINE    l_trstyp         STRING
DEFINE    l_npt03          like npt_file.npt03
DEFINE    l_npt04          like npt_file.npt04
DEFINE    l_npk05          like npk_file.npk05
DEFINE    l_npt06          like npt_file.npt06
DEFINE    l_success        LIKE type_file.chr1
DEFINE    l_result         STRING
DEFINE    l_str            STRING
DEFINE    l_para           STRING 
DEFINE    l_nps12          STRING 
 
 
  DROP TABLE p302_tmp
 
  CREATE TEMP TABLE p302_tmp
    ( msg00 LIKE type_file.chr10, 
      msg01 LIKE type_file.chr30,
      msg02 LIKE type_file.chr37)
 
  IF STATUS THEN
     CALL cl_err('create tmp',STATUS,0)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  
   DROP TABLE y
   LET g_flag ='N'
   FOR i=1 TO g_nps.getLength()
      IF g_nps[i].b ='Y' THEN
         LET g_flag ='Y'
         SELECT * FROM nps_file WHERE 1=2 INTO TEMP y
         INSERT INTO y SELECT * FROM nps_file WHERE nps01 =g_nps[i].nps01 
         IF SQLCA.sqlcode THEN                                                                                                  
            CALL cl_err('',SQLCA.sqlcode,1) 
            RETURN                                                                                
         END IF 
       END IF
   END FOR 
   IF g_flag ='N' THEN
      CALL cl_err('','anm-803',0)
      RETURN
   END IF
#for public
   CALL cl_outnam('anmp302') RETURNING l_name
   START REPORT p302_rep TO l_name
   DECLARE p302_p1 CURSOR FOR 
                             SELECT *
                               FROM y 
                              WHERE nps03 MATCHES 'N02*'
   FOREACH p302_p1 INTO l_nps.*    
      OUTPUT TO REPORT p302_rep(l_nps.*)
   END FOREACH 
   FINISH REPORT p302_rep
#for private
   INITIALIZE l_nps.* TO NULL
   DECLARE p302_p2 CURSOR FOR 
                             SELECT *
                               FROM y 
                              WHERE nps03 MATCHES 'N03*'
   FOREACH p302_p2 INTO l_nps.*  
      LET g_nps01 =l_nps.nps01   
      CALL p302_login() RETURNING l_para
      IF NOT cl_null(l_para) THEN
         CALL cl_cmbinf(l_para,"ListMode",l_nps.nps03,"|") RETURNING l_result
      END IF      
      CALL p302_s(l_result,'|','1') RETURNING l_success,l_busmod,l_modals,l_trstyp
      IF l_success = 'N' THEN
         CALL cl_err('','abm-020',0)
         RETURN
      END IF     
      LET l_nps12 =l_nps.nps12 
      IF l_nps.nps03 = 'N03020' OR l_nps.nps03 ='N03030' THEN 
         CALL cl_cmbinf(l_para,"QueryAgentList",l_nps.nps03,"|") RETURNING l_result
         CALL p302_s(l_result,'|','1') RETURNING l_success,l_busmod,l_modals,l_trstyp
         IF l_success = 'N' AND cl_null(l_trstyp) THEN
            CALL cl_err('','abm-020',0)
            RETURN
         END IF
         LET l_summary="BUSCOD=",l_nps.nps03 CLIPPED," ;BUSMOD=",l_busmod CLIPPED," ;MODALS=",l_modals CLIPPED," ;",
                       "C_TRSTYP=",l_trstyp CLIPPED," ;DBTACC=",l_nps.nps05 CLIPPED," ;BBKNBR=",l_nps.nps18 CLIPPED," ;",
                       "SUM=",l_nps12.trim() CLIPPED," ;TOTAL=",l_nps.nps20 CLIPPED,"CURRENCY=",l_nps.nps13 CLIPPED," ;YURREF=",l_nps.nps01," ;MEMO=",l_nps.nps15 CLIPPED  
      ELSE
         LET l_summary="BUSCOD=",l_nps.nps03 CLIPPED," ;BUSMOD=",l_busmod CLIPPED," ;MODALS=",l_modals CLIPPED," ;",
                       "DBTACC=",l_nps.nps05 CLIPPED," ;BBKNBR=",l_nps.nps18 CLIPPED," ;",
                       "SUM=",l_nps12.trim() CLIPPED," ;TOTAL=",l_nps.nps20 CLIPPED,"CURRENCY=",l_nps.nps13 CLIPPED," ;YURREF=",l_nps.nps01," ;MEMO=",l_nps.nps15 CLIPPED  
      END IF 
      DECLARE p302_p3 CURSOR FOR SELECT npt03,npt04,npk05,npt06 
                                   FROM npt_file,npk_file
                                  WHERE npt01=npk01
                                    AND npt01=l_nps.nps01
      FOREACH p302_p3 INTO l_npt03,l_npt04,l_npk05,l_npt06
         LET l_str="ACCNBR=",l_npt03 CLIPPED," ;CLTNAM=",l_npt04 CLIPPED," ;TRSAMT=",l_npk05 CLIPPED," ;TRSDSP=",l_npt06 CLIPPED,"`"       
      END FOREACH
      IF NOT cl_null(l_data) THEN 
         LET l_str =l_summary CLIPPED,"|",l_data CLIPPED
         CALL p302_login() RETURNING l_para
         IF NOT cl_null(l_para) THEN
            CALL cl_cmbinf(l_para,"AgentRequest",l_str,"|") RETURNING l_result
            CALL p302_s(l_result,'|','2') RETURNING l_success,l_busmod,l_modals,l_trstyp
            IF l_success = 'N' THEN
               CALL cl_err('','abm-020',0)
               RETURN
            END IF
         END IF      
      END IF 
   END FOREACH 
   CALL p302_show_err()
   FOR i =1 TO g_nps.getLength()
       IF g_nps[i].b ='Y' THEN
          LET g_nps[i].b ='N'
          SELECT nps17 INTO g_nps[i].nps17 FROM nps_file WHERE nps01 =g_nps[i].nps01
       END IF
   END FOR 
END FUNCTION 
 
REPORT p302_rep(l_nps)
DEFINE   l_nps             RECORD LIKE nps_file.*
DEFINE   l_str             STRING
DEFINE   l_result          STRING
DEFINE   l_summary         STRING
DEFINE   l_data            STRING
DEFINE   l_busmod          STRING
DEFINE   l_modals          STRING 
DEFINE   l_trstyp          STRING
DEFINE   l_sqrnbr          STRING
DEFINE   l_errtxt          STRING
DEFINE   l_nps01           STRING
DEFINE   l_success         LIKE type_file.chr1
DEFINE   l_para            STRING 
DEFINE   l_nps12           STRING 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  FORMAT 
  BEFORE GROUP OF  l_nps.nps03
    IF l_nps.nps03 = 'N02020' THEN 
       CALL p302_login() RETURNING l_para
       IF NOT cl_null(l_para) THEN
          CALL cl_cmbinf(l_para,"ListMode",l_nps.nps03,"|") RETURNING l_result
          CALL p302_s(l_result,'|','1') RETURNING l_success,l_busmod,l_modals,l_trstyp
          IF l_success = 'N' THEN
             CALL cl_err('','abm-020',0)
             RETURN
          END IF
       END IF
       LET l_summary="BUSCOD=",l_nps.nps03 CLIPPED," ;BUSMOD=",l_busmod CLIPPED," ;C_TRSTYP=",l_trstyp
    ELSE
    	 LET l_summary="BUSCOD=",l_nps.nps03 CLIPPED
    END IF 
    LET l_data =NULL
 
  ON EVERY ROW  
    LET l_nps12 =l_nps.nps12
    LET l_data =l_data,"YURREF=",l_nps.nps01 CLIPPED," ;DBTACC=",l_nps.nps05 CLIPPED,
                " ;DBTBBK=",l_nps.nps06 CLIPPED," ;TRSAMT=",l_nps12.trim()," ;C_CCYNBR=",l_nps.nps13 CLIPPED,
                " ;C_STLCHN=",l_nps.nps14 CLIPPED," ;NUSAGE=",l_nps.nps15 CLIPPED," ;BUSNAR=",l_nps.nps16 CLIPPED,
                " ;CRTACC=",l_nps.nps07 CLIPPED," ;CRTNAM=",l_nps.nps08 CLIPPED," ;CRTBNK=",l_nps.nps09 CLIPPED,
                " ;CRTPVC=",l_nps.nps10 CLIPPED," ;CRTCTY=",l_nps.nps11 CLIPPED,"`" 
    INSERT INTO p302_tmp VALUES(l_nps.nps03,l_nps.nps01,'')
    IF STATUS THEN
       CALL cl_err('create tmp',STATUS,1)
       RETURN 
    END IF
 
 
                
  AFTER GROUP OF l_nps.nps03
    IF NOT cl_null(l_data) THEN 
       LET g_nps01 =l_nps.nps01
       LET l_str =l_summary CLIPPED,"|",l_data CLIPPED
       LET l_str =l_str.substring(1,l_str.getlength()-1)
       CALL p302_login() RETURNING l_para
       IF NOT cl_null(l_para) THEN
          CALL cl_cmbinf(l_para,"Payment",l_str,"|") RETURNING l_result
          CALL p302_s(l_result,'|','1') RETURNING l_success,l_busmod,l_modals,l_trstyp
          IF l_success = 'N' THEN
             CALL cl_err('','abm-020',0)
             RETURN
          END IF
       END IF
    END IF 
                
END REPORT 
 
FUNCTION p302_s(param_str,param_delim,p_cmd)
DEFINE param_str      STRING
DEFINE param_delim    STRING
DEFINE l_success      LIKE type_file.chr1
DEFINE param_array    DYNAMIC ARRAY OF STRING
DEFINE l_tok_param    base.StringTokenizer
DEFINE l_cnt_param    LIKE type_file.num5
DEFINE i              LIKE type_file.num5
DEFINE j              LIKE type_file.num5
DEFINE k              LIKE type_file.num5
DEFINE param_step     LIKE type_file.chr1
DEFINE p_cmd          LIKE type_file.chr1
DEFINE data_str       STRING
DEFINE data_delim     LIKE type_file.chr2
DEFINE data_array     DYNAMIC ARRAY OF STRING
DEFINE l_tok_data     base.StringTokenizer
DEFINE l_cnt_data     LIKE type_file.num5
DEFINE field_str      STRING
DEFINE field_array    DYNAMIC ARRAY OF STRING
DEFINE l_tok_field    base.StringTokenizer 
DEFINE l_cnt_field    LIKE type_file.num5
DEFINE l_str          STRING
DEFINE l_tok_str      base.StringTokenizer 
DEFINE l_cnt_str      LIKE type_file.num5
DEFINE str_array      DYNAMIC ARRAY OF STRING
DEFINE l_result       STRING
DEFINE sr             RECORD
                      nps01     LIKE nps_file.nps01,
                      nps05     LIKE nps_file.nps05,
                      nps06     LIKE nps_file.nps06,
                      nps12     LIKE nps_file.nps12,
                      nps13     LIKE nps_file.nps13,
                      nps14     LIKE nps_file.nps14,
                      nps15     LIKE nps_file.nps15,
                      nps16     LIKE nps_file.nps16,
                      nps07     LIKE nps_file.nps07,
                      nps08     LIKE nps_file.nps08,
                      nps09     LIKE nps_file.nps09,
                      nps10     LIKE nps_file.nps10,
                      nps11     LIKE nps_file.nps11,
                      reqsts    LIKE type_file.chr10,
                      rtnflg    LIKE type_file.chr10,  
                      busmod    LIKE type_file.chr10, 
                      modals    LIKE type_file.chr10,
                      trstyp    LIKE type_file.chr10,
                      sqrnbr    LIKE type_file.chr10,
                      errtxt    LIKE type_file.chr10                    
                      END RECORD
DEFINE   l_busmod          STRING
DEFINE   l_modals          STRING 
DEFINE   l_trstyp          STRING
DEFINE   l_sqrnbr          STRING
DEFINE   l_errtxt          STRING
DEFINE   l_msg02           LIKE type_file.chr37
 
 
    LET l_success ='Y'
    #先判斷是否成功，若不成功則報錯。
    LET param_delim = param_delim.trimRight()
    LET l_tok_param = base.StringTokenizer.create(param_str,param_delim)
    LET l_cnt_param = l_tok_param.countTokens()
    IF  l_cnt_param >0 THEN 
        CALL param_array.clear()
        LET i = 0 
        WHILE l_tok_param.hasMoreTokens()
           LET i=i+1
           LET param_array[i] =l_tok_param.nextToken()
        END WHILE 
    END IF 
    IF param_array[1] != '0' THEN 
       CALL cl_err(param_array[2],'',1)
       IF p_cmd ='2' AND param_array[1] ='3' THEN 
          LET l_result ="0",param_array[2]
          CALL p302_s(l_result,'|','e') RETURNING l_success,l_busmod,l_modals,l_trstyp     
       ELSE
          LET l_msg02 = param_array[2]
       	  UPDATE p302_tmp SET msg02 =l_msg02 WHERE msg01 =g_nps01
       END IF
       LET l_success ='N'
       RETURN l_success,sr.busmod,sr.modals,sr.trstyp
    END IF 
    #剝出記錄
    IF param_array[1] = '0' THEN 
       LET data_str = param_array[2]
       IF NOT cl_null(data_str) THEN
          LET l_tok_data = base.StringTokenizer.create(data_str,"\n")
          LET l_cnt_data = l_tok_data.countTokens()
          IF l_cnt_data > 0 THEN 
             CALL data_array.clear()
             LET j=0
             WHILE l_tok_data.hasMoreTokens()
                LET j = j+1
                LET data_array[j]=l_tok_data.nextToken()     
             END WHILE
             #剝出字段
             FOR j=1 TO l_cnt_data
                 LET field_str = data_array[j]
                 LET l_tok_field = base.StringTokenizer.create(field_str," ;")
                 LET l_cnt_field = l_tok_field.countTokens()
                 IF l_cnt_field >0 THEN 
                    CALL field_array.clear()
                    LET k=0
                    WHILE l_tok_field.hasMoreTokens()
                       LET k=k+1
                       LET field_array[k]=l_tok_field.nextToken()   
                    END WHILE 
                 END IF 
                 #分析字段
                 IF p_cmd = '1' THEN 
                    FOR k = 1 TO l_cnt_field
                        LET l_str = field_array[k]
                        LET l_tok_str = base.StringTokenizer.create(l_str,"=")
                        LET l_cnt_str = l_tok_str.countTokens()
                        IF l_cnt_str > 0 THEN 
                           CALL str_array.clear()
                           LET i = 0
                           WHILE l_tok_str.hasMoreTokens()
                              LET i = i+1
                              LET str_array[i] = l_tok_str.nextToken()
                           END WHILE 
                           CASE str_array[1]
                             WHEN "YURREF"
                               LET sr.nps01 = str_array[2]
                             WHEN "DBTACC"
                               LET sr.nps05 = str_array[2]
                             WHEN "DBTBBK"
                               LET sr.nps06 = str_array[2]
                             WHEN "TRSAMT"
                               LET sr.nps12 = str_array[2]
                             WHEN "C_CCYNBR"
                               LET sr.nps13 = str_array[2]
                             WHEN "C_STLCHN"
                               LET sr.nps14 = str_array[2]
                             WHEN "NUSAGE"
                               LET sr.nps15 = str_array[2]
                             WHEN "BUSNAR"
                               LET sr.nps16 = str_array[2]
                             WHEN "CRTACC"
                               LET sr.nps07 = str_array[2]
                             WHEN "CRTNAM"
                               LET sr.nps08 = str_array[2]
                             WHEN "CRTBNK"
                               LET sr.nps09 = str_array[2]
                             WHEN "CRTPVC"
                               LET sr.nps10 = str_array[2]
                             WHEN "CRTCTY"
                               LET sr.nps11 = str_array[2]
                             WHEN "REQSTS"
                               LET sr.reqsts = str_array[2]                       
                             WHEN "RTNFLG"
                               LET sr.rtnflg = str_array[2]
                             WHEN "BUSMOD"
                               LET sr.busmod = str_array[2]
                             WHEN "MODALS"
                               LET sr.modals = str_array[2]  
                             WHEN "C-TRSTYP"
                               LET sr.trstyp = str_array[2]
                             OTHERWISE EXIT CASE 
                           END CASE
                        END IF  
                    END FOR 
                    IF NOT cl_null(sr.reqsts) THEN
                       UPDATE nps_file SET nps17 ='3',nps23 =TODAY
                        WHERE nps01= sr.nps01
                       UPDATE nme_file SET nme24 ='3',nme02 =TODAY
                        WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =sr.nps01
                       LET l_msg02 ='anm-804'
                       UPDATE p302_tmp SET msg02 = l_msg02
                        WHERE msg01 = sr.nps01
                    END IF
                    IF sr.reqsts ='FIN' THEN
                       IF sr.rtnflg ='S' THEN
                          UPDATE nps_file SET nps17 ='4',nps23 =TODAY
                           WHERE nps01= sr.nps01
                          UPDATE nme_file SET nme24 ='4',nme02 =TODAY
                           WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =sr.nps01
                          LET l_msg02 ='anm-805'
                          UPDATE p302_tmp SET msg02 =l_msg02
                           WHERE msg01 =sr.nps01
                        ELSE
                          IF NOT cl_null(sr.rtnflg) THEN 
                             UPDATE nps_file SET nps17 ='1',nps23 =TODAY
                              WHERE nps01= sr.nps01
                             UPDATE nme_file SET nme24 ='1',nme02 =TODAY
                              WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =sr.nps01
                             LET l_msg02 ='anm-806'
                             UPDATE p302_tmp SET msg02 =l_msg02
                              WHERE msg01 =sr.nps01
                          ELSE
                             UPDATE nps_file SET nps17 ='2',nps23 =TODAY
                              WHERE nps01= sr.nps01
                             UPDATE nme_file SET nme24 ='2',nme02 =TODAY
                              WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =sr.nps01
                             LET l_msg02 ='anm-807'
                             UPDATE p302_tmp SET msg02 =l_msg02
                              WHERE msg01 =sr.nps01
                          END IF 
                        END IF 
                    END IF
#                    RETURN l_success,sr.busmod,sr.modals,sr.trstyp
                 END IF
                 IF p_cmd = '2' THEN 
                    FOR k = 1 TO l_cnt_field
                        LET l_str = field_array[k]
                        LET l_tok_str = base.StringTokenizer.create(l_str,"=")
                        LET l_cnt_str = l_tok_str.countTokens()
                        IF l_cnt_str > 0 THEN 
                           CALL str_array.clear()
                           LET i = 0
                           WHILE l_tok_str.hasMoreTokens()
                              LET i = i+1
                              LET str_array[i] = l_tok_str.nextToken()
                           END WHILE 
                           CASE str_array[1]
                             WHEN "YURREF"
                               LET sr.nps01 = str_array[2]
                             OTHERWISE EXIT CASE 
                           END CASE
                        END IF  
                    END FOR 
                    UPDATE nps_file SET nps17 ='3',nps23 =TODAY
                     WHERE nps01= sr.nps01
                    UPDATE nme_file SET nme24 ='3',nme02 =TODAY
                     WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =sr.nps01
                    LET l_msg02 ='anm-804'
                    UPDATE p302_tmp SET msg02 =l_msg02
                     WHERE msg01 =sr.nps01
#                    RETURN l_success,sr.busmod,sr.modals,sr.trstyp
                 END IF
                 IF p_cmd = 'e' THEN 
                    FOR k = 1 TO l_cnt_field
                        LET l_str = field_array[k]
                        LET l_tok_str = base.StringTokenizer.create(l_str,"=")
                        LET l_cnt_str = l_tok_str.countTokens()
                        IF l_cnt_str > 0 THEN 
                           CALL str_array.clear()
                           LET i = 0
                           WHILE l_tok_str.hasMoreTokens()
                              LET i = i+1
                              LET str_array[i] = l_tok_str.nextToken()
                           END WHILE 
                           CASE str_array[1]
                             WHEN "SQRNBR"
                               LET sr.sqrnbr = str_array[2]
                             WHEN "YURREF"
                               LET sr.nps01 = str_array[2]
                             WHEN "ERRTXT"
                               LET sr.errtxt = str_array[2]
                             OTHERWISE EXIT CASE 
                           END CASE
                        END IF  
                    END FOR 
                    UPDATE p302_tmp SET msg02 =sr.errtxt
                     WHERE msg01 =sr.nps01
#                    RETURN l_success,sr.busmod,sr.modals,sr.trstyp
                 END IF
             END FOR 
          END IF 
       END IF 
    END IF 
    
 
    RETURN l_success,sr.busmod,sr.modals,sr.trstyp
 
END FUNCTION
 
FUNCTION p302_show_err()
DEFINE  g_msg  DYNAMIC ARRAY OF RECORD 
               msg00   LIKE nps_file.nps03,
               msg01   LIKE nps_file.nps01,
               msg02   LIKE type_file.chr37
               END RECORD 
   LET g_sql = "SELECT * from p302_tmp",  
               " ORDER BY msg01"
   PREPARE p302_msg FROM g_sql
   DECLARE nps_msg CURSOR FOR p302_msg
 
   CALL g_msg.clear()
 
   OPEN WINDOW p302_w_e WITH FORM "anm/42f/anmp302_e"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   LET g_cnt = 1
 
   FOREACH nps_msg INTO g_msg[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_msg[g_cnt].msg02 =cl_getmsg(g_msg[g_cnt].msg02,g_lang)
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_msg.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b3 = g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cnt3  
   LET g_cnt = 0
 
   DISPLAY ARRAY g_msg TO s_msg.* ATTRIBUTE(COUNT=g_rec_b)
      ON ACTION exit
         EXIT DISPLAY
 
      ON ACTION cancel
         EXIT DISPLAY
 
       #TQC-860019-add 
        ON IDLE g_idle_seconds
         CALL cl_on_idle  ()
         CONTINUE DISPLAY
       #TQC-860019-add 
      
   END DISPLAY
   CLOSE WINDOW p302_w_e
 
END FUNCTION
 
 
FUNCTION p302_login()
DEFINE l_success     LIKE type_file.chr1
DEFINE l_result      LIKE type_file.chr1
DEFINE l_p           LIKE type_file.chr1000
 
    IF cl_null(g_aza.aza74) THEN 
       CALL cl_err('','anm-702',1)
       LET g_success ='N'
    ELSE
       CALL p302_nmv01()
       IF NOT cl_null(g_errno) THEN 
          CALL cl_err('',g_errno,1)
          LET g_success = 'N'
          LET l_result ='3'
          RETURN l_result
       END IF 
       LET l_p = "LGNTYP=0 ;LGNNAM=",g_nmv.nmv03 CLIPPED," ;LGNPWD=",g_nmv.nmv04 CLIPPED," ;ICCPWD=",g_nmv.nmv07
    END IF 
    RETURN l_p 
 
END FUNCTION
 
FUNCTION p302_nmv01() 
DEFINE 
    #l_sql           LIKE type_file.chr1000
    l_sql           STRING      #NO.FUN-910082    
 
    LET g_errno = ''
    INITIALIZE g_nmv.* TO NULL 
    LET l_sql="SELECT * FROM nmv_file ",
              " WHERE nmv01='",g_aza.aza74,"'"
    PREPARE p302_pre_nmv01 FROM l_sql
    DECLARE p302_cs_nmv01 CURSOR FOR p302_pre_nmv01
    OPEN p302_cs_nmv01
    FETCH p302_cs_nmv01 INTO g_nmv.*
    CLOSE p302_cs_nmv01
    CASE SQLCA.sqlcode
      WHEN 100  LET g_errno = "anm-703"
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-----'
    END CASE 
END FUNCTION 
 
#No.FUN-870067--begin
FUNCTION p302_combo() 
   DEFINE comb_value LIKE type_file.chr1000
   DEFINE comb_item  LIKE type_file.chr1000
   DEFINE l_nps19    LIKE nps_file.nps19
  
   IF g_nps[l_ac].nps01 IS NOT NULL THEN
      SELECT nps19 INTO l_nps19 FROM nps_file
       WHERE nps01=g_nps[l_ac].nps01
      IF NOT cl_null(g_aza.aza78) AND l_nps19 = g_aza.aza78 THEN  
         LET comb_value = 'IAT,LTR,FTR,ACH-CR,COS'
         SELECT ze03 INTO comb_item FROM ze_file
          WHERE ze01 = 'anm-153' AND ze02=g_lang
      ELSE
         LET comb_value = 'N02020,N02031,N02041,N03010,N03020,N03030'
         SELECT ze03 INTO comb_item FROM ze_file
          WHERE ze01 = 'anm-154' AND ze02=g_lang
      END IF
   END IF
 
  CALL cl_set_combo_items('nps03',comb_value,comb_item)
END FUNCTION 
#No.FUN-870067--end
