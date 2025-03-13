# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: "apci040.4gl"
# Descriptions...: 收銀機資料維護作業
# Date & Author..: FUN-870007 09/06/08 By Zhangyajun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30078 10/03/24 By Cockroach arti100變更為apci040
# Modify.........: No:FUN-A70063 10/07/19 By chenying 新增收銀方式欄位 ryc06 
# Modify.........: No:TQC-AA0022 10/10/09 By houlia 重新過單
# Modify.........: No:TQC-B40188 11/04/22 By lilingyu 進入單身,程序死循環
# Modify.........: No:FUN-C40078 12/05/02 By Lori 新增ryc07,ryc08
# Modify.........: No:FUN-C90090 12/09/19 By shiwuying 功能調整
# Modify.........: No:FUN-CB0007 12/11/06 By xumm 机号只能录入数字
# Modify.........: No:FUN-D10016 13/01/04 By xumm 机号不能大于六位 
# Modify.........: No:FUN-D20096 13/02/28 By dongsz 欄位檢查之前加條件
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryc   DYNAMIC ARRAY OF RECORD               #TQC-AA0022 過單 
                ryc01       LIKE ryc_file.ryc01,
                ryc01_desc  LIKE azp_file.azp02,
                ryc02       LIKE ryc_file.ryc02,
                ryc03       LIKE ryc_file.ryc03,
                ryc06       LIKE ryc_file.ryc06,      #FUN-A70063 add
                ryc04       LIKE ryc_file.ryc04,
                ryc07       LIKE ryc_file.ryc07,      #FUN-C40078 add
                ryc08       LIKE ryc_file.ryc08,      #FUN-C40078 add
                ryc05       LIKE ryc_file.ryc05,
                rycacti     LIKE ryc_file.rycacti
               ,rycpos      LIKE ryc_file.rycpos      #FUN-C90090
                        END RECORD,
        g_ryc_t RECORD
                ryc01       LIKE ryc_file.ryc01,
                ryc01_desc  LIKE azp_file.azp02,
                ryc02       LIKE ryc_file.ryc02,
                ryc03       LIKE ryc_file.ryc03,
                ryc06       LIKE ryc_file.ryc06,      #FUN-A70063 add
                ryc04       LIKE ryc_file.ryc04,
                ryc07       LIKE ryc_file.ryc07,      #FUN-C40078 add
                ryc08       LIKE ryc_file.ryc08,      #FUN-C40078 add
                ryc05       LIKE ryc_file.ryc05,
                rycacti     LIKE ryc_file.rycacti
               ,rycpos      LIKE ryc_file.rycpos      #FUN-C90090
                        END RECORD
DEFINE  g_sql   STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_cnt           LIKE type_file.num10
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)      
         RETURNING g_time   
           
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i040_w AT p_row,p_col WITH FORM "apc/42f/apci040"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    #FUN-C40078--Add Begin-------
    IF g_aza.aza26 <> '0' THEN
       CALL cl_set_comp_visible('ryc07',FALSE)
       CALL cl_set_comp_visible('ryc08',FALSE)
    ELSE
       CALL cl_set_comp_visible('ryc07',TRUE)
       CALL cl_set_comp_visible('ryc08',TRUE)
    END IF 
    #FUN-C40078--Add End---------
  
    CALL cl_ui_init()
    CALL cl_set_comp_visible('rycpos',g_aza.aza88='Y')
    CALL cl_set_comp_visible("ryc04,ryc05,ryc06",FALSE) #FUN-C90090
    CALL cl_set_comp_visible('ryc07,ryc08',FALSE)       #FUN-D10016

    LET g_wc2 = "1=1"
    CALL i040_b_fill(g_wc2)
    CALL i040_menu()
    CLOSE WINDOW i040_w                   
    CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
 
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ryc TO s_ryc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      ON ACTION output
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
      # Standard 4ad ACTION
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
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i040_menu()
 
   WHILE TRUE
      CALL i040_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i040_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i040_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ryc),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i040_q()
 
   CALL i040_b_askkey()
   
END FUNCTION
 
FUNCTION i040_b_askkey()
 
    CLEAR FORM
  
    CONSTRUCT g_wc2 ON ryc01,ryc02,ryc03,ryc06,ryc04,ryc07,ryc08,ryc05,rycacti              #FUN-C40078 add ryc07,ryc08  #FUN-A70063 add  ryc06
                      ,rycpos                                                               #FUN-C90090
                  FROM s_ryc[1].ryc01,s_ryc[1].ryc02,s_ryc[1].ryc03,s_ryc[1].ryc06,         #FUN-A70063 add  ryc06
                       s_ryc[1].ryc04,s_ryc[1].ryc07,s_ryc[1].ryc08,s_ryc[1].ryc05,s_ryc[1].rycacti   #FUN-C40078 add ryc07,ryc08
                      ,s_ryc[1].rycpos                                                      #FUN-C90090
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(ryc01)   #機構代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryc"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryc01
                 NEXT FIELD ryc01
 
              OTHERWISE
                 EXIT CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('rycuser', 'rycgrup') #FUN-980030
    
    IF INT_FLAG THEN 
        RETURN
    END IF
 
    CALL i040_b_fill(g_wc2)
    
END FUNCTION
 
FUNCTION i040_ryc01(p_cmd)#帶出機構名稱   
DEFINE    p_cmd   STRING,
          l_ryc01_desc LIKE azp_file.azp02
          
   LET g_errno = ' '
   
   SELECT azp02 INTO l_ryc01_desc FROM azp_file 
    WHERE azp01 = g_ryc[l_ac].ryc01
        
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002' 
                                 LET l_ryc01_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_ryc[l_ac].ryc01_desc = l_ryc01_desc
     DISPLAY BY NAME   g_ryc[l_ac].ryc01_desc
  END IF
 
END FUNCTION
 
FUNCTION i040_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT ryc01,'',ryc02,ryc03,ryc06,ryc04,ryc07,ryc08,ryc05,rycacti,rycpos FROM ryc_file ",    #FUN-C40078 add ryc07,ryc08  #FUN-A70063 add ryc06 #FUN-C90090
                " WHERE ",p_wc2 CLIPPED
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    PREPARE i040_pb FROM g_sql
    DECLARE ryc_cs CURSOR FOR i040_pb
 
    CALL g_ryc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ryc_cs INTO g_ryc[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT azp02 INTO g_ryc[g_cnt].ryc01_desc FROM azp_file
        WHERE azp01 = g_ryc[g_cnt].ryc01
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ryc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2
        LET g_cnt = 0
        
END FUNCTION
 
FUNCTION i040_b()
 DEFINE l_ac_t          LIKE type_file.num5,
        l_n             LIKE type_file.num5,
        l_cnt           LIKE type_file.num5,
        l_lock_sw       LIKE type_file.chr1,
        p_cmd           LIKE type_file.chr1,
        l_misc          LIKE gef_file.gef01,
        l_allow_insert  LIKE type_file.num5,
        l_allow_delete  LIKE type_file.num5
 DEFINE l_msg           STRING,
        li_n            LIKE type_file.num5,
        ls_ryc04        STRING,
        lst_ryc04       base.stringtokenizer
 DEFINE l_rycpos        LIKE ryc_file.rycpos    #FUN-C90090
 DEFINE l_str           LIKE ryc_file.ryc02     #FUN-CB0007 add
 DEFINE l_length        LIKE type_file.num5     #FUN-CB0007 add
 DEFINE i               LIKE type_file.num5     #FUN-CB0007 add
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT  ryc01,'',ryc02,ryc03,ryc06,ryc04,ryc07,ryc08,ryc05,rycacti",    #FUN-C40078 add ryc07,ryc08  #FUN-A70063 add ryc06
                         "       ,rycpos ",  #FUN-C90090
                         " FROM ryc_file",
                         " WHERE ryc01=? AND ryc02=?",
                         " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i040_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_ryc WITHOUT DEFAULTS FROM s_ryc.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
               #BEGIN WORK  #FUN-C90090
                            
                IF g_rec_b>=l_ac THEN 
                   LET p_cmd ='u'
                   LET g_ryc_t.*=g_ryc[l_ac].*
                  #FUN-C90090 Begin---
                   BEGIN WORK
                   IF g_aza.aza88 = 'Y' THEN
                      OPEN i040_bcl USING g_ryc_t.ryc01,g_ryc_t.ryc02
                      IF STATUS THEN
                         CALL cl_err("OPEN i040_bcl:",STATUS,1)
                         LET l_lock_sw='Y'
                      ELSE
                         FETCH i040_bcl INTO g_ryc[l_ac].*
                         IF SQLCA.sqlcode THEN
                            CALL cl_err(g_ryc_t.ryc01,SQLCA.sqlcode,1)
                            LET l_lock_sw="Y"
                         END IF
                      END IF
                      IF l_lock_sw="N" THEN
                         UPDATE ryc_file SET rycpos = '4'
                          WHERE ryc01 = g_ryc[l_ac].ryc01
                            AND ryc02 = g_ryc[l_ac].ryc02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            CALL cl_err3("upd","ryc_file",g_ryc_t.ryc01,"",SQLCA.sqlcode,"","",1)
                            LET l_lock_sw = "Y"
                         ELSE
                            LET g_ryc[l_ac].rycpos = '4'
                            DISPLAY BY NAME g_ryc[l_ac].rycpos
                         END IF
                      END IF
                      COMMIT WORK
                      LET l_rycpos = g_ryc_t.rycpos
                      IF l_rycpos <> '1' THEN
                         CALL cl_set_comp_entry("ryc01,ryc02",FALSE)
                      ELSE
                         CALL cl_set_comp_entry("ryc01,ryc02",TRUE)
                      END IF
                   END IF
                  #FUN-C90090 End-----
                   BEGIN WORK  #FUN-C90090
                   
                   LET g_before_input_done = FALSE                                                                                      
                   CALL i040_set_entry(p_cmd)                                                                                           
                   CALL i040_set_no_entry(p_cmd)                                                                                        
                   LET g_before_input_done = TRUE
                   
                   OPEN i040_bcl USING g_ryc_t.ryc01,g_ryc_t.ryc02
                   IF STATUS THEN
                      CALL cl_err("OPEN i040_bcl:",STATUS,1)
                      LET l_lock_sw='Y'
                   ELSE
                      FETCH i040_bcl INTO g_ryc[l_ac].*
                      IF SQLCA.sqlcode THEN
                         CALL cl_err(g_ryc_t.ryc01,SQLCA.sqlcode,1)
                         LET l_lock_sw="Y"
                      END IF
                      CALL i040_ryc01('d')
                   END IF
              END IF
              
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                LET g_before_input_done = FALSE                                                                                      
                CALL i040_set_entry(p_cmd)                                                                                           
                CALL i040_set_no_entry(p_cmd)                                                                                        
                LET g_before_input_done = TRUE
                INITIALIZE g_ryc[l_ac].* TO NULL               
                LET g_ryc[l_ac].ryc05 = 'N'
                #FUN-C40078--Add Begin---
                IF cl_null(g_ryc[l_ac].ryc07) THEN
                   LET g_ryc[l_ac].ryc07 = 'N'
                END IF
                IF cl_null(g_ryc[l_ac].ryc08) THEN
                   LET g_ryc[l_ac].ryc08 = 0
                END IF
                #FUN-C40078--Add End-----
                LET g_ryc[l_ac].rycacti = 'Y'
                LET g_ryc[l_ac].rycpos  = '1'  #FUN-C90090
                LET l_rycpos = '1'             #FUN-C90090
                LET g_ryc_t.*=g_ryc[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD ryc01
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                
                #FUN-C40078--Add Begin---
                IF cl_null(g_ryc[l_ac].ryc08) THEN
                   LET g_ryc[l_ac].ryc08 = 0
                END IF
                IF g_ryc[l_ac].ryc07 = 'Y' AND g_ryc[l_ac].ryc08 <= 0 THEN
                   CALL cl_err('','axr-170', 1)
                   NEXT FIELD ryc08
                END IF
                #FUN-C40078--Add End-----
                
                INSERT INTO ryc_file(ryc01,ryc02,ryc03,ryc06,ryc04,ryc07,ryc08,ryc05,rycacti,rycpos,rycuser,rycgrup,ryccrat,rycoriu,rycorig)        #FUN-C40078 add ryc07,ryc08   #FUN-A70063 add ryc06 #FUN-C90090
                     VALUES(g_ryc[l_ac].ryc01,g_ryc[l_ac].ryc02,g_ryc[l_ac].ryc03,g_ryc[l_ac].ryc06,g_ryc[l_ac].ryc04,     #FUN-A70063 add ryc06
                            g_ryc[l_ac].ryc07,g_ryc[l_ac].ryc08,   #FUN-C40078 add
                            g_ryc[l_ac].ryc05,
                            g_ryc[l_ac].rycacti,g_ryc[l_ac].rycpos,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig #FUN-C90090
                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ryc_file",g_ryc[l_ac].ryc01,g_ryc[l_ac].ryc02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                
#ryc01+ryc02不能重復
      AFTER FIELD ryc01,ryc02
             #FUN-CB0007----add----str
            #IF NOT cl_null(g_ryc[l_ac].ryc02)  AND p_cmd = 'a' THEN              #FUN-D20096 mark
             IF NOT cl_null(g_ryc[l_ac].ryc02)  AND (p_cmd = 'a' OR (p_cmd = 'u' AND g_ryc[l_ac].ryc02 != g_ryc_t.ryc02)) THEN   #FUN-D20096 add
                LET g_success = 'Y'
                LET l_str = g_ryc[l_ac].ryc02
                LET l_length = LENGTH(l_str)
                #FUN-D10016---add---str
                IF l_length > 6 THEN
                   CALL cl_err(g_ryc[l_ac].ryc02,'apc1060',0)
                   LET g_success = 'N'
                END IF
                #FUN-D10016---add---end
                FOR i = 1 TO l_length
                   IF l_str[i,i] NOT MATCHES '[0123456789]' THEN
                      CALL cl_err(g_ryc[l_ac].ryc02,'aic-910',0)
                      LET g_success = 'N'
                      EXIT FOR
                   END IF
                END FOR
                IF g_success = 'N'THEN
                   LET g_ryc[l_ac].ryc02 = g_ryc_t.ryc02
                   NEXT FIELD ryc02
                END IF
             END IF
             #FUN-CB0007----add----end
            #IF NOT cl_null(g_ryc[l_ac].ryc01) THEN     #FUN-D20096 mark
             IF NOT cl_null(g_ryc[l_ac].ryc01) AND (p_cmd = 'a' OR (p_cmd = 'u' AND g_ryc[l_ac].ryc01 != g_ryc_t.ryc01)) THEN   #FUN-D20096 add
                  CALL i040_ryc01('a')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('ryc01:',g_errno,0)
                  LET g_ryc[l_ac].ryc01 = g_ryc_t.ryc01
                  DISPLAY BY NAME g_ryc[l_ac].ryc01
                  IF p_cmd = 'a' THEN            #TQC-B40188 
                     NEXT FIELD ryc01
#TQC-B40188 --begin--                  
                  ELSE 
                     NEXT FIELD ryc02
                  END IF  	  
#TQC-B40188 --end--                  
                END IF       
                IF NOT cl_null(g_ryc[l_ac].ryc02) THEN   
                  IF p_cmd = "a" OR                    
                     (p_cmd = "u" AND (g_ryc[l_ac].ryc01 != g_ryc_t.ryc01 OR g_ryc[l_ac].ryc02 != g_ryc_t.ryc02)) THEN                
                  SELECT COUNT(*) INTO l_n FROM ryc_file WHERE ryc01 = g_ryc[l_ac].ryc01 AND ryc02 = g_ryc[l_ac].ryc02
                  IF l_n > 0 THEN       
                    LET l_msg = g_ryc[l_ac].ryc01 CLIPPED,",",g_ryc[l_ac].ryc02 CLIPPED           
                    CALL cl_err(l_msg,-239,0)
                    IF INFIELD(ryc01) THEN
                       LET g_ryc[l_ac].ryc01 = g_ryc_t.ryc01
                    ELSE
                       LET g_ryc[l_ac].ryc02 = g_ryc_t.ryc02
                    END IF
                    DISPLAY BY NAME g_ryc[l_ac].ryc01,g_ryc[l_ac].ryc02
                    NEXT FIELD CURRENT
                  END IF  
                  END IF                            
                END IF
             END IF
 
#IP地址檢測                          
       AFTER FIELD ryc04  
         IF NOT cl_null(g_ryc[l_ac].ryc04) THEN
            IF g_ryc[l_ac].ryc04 != g_ryc_t.ryc04 OR g_ryc_t.ryc04 IS NULL THEN
                  LET lst_ryc04 = base.stringtokenizer.create(g_ryc[l_ac].ryc04 CLIPPED,".")
                  IF lst_ryc04.countTokens() = 4 THEN  
                     LET li_n = 1                   
                     WHILE lst_ryc04.hasmoretokens()
                        LET ls_ryc04 = lst_ryc04.nexttoken()
                        IF cl_numchk(ls_ryc04,0) THEN
                           IF ls_ryc04.getlength()>3 THEN
                              CALL cl_err(g_ryc[l_ac].ryc04,'art-001',0)
                              NEXT FIELD ryc04
                              EXIT WHILE
                           ELSE
                               IF li_n = 1 THEN
                                  IF ls_ryc04 < 1 OR ls_ryc04 > 223 THEN
                                     CALL cl_err(ls_ryc04,'art-461',0)
                                     NEXT FIELD ryc04
                                     EXIT WHILE
                                  END IF
                               ELSE
                                  IF ls_ryc04 < 0 OR ls_ryc04 > 255 THEN
                                     CALL cl_err(ls_ryc04,'art-462',0)
                                     NEXT FIELD ryc04
                                     EXIT WHILE
                                  END IF
                               END IF
                           END IF
                        ELSE
                          CALL cl_err(g_ryc[l_ac].ryc04,'art-001',0)
                          NEXT FIELD ryc04
                          EXIT WHILE                         
                        END IF
                        LET li_n = li_n + 1
                     END WHILE
                  ELSE 
                      CALL cl_err(g_ryc[l_ac].ryc04,'art-001',0)
                      NEXT FIELD ryc04
                  END IF               
             END IF
          END IF
       #FUN-C40078--Add Begin---
       AFTER FIELD ryc07
          IF g_ryc[l_ac].ryc07 = 'Y' THEN
             CALL cl_set_comp_entry('ryc08',TRUE)
          ELSE
             CALL cl_set_comp_entry('ryc08',FALSE)
          END IF
          IF cl_null(g_ryc[l_ac].ryc08) THEN
             LET g_ryc[l_ac].ryc08 = 0
          END IF
       AFTER FIELD ryc08
          IF g_ryc[l_ac].ryc07 = 'Y' AND g_ryc[l_ac].ryc08 <= 0 THEN
            CALL cl_err('','axr-170', 1)
            NEXT FIELD ryc08
          END IF
          IF cl_null(g_ryc[l_ac].ryc08) THEN
             LET g_ryc[l_ac].ryc08 = 0
          END IF

       #FUN-C40078--Add End-----
          
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
          #IF g_ryc_t.ryc02 > 0 AND g_ryc_t.ryc02 IS NOT NULL THEN #FUN-C90090
           IF g_ryc_t.ryc02 IS NOT NULL THEN                       #FUN-C90090
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
             #FUN-C90090 Begin---
              IF g_aza.aza88 = 'Y' THEN
                 IF NOT ((l_rycpos='3' AND g_ryc_t.rycacti='N') OR (l_rycpos='1'))  THEN
                    CALL cl_err('','apc-139',0)
                    ROLLBACK WORK              
                    CANCEL DELETE 
                   END IF
              END IF
             #FUN-C90090 End-----
             
              DELETE FROM ryc_file
               WHERE ryc01 = g_ryc_t.ryc01
                 AND ryc02 = g_ryc_t.ryc02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","ryc_file",g_ryc_t.ryc01,g_ryc_t.ryc02,SQLCA.sqlcode,"","",1)  
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
              LET g_ryc[l_ac].* = g_ryc_t.*
              CLOSE i040_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           #FUN-C40078--Add Begin---
           IF g_ryc[l_ac].ryc07 = 'Y' AND g_ryc[l_ac].ryc08 <= 0 THEN
            CALL cl_err('','axr-170', 1)
            NEXT FIELD ryc08
           END IF
           #FUN-C40078--Add End-----

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ryc[l_ac].ryc02,-263,1)
              LET g_ryc[l_ac].* = g_ryc_t.*
           ELSE
             #FUN-C90090 Begin---
              IF g_aza.aza88 = 'Y' THEN
                 IF l_rycpos <> '1' THEN
                    LET g_ryc[l_ac].rycpos='2'
                 ELSE 
                    LET g_ryc[l_ac].rycpos='1'
                 END IF
                 DISPLAY BY NAME g_ryc[l_ac].rycpos
              END IF
             #FUN-C90090 End-----
              UPDATE ryc_file SET ryc01 = g_ryc[l_ac].ryc01,
                                  ryc02 = g_ryc[l_ac].ryc02,
                                  ryc03 = g_ryc[l_ac].ryc03,
                                  ryc06 = g_ryc[l_ac].ryc06,     #FUN-A70063 add
                                  ryc04 = g_ryc[l_ac].ryc04,
                                  ryc07 = g_ryc[l_ac].ryc07,     #FUN-C40078 add
                                  ryc08 = g_ryc[l_ac].ryc08,     #FUN-C40078 add
                                  ryc05 = g_ryc[l_ac].ryc05,
                                  rycacti = g_ryc[l_ac].rycacti,
                                  rycpos  = g_ryc[l_ac].rycpos,  #FUN-C90090
                                  rycmodu = g_user,
                                  rycdate = g_today
                 WHERE ryc01=g_ryc_t.ryc01
                   AND ryc02=g_ryc_t.ryc02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ryc_file",g_ryc_t.ryc01,g_ryc_t.ryc02,SQLCA.sqlcode,"","",1) 
                 LET g_ryc[l_ac].* = g_ryc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
         
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ryc[l_ac].* = g_ryc_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_ryc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i040_bcl
              ROLLBACK WORK
             #FUN-C90090 Begin---
              IF g_aza.aza88 = 'Y' AND p_cmd = 'u' AND l_lock_sw = 'N' THEN
                 BEGIN WORK
                 UPDATE ryc_file SET rycpos = l_rycpos
                  WHERE ryc01 = g_ryc_t.ryc01
                    AND ryc02 = g_ryc_t.ryc02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","ryc_file",g_ryc_t.ryc01,"",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_ryc[l_ac].rycpos = l_rycpos
                 DISPLAY BY NAME g_ryc[l_ac].rycpos
                 COMMIT WORK
              END IF
             #FUN-C90090 End-----
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i040_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(ryc01) AND l_ac > 1 THEN
              LET g_ryc[l_ac].* = g_ryc[l_ac-1].*
              LET g_ryc[l_ac].ryc01= g_rec_b + 1
              NEXT FIELD ryc01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(ryc01)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.default1 = g_ryc[l_ac].ryc01
               CALL cl_create_qry() RETURNING g_ryc[l_ac].ryc01
               DISPLAY BY NAME g_ryc[l_ac].ryc01
               CALL i040_ryc01('d')
               NEXT FIELD ryc01
          
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
  
    CLOSE i040_bcl
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION i040_bp_refresh()
 
  DISPLAY ARRAY g_ryc TO s_ryc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION i040_out()                                                     
DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "apci040" "',g_wc2 CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
    
END FUNCTION                                                            
 
FUNCTION i040_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("ryc01,ryc02",TRUE) #FUN-C90090 Add ryc02
        END IF
END FUNCTION
 
FUNCTION i040_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ryc01,ryc02",FALSE) #FUN-C90090 Add ryc02
        END IF
END FUNCTION
#FUN-A30078 ADD
