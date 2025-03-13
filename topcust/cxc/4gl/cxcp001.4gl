DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/asf/4gl/sasfi501.global"
 
DEFINE g_renew   LIKE type_file.num5        
DEFINE g_sfb    DYNAMIC ARRAY OF RECORD
                  sfb01       LIKE sfb_file.sfb01,
                  sfb02       LIKE sfb_file.sfb02,   #设备号
                  sfb05       LIKE sfb_file.sfb05,
                  ima06_1     LIKE ima_file.ima06,
                  ima02_1     LIKE ima_file.ima02,
                  ima021_1    LIKE ima_file.ima021,
                  sfb08       LIKE sfb_file.sfb08,
                  sfb09       LIKE sfb_file.sfb09,
                  sfb38       LIKE sfb_file.sfb38,
                  tlf01       LIKE tlf_file.tlf01,
                  ima02_2     LIKE ima_file.ima02,
                  ima021_2    LIKE ima_file.ima021,
                  ima06_2     LIKE ima_file.ima06,
                  sfa08       LIKE sfa_file.sfa08,
                  sfa06       LIKE sfa_file.sfa06,
                  sfa062       LIKE sfa_file.sfa062,
                  tlf10       LIKE tlf_file.tlf10,
                  ktl         LIKE tlf_file.tlf10,
                  ccc23       LIKE ccc_file.ccc23,
                  a           LIKE type_file.num20_6,
                  b           LIKE type_file.num20_6,
                  c           LIKE type_file.num20_6
               END RECORD,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql,g_wc,g_wc3    STRING,
       g_rec_b        LIKE type_file.num5,          
       l_ac           LIKE type_file.num5        
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg           STRING                      #TQC-C80084 add
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_sum1,g_sum2 LIKE type_file.num20_6
DEFINE tm RECORD			      #
          y1           LIKE type_file.chr4,
          m1           LIKE type_file.chr2,
          y2           LIKE type_file.chr4,
          m2           LIKE type_file.chr2
      END RECORD
DEFINE g_sfq RECORD LIKE sfq_file.*
DEFINE g_sfs RECORD LIKE sfs_file.*
#DEFINE g_sfp RECORD LIKE sfp_file.*
DEFINE g_sfa RECORD LIKE sfa_file.*
DEFINE g_ima061   LIKE type_file.chr1000
DEFINE g_ima062   LIKE type_file.chr1000
DEFINE g_tlf01   LIKE type_file.chr1000
DEFINE g_dan   LIKE sfp_file.sfp01
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p001_w AT p_row,p_col WITH FORM "cxc/42f/cxcp001"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1

   LET g_sma.sma73 = 'N'  #luoyb
   CALL p001()
 
   CLOSE WINDOW p001_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
 
FUNCTION p001()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p001_cs()
      END IF
      CALL p001_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
 
 
 
FUNCTION p001_p1()
DEFINE i LIKE type_file.num5
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
         BEFORE ROW
             IF g_renew THEN
               LET l_ac = ARR_CURR()
               IF l_ac = 0 THEN
                  LET l_ac = 1
               END IF
             END IF
             CALL fgl_set_arr_curr(l_ac)
             CALL cl_show_fld_cont()
             LET g_renew = 1
 
             IF g_rec_b > 0 THEN
               CALL cl_set_act_visible("", TRUE)
             ELSE
               CALL cl_set_act_visible("", FALSE)
             END IF
 
         ON CHANGE b
            IF g_sfb[l_ac].b < 0 THEN 
               NEXT FIELD CURRENT
            ELSE 
                       
            LET  g_sfb[l_ac].c = g_sfb[l_ac].b * g_sfb[l_ac].ccc23 
            LET g_sum1 = 0 
            LET g_sum2 = 0 
            
            FOR i= 1 TO g_rec_b
                LET g_sum1 = g_sum1 + g_sfb[i].b
                LET g_sum2 = g_sum2 + g_sfb[i].c
            END FOR 
            DISPLAY g_sum1 TO sum1
            DISPLAY g_sum2 TO sum2
            END IF 
         ON ACTION sure1 
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CALL p001_sure1()
            CALL cl_set_act_visible("accept,cancel", FALSE)
         #str----mark by guanyao160427   
         #ON ACTION sure2 
         #   CALL cl_set_act_visible("accept,cancel", TRUE)
         #   CALL p001_sure2()
         #   CALL cl_set_act_visible("accept,cancel", FALSE)
         #end----mark by guanyao160427

         ON ACTION sure3
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CALL p001_change_rel_rel()
            CALL cl_set_act_visible("accept,cancel", FALSE)
            
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT

         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p001_cs()
   CLEAR FORM
   CALL g_sfb.clear()
   LET g_wc=''
   LET g_wc2=''
   LET g_wc3=''
   LET g_wc4=''
 
   CALL cl_set_act_visible("accept,cancel", TRUE)

   DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.y1,tm.m1,tm.y2,tm.m2 FROM y1,m1,y2,m2 ATTRIBUTE(WITHOUT DEFAULTS)

   BEFORE INPUT 
      SELECT substr(g_today,1,4) INTO tm.y1 FROM dual
      SELECT substr(g_today,1,4) INTO tm.y2 FROM dual
      SELECT substr(g_today,6,7) INTO tm.m1 FROM dual
      SELECT substr(g_today,6,7) INTO tm.m2 FROM dual

   END INPUT 

   CONSTRUCT g_wc ON ima061 FROM ima061

   BEFORE CONSTRUCT 
      CALL cl_qbe_init()
      
   AFTER FIELD ima061
      LET g_ima061=GET_FLDBUF(ima061)
      
      ON ACTION controlp
         CASE
               WHEN INFIELD(ima061)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima06"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima061
                  NEXT FIELD ima061
            END CASE  
   
   END CONSTRUCT

   CONSTRUCT g_wc3 ON ima062 FROM ima062 

   BEFORE CONSTRUCT 
      CALL cl_qbe_init()

   AFTER FIELD ima062
      LET g_ima062=GET_FLDBUF(ima062)
      
      ON ACTION controlp
         CASE
               WHEN INFIELD(ima062)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima06"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima062
                  NEXT FIELD ima062
            END CASE  
   
   END CONSTRUCT
   
     CONSTRUCT g_wc4 ON tlf01 FROM tlf01

   BEFORE CONSTRUCT 
      CALL cl_qbe_init()

   AFTER FIELD tlf01
      LET g_tlf01=GET_FLDBUF(tlf01)
      
      ON ACTION controlp
         CASE
               WHEN INFIELD(tlf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima01"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tlf01
                  NEXT FIELD tlf01
            END CASE  
   
   END CONSTRUCT
  

   CONSTRUCT g_wc2 ON sfb01,sfb02,sfb05,sfb38
                 FROM s_sfb[1].sfb01,s_sfb[1].sfb02,s_sfb[1].sfb05,s_sfb[1].sfb38
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
  
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb01"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01

               WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima01"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05

            END CASE 
            
   END CONSTRUCT
      ON ACTION ACCEPT 
         ACCEPT DIALOG 

      ON ACTION CANCEL 
         EXIT DIALOG 
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
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
   END DIALOG 
   
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      #RETURN        #TQC-760183
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM   #TQC-760183
   END IF
 
   CALL p001_b1_fill(g_wc2)
 
   LET l_ac = 1
 
END FUNCTION
 
FUNCTION p001_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
   DEFINE l_str1   STRING 
   DEFINE l_str2   STRING,
          l_sfa062 LIKE sfa_file.sfa062
          
   LET g_wc=cl_replace_str(g_wc,"ima061","ima06")
   LET g_wc3=cl_replace_str(g_wc3,"ima062","ima06")
   IF cl_null(g_wc) THEN 
      LET l_str1 = ' AND 1=1 ' 
   ELSE 
      LET l_str1 =   "  AND sfb05 in (SELECT ima01 FROM ima_file WHERE ",g_wc," )" 
   END IF 
   IF cl_null(g_wc3) THEN 
      LET l_str2 = ' AND 1=1 ' 
   ELSE 
      LET l_str2 =   "  AND a.sfa03 in (SELECT ima01 FROM ima_file WHERE ",g_wc3," )" 
   END IF 
   IF cl_null(p_wc2) THEN 
      LET p_wc2 =  ' 1=1 '
   END IF
    
   LET g_sql = " SELECT sfb01,sfb02,sfb05,'','','',            sfb08,sfb09+sfb12 sfb09,sfb38,a.sfa03,'','','',a.sfa08,a.sfa06,a.sfa062,  ",
               "   '',(sfb09+sfb12)*b.sfa161 ktl,'',0,0,0   FROM sfb_file,sfa_file a,sfa_file b ", 
               #"  FROM sfb_file,tlf_file,sfu_file,sfv_file ",
               "  WHERE ",p_wc2 CLIPPED,
               "  AND sfb04 = '8' ",
               "  AND a.sfa01 = sfb01 AND b.sfa01 = sfb01 AND a.sfa27 = b.sfa27 and b.sfa16<>0 and a.sfa08=b.sfa08",
              # "  AND ",tm.y1," = year(sfb36) ",
              # "  AND ",tm.m1," = month(sfb36) ",
              #"  AND ",tm.y1," = year(sfb37) ",
              #"  AND ",tm.m1," = month(sfb37) ",
               "  AND ",tm.y1," = year(sfb38) ",
               "  AND ",tm.m1," = month(sfb38) "
              # --"  AND tlf02 = 60 ",   #test
              #"  AND ",tm.y1," = year(tlf06) ",
              #"  AND ",tm.m1," = month(tlf06) ",
              # "  AND tlf13 like 'asfi51%' ",
              # "  AND tlf62 = sfb01 ",
              #add by zhaoxiangb 160419
              #  "  AND sfu01 = sfv01 AND sfv11 = sfb01 AND sfupost = 'Y' ",
              #  "  AND ",tm.y1," = year(sfu02) ",
              # "  AND ",tm.m1," = month(sfu02) ",
              #add by zhaoxiangb 160419
              #"  AND sfb08 > sfb09 ",  #add by zhaoxiangb 160407 生产数量大于完工入库数量
              IF NOT cl_null(g_tlf01) THEN
               LET g_sql = g_sql CLIPPED,"  AND a.sfa03='",g_tlf01,"'"
              END IF 
              # l_str1,
              # l_str2,
               #LET g_sql = g_sql CLIPPED,"  GROUP BY sfb01,sfb02,sfb05,sfb08,sfb09,sfb38,a.sfa03  ORDER BY sfb01 "  #依開單日期降冪
               LET g_sql = g_sql CLIPPED," ORDER BY sfb01 "  #依開單日期降冪
 
   PREPARE p001_pb1 FROM g_sql
   DECLARE sfb_curs CURSOR FOR p001_pb1
   display g_sql
   CALL g_sfb.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH sfb_curs INTO g_sfb[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
      SELECT ima02,ima021,ima06 INTO g_sfb[g_cnt].ima02_1,g_sfb[g_cnt].ima021_1,g_sfb[g_cnt].ima06_1 FROM ima_file WHERE ima01 = g_sfb[g_cnt].sfb05
      SELECT ima02,ima021,ima06 INTO g_sfb[g_cnt].ima02_2,g_sfb[g_cnt].ima021_2,g_sfb[g_cnt].ima06_2 FROM ima_file WHERE ima01 = g_sfb[g_cnt].tlf01
      SELECT ccc23 INTO g_sfb[g_cnt].ccc23 FROM ccc_file WHERE ccc01 = g_sfb[g_cnt].tlf01 AND ccc02 = tm.y2 AND ccc03 = tm.m2
      SELECT SUM(nvl(tlf10,0)) INTO g_sfb[g_cnt].tlf10 FROM tlf_file 
              WHERE tlf01 = g_sfb[g_cnt].tlf01 
                AND tlf62 = g_sfb[g_cnt].sfb01
                AND tlf13 LIKE 'asfi51%'
                --AND tlf02 = 60   #test
                AND tm.y1 = YEAR(tlf06)
                AND tm.m1 = MONTH(tlf06)
      LET g_sfb[g_cnt].a = g_sfb[g_cnt].ccc23 * g_sfb[g_cnt].tlf10
      
      SELECT SUM(tlf10*tlf907)*-1 INTO l_sfa062 FROM tlf_file  WHERE  1=1   
      AND tlf62=g_sfb[g_cnt].sfb01 AND tlf01=g_sfb[g_cnt].tlf01 AND tlf05=g_sfb[g_cnt].sfa08 
      
      IF g_sfb[g_cnt].sfa062>0 THEN
        LET g_sfb[g_cnt].ktl= l_sfa062-g_sfb[g_cnt].ktl
      END IF

      IF g_sfb[g_cnt].sfa062=0 AND g_sfb[g_cnt].sfa06>0 THEN
        LET g_sfb[g_cnt].ktl= l_sfa062-g_sfb[g_cnt].ktl
      END IF
      
      IF g_sfb[g_cnt].sfa06=0  THEN  LET g_sfb[g_cnt].ktl=0 END IF
            
      LET g_sfb[g_cnt].b = 0 
      LET g_sfb[g_cnt].c = 0 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_sfb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
END FUNCTION

FUNCTION p001_sure1()   #生成退料

     IF cl_confirm('cxc-002') THEN   #进一步确认
         CALL p001_gen_m_iss1() 
     END IF 
     
END FUNCTION  
#str----mark by guanyao160427
#FUNCTION p001_sure2()   #生成杂发单
#
#     IF cl_confirm('cxc-001') THEN   #进一步确认
#         #杂发单
#         CALL p001_gen_m_iss2() 
#     END IF 
#     
#END FUNCTION 
#end----mark by guanyao160427 

FUNCTION  p001_gen_m_iss1()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_str STRING  
DEFINE l_cnt LIKE type_file.num5
DEFINE l_x   LIKE type_file.num5 #项次
DEFINE i     LIKE type_file.num5
DEFINE g_sfb1 RECORD LIKE sfb_file.*

DEFINE g_t1  STRING 
DEFINE l_sfb08    LIKE  sfb_file.sfb08 
DEFINE l_sfb09    LIKE  sfb_file.sfb09
DEFINE l_sfb11    LIKE  sfb_file.sfb11
DEFINE b_sfs05    LIKE  sfs_file.sfs05
DEFINE b_sfa05    LIKE  sfa_file.sfa05
DEFINE b_sfa06    LIKE  sfa_file.sfa06   
DEFINE l_sfa05    LIKE  sfa_file.sfa05
DEFINE l_sfa06    LIKE  sfa_file.sfa06
DEFINE b_sfa28    LIKE  sfa_file.sfa28
DEFINE l_sfs05    LIKE  sfs_file.sfs05  
DEFINE l_qty      LIKE  type_file.num20_6
DEFINE l_sfa28    LIKE  sfa_file.sfa28
DEFINE l_sfa28_t  LIKE  sfa_file.sfa28
DEFINE l_sfa06_t  LIKE  sfa_file.sfa06
DEFINE l_sfa161_t LIKE  sfa_file.sfa161
DEFINE l_sub_qty  LIKE  type_file.num20_6
DEFINE l_sfa161   LIKE  sfa_file.sfa161
DEFINE sum_sfs05  LIKE  type_file.num20_6
DEFINE l_sfa100   LIKE  sfa_file.sfa100
DEFINE l_b        LIKE  type_file.num5
DEFINE l_no       LIKE type_file.chr20
DEFINE l_year,l_month LIKE type_file.chr100 
#str-----add by guanyao160427
DEFINE l_gen02_1  LIKE gen_file.gen02
DEFINE l_azf09    LIKE azf_file.azf09
#end-----add by guanyao160427


DEFINE tm RECORD
        ship   LIKE  oay_file.oayslip,
        peo    LIKE  gen_file.gen01,
        dat    LIKE  type_file.dat,
        stk    LIKE  inb_file.inb05,
        #str-----add by guanyao160427
        ship1   LIKE  oay_file.oayslip,  #No.FUN-680121      VARCHAR(5),
        dept    LIKE  gem_file.gem01,   #No.FUN-680121      VARCHAR(6),
        gem02   LIKE  gem_file.gem02,
        reas    LIKE  azf_file.azf01,   #No.FUN-680121      VARCHAR(4),
        peo1    LIKE  gen_file.gen01,
        gen02_1 LIKE  gen_file.gen02,
        dat1    LIKE  type_file.dat,
        pro     LIKE  type_file.chr20,
        azf03   LIKE  azf_file.azf03,
        loc     LIKE  ime_file.ime01
        #end----add by guanyao160427
          END RECORD 
DEFINE l_sql   STRING 
DEFINE l_sfa062t LIKE sfa_file.sfa062
DEFINE l_sfa01t LIKE sfa_file.sfa01
DEFINE l_sfa03t LIKE sfa_file.sfa03
DEFINE l_sfa08t LIKE sfa_file.sfa08
LET p_row = 10 LET p_col = 35
OPEN WINDOW i301_m_w AT p_row,p_col WITH FORM "cxc/42f/cxcp001n"
             ATTRIBUTE (STYLE = g_win_style CLIPPED)
CALL cl_ui_locale("cxcp001n")
INPUT BY NAME tm.ship,tm.peo,tm.dat,tm.stk,
              tm.ship1,tm.dept,tm.reas,tm.peo1,tm.dat1,tm.pro,tm.loc#add by guanyao160427
              WITHOUT DEFAULTS
BEFORE INPUT 
              LET tm.dat = g_today 
              LET tm.dat1 = g_today   #add by guanyao160427
              LET tm.ship = 'MRH'     #add by guanyao160427
              LET tm.reas = '3006'     #add by guanyao160427
              LET tm.stk = 'XBC'
              LET tm.peo='25181'
              LET tm.ship1 = 'CRB'
              #LET tm.dept = 'B1301'
              LET tm.dept='B16'   #add by neil  180309
              LET tm.peo1='20233'
              #LET tm.peo1 = 'B1301'
              DISPLAY BY NAME tm.dat
              DISPLAY BY NAME tm.dat1 #add by guanyao160427
              DISPLAY BY NAME tm.ship
              DISPLAY BY NAME tm.reas #add by guanyao160427
              DISPLAY BY NAME tm.stk
              DISPLAY BY NAME tm.peo
              DISPLAY BY NAME tm.peo1
              DISPLAY BY NAME tm.ship1
              DISPLAY BY NAME tm.dept
              #DISPLAY BY NAME tm.peo1
           AFTER FIELD peo
              IF cl_null(tm.peo) THEN 
                 NEXT FIELD CURRENT 
              ELSE 
                 SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01 = tm.peo
                 IF l_cnt = 0 THEN 
                    NEXT FIELD CURRENT 
                  ELSE 
                    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = tm.peo
                    DISPLAY l_gen02 TO gen02 
                  END IF 
              END IF 
              
           AFTER FIELD dat
              IF cl_null(tm.dat) THEN 
                 NEXT FIELD CURRENT 
              ELSE 
              END IF 
              
           AFTER FIELD ship
             IF cl_null(tm.ship) THEN
                NEXT FIELD ship
             ELSE
               CALL s_check_no("asf",tm.ship,'','4',"sfp_file","sfp01","")
                 RETURNING li_result,tm.ship
               DISPLAY BY NAME tm.ship
               IF (NOT li_result) THEN
                   NEXT FIELD ship
               END IF
             END IF

          AFTER FIELD stk
             IF NOT cl_null(tm.stk) THEN
                SELECT COUNT(*) INTO l_cnt FROM imd_file
                  WHERE imd01=tm.stk AND imd10='S'
                IF l_cnt < 0 THEN #倉庫別不存在
                   LET tm.stk=''
                   DISPLAY BY NAME tm.stk
                   NEXT FIELD stk
                END IF
                #Add No.FUN-AA0050
                IF NOT s_chk_ware(tm.stk) THEN  #检查仓库是否属于当前门店
                   NEXT FIELD stk
                END IF
                #End Add No.FUN-AA0050
             END IF

#str----------add by guanyao160427
          AFTER FIELD peo1
              IF cl_null(tm.peo1) THEN 
                 NEXT FIELD CURRENT 
              ELSE 
                 SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01 = tm.peo1
                 IF l_cnt = 0 THEN 
                    NEXT FIELD CURRENT 
                  ELSE 
                    SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = tm.peo1
                    DISPLAY l_gen02_1 TO gen02_1 
                  END IF 
              END IF 
              
           AFTER FIELD dat1
              IF cl_null(tm.dat1) THEN 
                 NEXT FIELD CURRENT 
              ELSE 
              END IF 
              
           AFTER FIELD pro
              IF cl_null(tm.pro) THEN 
                 NEXT FIELD CURRENT 
              ELSE
                 IF NOT cl_null(tm.pro) THEN 
                    SELECT count(*) FROM pja_fil2 WHERE pja01 = tm.pro
                    IF l_cnt = 0 THEN NEXT FIELD CURRENT ELSE END IF 
                 END IF 
              END IF 
           AFTER FIELD ship1
             IF cl_null(tm.ship1) THEN
                NEXT FIELD ship1
             ELSE
               CALL s_check_no("aim",tm.ship1,'','1',"ina_file","ina01","")
                 RETURNING li_result,tm.ship1
               DISPLAY BY NAME tm.ship1
               IF (NOT li_result) THEN
                   NEXT FIELD ship1
               END IF
             END IF

           AFTER FIELD dept
             IF cl_null(tm.dept) THEN
          NEXT FIELD dept
             ELSE
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                  WHERE gem01=tm.dept

                IF l_cnt = 0 THEN #部門別不存在
                   LET tm.dept=''
                   DISPLAY BY NAME tm.dept
                   NEXT FIELD dept
                ELSE
                  SELECT gem02 INTO tm.gem02 FROM gem_file
                    WHERE gem01=tm.dept
                  DISPLAY by NAME tm.gem02
                END IF
             END IF

           AFTER FIELD reas
             IF cl_null(tm.reas) THEN
          NEXT FIELD reas
             ELSE
                SELECT COUNT(*) INTO l_cnt FROM azf_file
                  WHERE azf01=tm.reas AND azf02='2'

                IF l_cnt < 0 THEN #理由碼不存在
                   LET tm.reas=''
                   DISPLAY BY NAME tm.reas
                   NEXT FIELD reas
                ELSE
                  LET l_azf09=' '      #MOD-B70035 add
                  SELECT azf03,azf09 INTO tm.azf03,l_azf09 FROM azf_file  #MOD-B70035 add azf09,l_azf09
                    WHERE azf01=tm.reas AND azf02='2'
                 #MOD-B70035---add---start---
                  IF l_azf09 !='4' OR cl_null(l_azf09) THEN
                     CALL cl_err('','aoo-403',0)
                     NEXT FIELD reas
                  END IF
                 #MOD-B70035---add---end---
                  DISPLAY by NAME tm.azf03
                END IF
             END IF
             
           AFTER FIELD loc
             IF cl_null(tm.loc) THEN LET tm.loc = ' ' END IF    #TQC-D50126
             IF NOT s_imechk(tm.stk,tm.loc) THEN
                LET tm.loc=''
                DISPLAY BY NAME tm.loc
                NEXT FIELD loc
             END IF
#end----------add by guanyao160427

          #FUN-D40103 -----Begin--------
          #   IF NOT s_imechk(tm.stk,tm.loc) THEN
          #      LET tm.stk=''
          #      DISPLAY BY NAME tm.stk
          #   #  NEXT FIELD stk    #TQC-D50126
          #      NEXT FIELD loc    #TQC-D50126
          #   END IF
             
           ON ACTION CONTROLP
              CASE
                WHEN INFIELD(ship)
                   LET g_t1 = s_get_doc_no(g_sfb1.sfb01)       #No.FUN-550067
                   CALL q_smy( FALSE,TRUE,g_t1,'ASF','4') RETURNING g_t1  #TQC-670008
                   LET tm.ship=g_t1     #No.FUN-550067
                   DISPLAY tm.ship TO ship
                   NEXT FIELD ship
                WHEN INFIELD(stk)
                   CALL q_imd_1(FALSE,TRUE,"","S",g_plant,"","")  #只能开当前门店的
                        RETURNING tm.stk
                   DISPLAY tm.stk TO stk
                   NEXT FIELD stk

                WHEN INFIELD(peo)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen" 
                   CALL cl_create_qry() RETURNING tm.peo
                   DISPLAY tm.peo TO peo
                   NEXT FIELD peo
          #str-----add by guanyao160427
               WHEN INFIELD(ship1)
                   LET g_t1 = s_get_doc_no(g_sfb1.sfb01)       #No.FUN-550067
                   CALL q_smy( FALSE,TRUE,g_t1,'AIM','1') RETURNING g_t1  #TQC-670008
                   LET tm.ship1=g_t1     #No.FUN-550067
                   DISPLAY tm.ship1 TO ship1
                   NEXT FIELD ship1
                WHEN INFIELD(dept)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gem"
                   CALL cl_create_qry() RETURNING tm.dept
                   DISPLAY tm.dept TO dept
                   NEXT FIELD dept
                WHEN INFIELD(reas)
                   CALL cl_init_qry_var()
                  #IET g_qryparam.form     = "q_azf"              #MOD-C60154 mark
                   LET g_qryparam.form ="q_azf01a"                #MOD-C60154 add
                  #IET g_qryparam.arg1='2'                        #MOD-C60154 mark
                   LET g_qryparam.arg1 = "4"                      #MOD-C60154 add
                   CALL cl_create_qry() RETURNING tm.reas
                   DISPLAY tm.reas TO reas
                   NEXT FIELD reas
                WHEN INFIELD(stk)
                  #Mod No.FUN-AA0050
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_imd"
                  #LET g_qryparam.arg1 = 'S'
                  #CALL cl_create_qry() RETURNING tm.stk
                   CALL q_imd_1(FALSE,TRUE,"","S",g_plant,"","")  #只能开当前门店的
                        RETURNING tm.stk
                  #End Mod No.FUN-AA0050
                   DISPLAY tm.stk TO stk
                   NEXT FIELD stk
                WHEN INFIELD(loc)
                  #Mod No.FUN-AA0050
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_ime1"
                  #LET g_qryparam.arg1 = 'S'
                  #CALL cl_create_qry() RETURNING tm.loc
                   CALL q_ime_2(FALSE,TRUE,"","","S",g_plant)
                        RETURNING tm.loc
                  #End Mod No.FUN-AA0050
                   DISPLAY tm.loc TO loc
                   NEXT FIELD loc
                WHEN INFIELD(peo1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen" 
                   CALL cl_create_qry() RETURNING tm.peo1
                   DISPLAY tm.peo1 TO peo1
                   NEXT FIELD peo1
                   
                 WHEN INFIELD(pro)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja2" 
                   CALL cl_create_qry() RETURNING tm.pro
                   DISPLAY tm.pro TO pro
                   NEXT FIELD pro
          #end-----add by guanyao160427
              END CASE

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT

           ON ACTION about
              CALL cl_about()

           ON ACTION controlg
              CALL cl_cmdask()

           ON ACTION help
              CALL cl_show_help()

        END INPUT

        IF INT_FLAG THEN
           LET INT_FLAG=0
           CLOSE WINDOW i301_m_w
        ELSE   #这里塞退料单
           FOR i = 1 TO g_rec_b  #检查可否退料
               IF g_sfb[i].b < 0 OR g_sfb[i].b IS NULL OR g_sfb[i].b = 0 THEN CONTINUE FOR END IF   #数量小于0 或者 空 不考虑
               SELECT COUNT(*) INTO l_cnt FROM snb_file WHERE snb01 = g_sfb[i].sfb01 AND snbconf = 'N' 
               IF l_cnt >= 1 THEN
                  CALL cl_err(g_sfb[i].sfb01,'asf-748',0)
                  RETURN 
               END IF
               SELECT * INTO g_sfb1.* FROM sfb_file WHERE sfb01 = g_sfb[i].sfb01
               CASE
                  WHEN STATUS = NOTFOUND
                       CALL cl_err(g_sfb[i].sfb01,'asf-312',1)
                       RETURN 
 
                  #WHEN g_sfb1.sfb04 = '8'
                  #     CALL cl_err(g_sfb[i].sfb01,'asf-345',1)
                  #     RETURN 
 
                  #WHEN g_sfb1.sfb04 < '4'
                  #     CALL cl_err(g_sfb[i].sfb01,'asf-570',1)
                  #     RETURN
                  
                  #mark 160407
                  #when g_sfb1.sfb08 <=  g_sfb1.sfb09
                  #     CALL cl_err(g_sfb[i].sfb01,'asf-920',1)
                  #     RETURN 
                  #与工单在制数比较,退料数量不可以大于工单在制数量
                  #IF g_sfb[i].b > g_sfb1.sfb081 - g_sfb1.sfb09 THEN
                  #   CALL cl_err(g_sfb[i].sfb01,'asf-907',1)  
                  #   RETURN 
                  #END IF
                  IF g_sfb[i].b > g_sfb[i].tlf10 THEN
                     CALL cl_err('','csf-002',1)
                     RETURN 
                  END IF 
                  
              END CASE
                          
           END FOR

           #塞sfb
           FOR i = 1 TO g_rec_b
            IF g_sfb[i].b > 0 THEN 
               IF l_str IS NULL THEN 
                      LET l_str = " (sfa01 = '" CLIPPED,g_sfb[i].sfb01 CLIPPED,"' and sfa03 = '" CLIPPED,g_sfb[i].tlf01 CLIPPED,"')"
                      LET l_sfa01t = g_sfb[i].sfb01
                      LET l_sfa03t = g_sfb[i].tlf01
                      LET l_sfa08t = g_sfb[i].sfa08
                  ELSE 
                      LET l_str = l_str," or (sfa01 = '" CLIPPED,g_sfb[i].sfb01 CLIPPED,"' and sfa03 = '" CLIPPED,g_sfb[i].tlf01 CLIPPED,"')"
               END IF 
            END IF 
		   END FOR
           BEGIN WORK 
             INITIALIZE g_sfq.* TO NULL
             INITIALIZE g_sfp.* TO NULL 
             INITIALIZE g_sfs.* TO NULL 
             INITIALIZE g_sfb1.* TO NULL 
           #塞sfp==============================
           LET g_sfp.sfp01 = tm.ship
           LET g_sfp.sfp02 = tm.dat
           CALL s_auto_assign_no("asf",g_sfp.sfp01,g_sfp.sfp02,"","sfp_file","sfp01","","","")
                RETURNING li_result,g_sfp.sfp01
           IF (NOT li_result) THEN
             ROLLBACK WORK
             CALL cl_err('','',1)
             RETURN 
           END IF
           LET g_sfp.sfp03 = tm.dat
           LET g_sfp.sfp04 = "N"
           LET g_sfp.sfp05 = "N"
           SELECT SFA062 INTO l_sfa062t FROM sfa_file WHERE sfa01 = l_sfa01t AND sfa03=l_sfa03t and sfa08=l_sfa08t
           IF l_sfa062t>0 THEN
           LET g_sfp.sfp06 = "7"
         ELSE
         	 LET g_sfp.sfp06 = "8"
         	 END IF
           SELECT gen03 INTO g_sfp.sfp07,g_sfp.sfpgrup,g_sfp.sfporig FROM gen_file WHERE gen01 = tm.peo
           LET g_sfp.sfp09 = "N"
           LET g_sfp.sfpuser = tm.peo
           LET g_sfp.sfpdate = tm.dat
           LET g_sfp.sfpconf = "N"
           LET g_sfp.sfpplant = g_plant
           LET g_sfp.sfplegal = g_plant
           LET g_sfp.sfporiu = tm.peo
           LET g_sfp.sfp15 = "0"
           LET g_sfp.sfp16 = tm.peo
           SELECT smyapr INTO g_sfp.sfpmksg FROM smy_file WHERE smyslip = tm.ship
           INSERT INTO sfp_file VALUES g_sfp.*
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err('','cxc-005',0)
                LET g_success='N'
                RETURN 
           END IF 
           #塞sfs=================================== 
	       LET g_sql = " SELECT * FROM sfa_file WHERE ",l_str," AND sfa05 > 0 " 
           PREPARE p001_s1 FROM g_sql
           DECLARE p001_curs1 CURSOR FOR p001_s1
           LET l_x = 1
           FOREACH p001_curs1 INTO g_sfa.*
               SELECT COUNT(*) INTO l_cnt FROM snb_file
               WHERE snb01 = g_sfa.sfa01
                 AND snbconf != 'X'
                 AND snb99 != '2'
                   IF l_cnt > 0 THEN
                      CALL cl_err('check sfs','asf-068',0)
                      RETURN 
                  END IF
              
               LET g_sfs.sfs01 = g_sfp.sfp01
               LET g_sfs.sfs02 = l_x
               LET g_sfs.sfs03 = g_sfa.sfa01
               LET g_sfs.sfs04 = g_sfa.sfa03
               SELECT ima25 INTO g_sfs.sfs25 FROM ima_file WHERE ima01 = g_sfa.sfa03
               SELECT ima63 INTO g_sfs.sfs06 FROM ima_file WHERE ima01 = g_sfa.sfa03
               LET g_sfs.sfs07 = tm.stk
               LET g_sfs.sfs08 = " "
               LET g_sfs.sfs09 = " "
               SELECT sfa08 INTO g_sfs.sfs10 FROM sfa_file WHERE sfa01 = g_sfa.sfa01 AND sfa03=g_sfa.sfa03 AND sfa08=g_sfa.sfa08
               LET g_sfs.sfs27 = g_sfa.sfa03
               LET g_sfs.sfs28 = 1
               LET g_sfs.sfsplant = g_plant
               LET g_sfs.sfslegal = g_plant
               LET g_sfs.sfs012 = g_sfa.sfa012
               LET g_sfs.sfs013 = g_sfa.sfa013
               LET g_sfs.sfs014 = " "
               #-------------------退料数量的逻辑---------------------------------------
               FOR i = 1 TO g_rec_b
                   IF g_sfb[i].sfb01 = g_sfa.sfa01 AND g_sfb[i].tlf01 = g_sfa.sfa27 THEN 
                      LET g_sfs.sfs05 = g_sfb[i].b
                      EXIT FOR 
                   END IF 
               END FOR
                
                ###add by liyjf190117 str无料可退的时候不应产生退料单
                IF g_sfa.sfa06 - g_sfs.sfs05 < 0 THEN 
                   CALL cl_err('check sfs','asf-460',0)
                   RETURN 
                END IF
               ###add by liyjf190117 
                 
               {#mark------------------------------------------------------------------     
               #-------------------after field sfs05 的逻辑----sasfi501----------------
                IF (g_sfp.sfp06 = '8') AND (g_sfa.sfa11 <> 'S') THEN    #一般退料      #FUN-9C0040
                   SELECT sfb08,sfb09,sfb11 INTO l_sfb08,l_sfb09,l_sfb11 FROM sfb_file  #已發-完工   #No.MOD-760050 add sfb11 #MOD-940347 add sfb08,l_sfb08
                   WHERE sfb01 = g_sfs.sfs03   #工單  
                   LET b_sfs05 = 0
                   SELECT SUM(sfs05) INTO b_sfs05 FROM sfs_file,sfp_file
                    WHERE sfs01=sfp01
                      AND sfs03 = g_sfs.sfs03
                      AND sfs04 = g_sfs.sfs04
                      AND (sfp01 != g_sfp.sfp01 OR 
                           (sfp01 = g_sfp.sfp01 AND sfs02 != g_sfs.sfs02))
                      AND sfp06 = '8'
                      AND sfpconf != 'X' 
                   IF cl_null(b_sfs05) THEN LET b_sfs05 = 0 END IF
                   IF g_sfs.sfs05 > ((g_sfa.sfa06 + g_sfa.sfa062)-b_sfs05) AND g_sfa.sfa05 > 0 THEN    #No:MOD-B70204 add sfa05 > 0
#                         CALL cl_err(g_sfs.sfs05,'asf-708',1)
#                         CONTINUE FOREACH    
                   END IF
                   LET l_sfa05 = 0
                   LET l_sfa06 = 0
                   DECLARE sfa_curs CURSOR FOR
                   SELECT (sfa05/sfa28),(sfa06/sfa28)
                     FROM sfa_file
                   WHERE sfa01 = g_sfs.sfs03
                   AND sfa27 = g_sfa.sfa27               #110215
                   AND sfa08=g_sfs.sfs10
                   FOREACH sfa_curs INTO b_sfa05,b_sfa06
                       LET l_sfa05 = l_sfa05 + b_sfa05
                       LET l_sfa06 = l_sfa06 + b_sfa06
                   END FOREACH
                                                                                                                                                         LET b_sfs05 = 0
                   LET b_sfa28 = 0
                   LET l_sfs05 = 0
                   DECLARE sfs05_curs CURSOR FOR
                   SELECT sfs05,sfa28 FROM sfs_file,sfa_file     
                   WHERE sfs01=g_sfp.sfp01 AND sfs03=g_sfs.sfs03
                   AND sfa27 = g_sfa.sfa27 AND sfs10 = g_sfs.sfs10         
                   AND sfa01 = sfs03 AND sfa03 = sfs04                       
                   AND sfs02!=g_sfs.sfs02                              
                   FOREACH sfs05_curs INTO b_sfs05,b_sfa28
                      LET sum_sfs05 = b_sfs05/b_sfa28
                      LET l_sfs05 = l_sfs05 + sum_sfs05
                   END FOREACH
                                                                                                                                                                                                                    
                   IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF                                                                                                                       
                   IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF   #No.TQC-6C0122 add
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF                                                                                                                                           
                   IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF                                                                                                                                                            
                   IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF                                                                                                                                 
                   IF cl_null(l_sfa28) THEN LET l_sfa28 = 0 END IF                                                                                                                                       
                   IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
                   IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF       #MOD-940347 add
                   IF cl_null(l_sfb11) THEN LET l_sfb11 = 0 END IF
                  
                  #一般退料考慮誤差率sfa100
                  IF cl_null(g_sfa.sfa100) THEN LET g_sfa.sfa100 = 0 END IF
                  IF g_sma.sma899 = 'Y' THEN 
                     #已發/應發*生產套數*誤差率
                     IF g_sfa.sfa100 = 100 THEN
                        LET l_qty = l_sfa06 - g_sfs.sfs05-l_sfs05 
                     ELSE
                       LET l_qty = (((l_sfa06-g_sfs.sfs05-l_sfs05)/l_sfa05) * l_sfb08 * (1+g_sfa.sfa100/100))             #MOD-B20062 mark
                        LET l_qty = (((l_sfa06-(g_sfs.sfs05/l_sfa28)-l_sfs05)/l_sfa05) * l_sfb08 * (1+g_sfa.sfa100/100))   #MOD-B20062 add
                        #已發料(扣除退料數) - 入庫數(含FQC)
                        LET l_qty = l_qty - (l_sfb09+l_sfb11)
                     END IF       #No:MOD-970298 add
                     IF l_qty < 0 THEN                                                                                                                                   
#                        CALL cl_err(g_sfs.sfs04,'asf-705',1)  #No.MOD-830099 modify
#                        CONTINUE FOREACH                                                                                                                                             
                     END IF                                                                                                                                                                
                  ELSE
                     LET l_qty = l_sfa06 - ((l_sfb09 + l_sfb11) * g_sfa.sfa161) - l_sfs05
                  END IF  #MOD-8B0230

                   IF g_sfa.sfa26 MATCHES '[8]' THEN
                      SELECT sfa28
                        INTO l_sfa28_t
                        FROM sfa_file WHERE sfa01 = g_sfs.sfs03
                        AND sfa27 = g_sfs.sfs04
                        AND sfa26 ='Z'
                      IF cl_null(l_sfa28_t) THEN LET l_sfa28_t = 0 END IF
                      LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05
                   END IF
                   IF g_sfa.sfa26 MATCHES '[Zz]' THEN
                      SELECT sfa06,sfa161 INTO l_sfa06_t,l_sfa161_t  #FUN-B50059
                       FROM sfa_file
                       WHERE sfa01 = g_sfs.sfs03
                         AND sfa03 = g_sfa.sfa27

                      IF cl_null(l_sfa06_t) THEN LET l_sfa06_t = 0 END IF
                      IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF
                      LET l_qty = 0

                      LET l_sub_qty = 0
                      SELECT SUM(sfs05/(sfa28*l_sfa161_t)) INTO l_sub_qty
                        FROM sfs_file,sfa_file
                        WHERE sfs01 = g_sfp.sfp01
                          AND sfs03 = g_sfs.sfs03
                          AND sfs04 != g_sfs.sfs04
                          AND sfa01 = sfs03
                          AND sfa27 = g_sfa.sfa27
                          AND sfa03 = sfs04
                          AND (sfa26 = 'Z' OR sfa26 = 'z')
                      IF cl_null(l_sub_qty) THEN LET l_sub_qty = 0 END IF
                      LET l_qty=l_sfb09-l_sub_qty-(l_sfa06_t/l_sfa161_t)
                      IF l_qty < 0 THEN
                         LET l_qty = 0
                      END IF
                      LET l_qty=l_sfa06-(l_qty*l_sfa161_t*l_sfa28)-l_sfs05
                   END IF

                                                                                                                                                                                                                 
                   IF l_sfa05 < 0 THEN
                      LET l_qty = (l_sfa05* -1) - l_sfs05                                                                                                                              
                   END IF                                                                                                                                                    
                                                                                                                                                                
                  IF g_sfs.sfs05 > l_qty AND g_sma.sma899 ='N' THEN   #MOD-8B0230 add sma899  #MOD-B20062 mark                                                                                                                 
                   IF (g_sfs.sfs05/l_sfa28) > l_qty AND g_sma.sma899 ='N' THEN                 #MOD-B20062 add                                                                                                                           
#                      CALL cl_err(' ','asf-705',1)
#                      CONTINUE FOREACH                                                                                                                                                   
                   END IF                                                                                                                                                                
                END IF
                IF g_sfa.sfa11='S' THEN 
                     
                  SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file                                                                                                                         
                  WHERE sfs01=g_sfp.sfp01 AND sfs03=g_sfs.sfs03
                  AND sfs04=g_sfs.sfs04 AND sfs10=g_sfs.sfs10                                                                                                                            
                  AND sfs02!=g_sfs.sfs02                                                                                                                                                               
                                                                                                                                                                                                                   
                  IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF                                                                                                                       
                  IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF                                                                                                                                           
                  IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF                                                                                                                                                            
                  IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF                                                                                                                                 
                  IF cl_null(l_sfa28) THEN LET l_sfa28 = 0 END IF                                                                                                                                       
                  IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
                  IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
                  IF cl_null(l_sfb11) THEN LET l_sfb11 = 0 END IF

                  IF l_sfa06 < 0 THEN LET l_sfa06 = l_sfa06 * (-1) END IF
                  IF l_sfa161< 0 THEN LET l_sfa06 = l_sfa06 * (-1) END IF
                  IF l_sfa05 < 0 THEN LET l_sfa05 = l_sfa05 * (-1) END IF

                  #一般退料考慮誤差率sfa100
                  IF cl_null(l_sfa100) THEN LET l_sfa100 = 0 END IF
                  IF g_sma.sma899 = 'Y' THEN
                     #已發/應發*生產套數*誤差率
                     LET l_qty = (l_sfa05 * (1+g_sfa.sfa100/100))-l_sfa06-g_sfs.sfs05-l_sfs05
                  ELSE  #FUN-9C0040
                     LET l_qty = l_sfa05 - l_sfa06-g_sfs.sfs05-l_sfs05 #FUN-9C0040
                  END IF #FUN-9C0040 
                  IF l_qty < 0 THEN                                                                                                                                   
#                     CALL cl_err(g_sfs.sfs04,'asf-705',1)
#                     CONTINUE FOREACH                                                                                                                                                     
                  END IF                                                                                                                                                                
                END IF
               #---------------------------------------------------------------------
               #---------------------------------------------------------------------}
               INSERT INTO sfs_file VALUES g_sfs.*
               #str----add by guanyao160426
               IF NOT cl_null(g_sfs.sfs01) THEN
                  LET l_year= year(g_today)
                  LET l_year= l_year[3,4]
                  LET l_year = l_year USING '&&'
                  LET l_month = MONTH(g_today)
                  LET l_month = l_month USING '&&'
                  LET g_dan = 'YYYY-' CLIPPED,l_year CLIPPED,l_month CLIPPED
                  LET l_sql = "SELECT MAX(substr(tc_ree01,-4)) from tc_ree_file where tc_ree01 LIKE '"CLIPPED ,g_dan,"%'" CLIPPED 
                  PREPARE l_no_sql1 FROM l_sql
                  EXECUTE l_no_sql1 INTO l_no
                  IF cl_null(l_no) THEN
                     LET l_no = '0001'
                  ELSE 
                     LET l_no = l_no +1
                     LET l_no = l_no USING '&&&&'
                  END IF
                  LET g_dan = g_dan CLIPPED,l_no 
                  INSERT INTO tc_ree_file
                     VALUES (g_dan,g_today,g_sfa.sfa01,g_sfs.sfs01,g_sfa.sfa03,g_sfs.sfs05,'Y','','','','')
               END IF 
               #end----add by guanyao160426
               #str---add by guanyao160425#没有此仓库移动数据的时候需要插入一笔
               SELECT count(*) INTO l_b FROM img_file 
                WHERE img01 = g_sfs.sfs04
                  AND img02 = g_sfs.sfs07
                  AND img03 = g_sfs.sfs08
                  AND img04 = g_sfs.sfs09
               IF l_b = 0 OR cl_null(l_b) THEN 
                  CALL s_add_img(g_sfs.sfs04,g_sfs.sfs07,g_sfs.sfs08,g_sfs.sfs09,'','',g_today)
               END IF 
               #end---add by guanyao160425
               LET l_x = l_x + 1
           #END IF    
           END FOREACH 
           
           CLOSE WINDOW i301_m_w
            IF  g_sfs.sfs01 IS NOT NULL THEN 
                COMMIT  WORK 
                #审核
                CALL i501_y_chk()
                IF g_success = "Y" THEN
                      CALL i501_y_upd()
                END IF
                IF g_success ="Y" THEN 
                    #过账
                    CALL i501sub_s(2,g_sfp.sfp01,FALSE,'Y')
                    IF g_success = "Y" THEN 
                       CALL cl_err(g_sfs.sfs01,'cxc-007',1)
                       CALL p001_gen_m_iss2(tm.ship1,tm.dept,tm.reas,tm.peo1,tm.dat1,tm.pro,tm.loc,tm.stk) #add by gaunyao160427
                    ELSE 
                       CALL cl_err(g_sfs.sfs01,'cxc-008',1)
                    END IF 
                ELSE  #生成ok，审核失败，过账失败
                    CALL cl_err(g_sfs.sfs01,'cxc-006',1)
                    ROLLBACK WORK  
                END IF 
            ELSE
               #生成失败
                CALL cl_err(g_sfs.sfs01,'cxc-005',1)
                ROLLBACK WORK
            END IF 
      END IF 
END FUNCTION 


#FUNCTION p001_gen_m_iss2()#make by guanyao160427
FUNCTION p001_gen_m_iss2(p_ship,p_dept,p_reas,p_peo,p_dat,p_pro,p_loc,p_stk) #add by guanyao160427
DEFINE l_cnt  LIKE type_file.num10      #No.FUN-680121 INTEGER
DEFINE li_result LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE l_sno     LIKE type_file.num10   #No.FUN-680121 INTEGER
#str----add by guanyao160427
DEFINE p_ship     LIKE  oay_file.oayslip,
       p_dept     LIKE gem_file.gem01,
       p_reas     LIKE azf_file.azf01,
       p_peo      LIKE  gen_file.gen01,
       p_dat      LIKE  type_file.dat,
       p_pro      LIKE  type_file.chr20,
       p_loc      LIKE  ime_file.ime01,
       p_stk      LIKE  inb_file.inb05
#end----add by guanyao160427
DEFINE tm RECORD
        ship    LIKE  oay_file.oayslip,  #No.FUN-680121      VARCHAR(5),
        dept    LIKE  gem_file.gem01,   #No.FUN-680121      VARCHAR(6),
        gem02   LIKE  gem_file.gem02,
        reas    LIKE  azf_file.azf01,   #No.FUN-680121      VARCHAR(4),
        peo     LIKE  gen_file.gen01,
        gen02   LIKE  gen_file.gen02,
        dat     LIKE  type_file.dat,
        pro     LIKE  type_file.chr20,
        stk     LIKE  inb_file.inb05,   #No.FUN-680121      VARCHAR(10),
        azf03   LIKE  azf_file.azf03,
        loc     LIKE  ime_file.ime01    #No.FUN-680121      VARCHAR(10)
        END RECORD

DEFINE g_ina RECORD LIKE ina_file.*
DEFINE g_inb RECORD LIKE inb_file.*
DEFINE g_sfb2 RECORD LIKE sfb_file.*
DEFINE l_unit1 LIKE inb_file.inb08
DEFINE l_cmd        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(100)
DEFINE p_row        LIKE type_file.num10,   #No.FUN-680121 INTEGER,
       p_col        LIKE type_file.num10    #No.FUN-680121 INTEGER

DEFINE l_err        STRING
DEFINE l_sfb98      LIKE sfb_file.sfb98 #FUN-670103
DEFINE l_rvbs       RECORD LIKE rvbs_file.*   #FUN-810045
DEFINE l_azf09      LIKE azf_file.azf09     #MOD-B70035 add
DEFINE l_ima24      LIKE ima_file.ima24     #TQC-BC0120 add
DEFINE i            LIKE type_file.num5
DEFINE l_str        STRING 
DEFINE g_t1         LIKE oay_file.oayslip
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE lll_sfa01    LIKE sfa_file.sfa01
FOR i = 1 TO g_rec_b  #check
  INITIALIZE g_ina.* TO NULL
  INITIALIZE g_inb.* TO NULL
  INITIALIZE g_sfb2.* TO NULL

  IF g_sfb[i].b IS NULL OR g_sfb[i].b = 0 OR g_sfb[i].b < 0 THEN CONTINUE FOR END IF 
  SELECT * INTO g_sfb2.* FROM sfb_file WHERE sfb01 = g_sfb[i].sfb01

  IF g_sfb2.sfb43 MATCHES '[Ss]' THEN     #No:MOD-9C0040 modify
     CALL cl_err(g_sfb2.sfb01,'mfg3557',0)
     RETURN
  END IF
  IF g_sfb2.sfb87 = 'N' THEN
     CALL cl_err(g_sfb2.sfb01,'alm-007',0)
     RETURN
  END IF
  IF g_sfb2.sfb43 MATCHES '[Ss]' THEN     #No:MOD-9C0040 modify
     CALL cl_err(g_sfb2.sfb01,'mfg3557',0)
     RETURN
  END IF

  IF ( g_sfb2.sfb87='Y' ) THEN
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM ima_file
      WHERE ima01 IN (SELECT sfa03 FROM sfa_file WHERE sfa01 = g_sfb2.sfb01)
        AND imaacti ='Y'
     IF l_cnt = 0 THEN  RETURN  END IF

#    如已產生過雜發單不可再重新產生
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM ina_file
       WHERE ina10 = g_sfb2.sfb01 and inapost <> 'X'
      IF l_cnt > 0 THEN RETURN END IF 
  ELSE 
     RETURN 
  END IF 
END FOR 
#str-----add by guanyao160427
   LET tm.ship= p_ship  
   LET tm.dept= p_dept
   LET tm.reas= p_reas
   LET tm.peo= p_peo     
   LET tm.dat= p_dat     
   LET tm.pro= p_pro      
   LET tm.loc= p_loc 
   LET tm.stk= p_stk   
#end-----add by guanyao160427
#str------mark by guanyao160427
       { LET p_row = 10 LET p_col = 35

        OPEN WINDOW i301_m_w AT p_row,p_col WITH FORM "cxc/42f/cxcp001m"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

        CALL cl_ui_locale("cxcp001m")
        INPUT BY NAME tm.ship,tm.dept,tm.reas,tm.peo,tm.dat,tm.pro,tm.stk,tm.loc
              WITHOUT DEFAULTS
           BEFORE INPUT 
              LET tm.dat = g_today 
              DISPLAY BY NAME tm.dat
           AFTER FIELD peo
              IF cl_null(tm.peo) THEN 
                 NEXT FIELD CURRENT 
              ELSE 
                 SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01 = tm.peo
                 IF l_cnt = 0 THEN 
                    NEXT FIELD CURRENT 
                  ELSE 
                    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = tm.peo
                    DISPLAY l_gen02 TO gen02 
                  END IF 
              END IF 
              
           AFTER FIELD dat
              IF cl_null(tm.dat) THEN 
                 NEXT FIELD CURRENT 
              ELSE 
              END IF 
              
           AFTER FIELD pro
              #str----mark by guanyao160425
              #IF cl_null(tm.pro) THEN 
              #   NEXT FIELD CURRENT 
              #ELSE
              IF NOT cl_null(tm.pro) THEN 
              #end----add by guanyao160425
                SELECT count(*) FROM pja_fil2 WHERE pja01 = tm.pro
                IF l_cnt = 0 THEN NEXT FIELD CURRENT ELSE END IF 
              END IF 
           AFTER FIELD ship
             IF cl_null(tm.ship) THEN
                NEXT FIELD ship
             ELSE
               CALL s_check_no("aim",tm.ship,'','1',"ina_file","ina01","")
                 RETURNING li_result,tm.ship
               DISPLAY BY NAME tm.ship
               IF (NOT li_result) THEN
                   NEXT FIELD ship
               END IF
             END IF

           AFTER FIELD dept
             IF cl_null(tm.dept) THEN
          NEXT FIELD dept
             ELSE
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                  WHERE gem01=tm.dept

                IF l_cnt = 0 THEN #部門別不存在
                   LET tm.dept=''
                   DISPLAY BY NAME tm.dept
                   NEXT FIELD dept
                ELSE
                  SELECT gem02 INTO tm.gem02 FROM gem_file
                    WHERE gem01=tm.dept
                  DISPLAY by NAME tm.gem02
                END IF
             END IF

           AFTER FIELD reas
             IF cl_null(tm.reas) THEN
          NEXT FIELD reas
             ELSE
                SELECT COUNT(*) INTO l_cnt FROM azf_file
                  WHERE azf01=tm.reas AND azf02='2'

                IF l_cnt < 0 THEN #理由碼不存在
                   LET tm.reas=''
                   DISPLAY BY NAME tm.reas
                   NEXT FIELD reas
                ELSE
                  LET l_azf09=' '      #MOD-B70035 add
                  SELECT azf03,azf09 INTO tm.azf03,l_azf09 FROM azf_file  #MOD-B70035 add azf09,l_azf09
                    WHERE azf01=tm.reas AND azf02='2'
                 #MOD-B70035---add---start---
                  IF l_azf09 !='4' OR cl_null(l_azf09) THEN
                     CALL cl_err('','aoo-403',0)
                     NEXT FIELD reas
                  END IF
                 #MOD-B70035---add---end---
                  DISPLAY by NAME tm.azf03
                END IF
             END IF

           AFTER FIELD stk
             IF NOT cl_null(tm.stk) THEN
                SELECT COUNT(*) INTO l_cnt FROM imd_file
                  WHERE imd01=tm.stk AND imd10='S'
                IF l_cnt < 0 THEN #倉庫別不存在
                   LET tm.stk=''
                   DISPLAY BY NAME tm.stk
                   NEXT FIELD stk
                END IF
                #Add No.FUN-AA0050
                IF NOT s_chk_ware(tm.stk) THEN  #检查仓库是否属于当前门店
                   NEXT FIELD stk
                END IF
                #End Add No.FUN-AA0050
             END IF

          #FUN-D40103 -----Begin--------
             IF NOT s_imechk(tm.stk,tm.loc) THEN
                LET tm.stk=''
                DISPLAY BY NAME tm.stk
             #  NEXT FIELD stk    #TQC-D50126
                NEXT FIELD loc    #TQC-D50126
             END IF
          #FUN-D40103 -----End----------
           AFTER FIELD loc
           #FUN-D40103 -----Begin------
            #IF NOT cl_null(tm.loc) THEN
            #   SELECT COUNT(*) INTO l_cnt FROM ime_file
            #     WHERE ime01=tm.loc

            #   IF l_cnt < 0 THEN #儲位不存在
            #      CALL cl_err('','asf-951',1)
            #      LET tm.loc=''
            #      DISPLAY BY NAME tm.stk
            #      NEXT FIELD loc
            #   END IF

            #END IF
             IF cl_null(tm.loc) THEN LET tm.loc = ' ' END IF    #TQC-D50126
             IF NOT s_imechk(tm.stk,tm.loc) THEN
                LET tm.loc=''
                DISPLAY BY NAME tm.loc
                NEXT FIELD loc
             END IF
           #FUN-D40103 -----End--------

           ON ACTION CONTROLP
              CASE
                WHEN INFIELD(ship)
                   LET g_t1 = s_get_doc_no(g_sfb2.sfb01)       #No.FUN-550067
                   CALL q_smy( FALSE,TRUE,g_t1,'AIM','1') RETURNING g_t1  #TQC-670008
                   LET tm.ship=g_t1     #No.FUN-550067
                   DISPLAY tm.ship TO ship
                   NEXT FIELD ship
                WHEN INFIELD(dept)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gem"
                   CALL cl_create_qry() RETURNING tm.dept
                   DISPLAY tm.dept TO dept
                   NEXT FIELD dept
                WHEN INFIELD(reas)
                   CALL cl_init_qry_var()
                  #IET g_qryparam.form     = "q_azf"              #MOD-C60154 mark
                   LET g_qryparam.form ="q_azf01a"                #MOD-C60154 add
                  #IET g_qryparam.arg1='2'                        #MOD-C60154 mark
                   LET g_qryparam.arg1 = "4"                      #MOD-C60154 add
                   CALL cl_create_qry() RETURNING tm.reas
                   DISPLAY tm.reas TO reas
                   NEXT FIELD reas
                WHEN INFIELD(stk)
                  #Mod No.FUN-AA0050
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_imd"
                  #LET g_qryparam.arg1 = 'S'
                  #CALL cl_create_qry() RETURNING tm.stk
                   CALL q_imd_1(FALSE,TRUE,"","S",g_plant,"","")  #只能开当前门店的
                        RETURNING tm.stk
                  #End Mod No.FUN-AA0050
                   DISPLAY tm.stk TO stk
                   NEXT FIELD stk
                WHEN INFIELD(loc)
                  #Mod No.FUN-AA0050
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_ime1"
                  #LET g_qryparam.arg1 = 'S'
                  #CALL cl_create_qry() RETURNING tm.loc
                   CALL q_ime_2(FALSE,TRUE,"","","S",g_plant)
                        RETURNING tm.loc
                  #End Mod No.FUN-AA0050
                   DISPLAY tm.loc TO loc
                   NEXT FIELD loc
                WHEN INFIELD(peo)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen" 
                   CALL cl_create_qry() RETURNING tm.peo
                   DISPLAY tm.peo TO peo
                   NEXT FIELD peo
                   
                 WHEN INFIELD(pro)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja2" 
                   CALL cl_create_qry() RETURNING tm.pro
                   DISPLAY tm.pro TO pro
                   NEXT FIELD pro
          END CASE

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT

           ON ACTION about
              CALL cl_about()

           ON ACTION controlg
              CALL cl_cmdask()

           ON ACTION help
              CALL cl_show_help()

        END INPUT

        IF INT_FLAG THEN
           LET INT_FLAG=0
           CLOSE WINDOW i301_m_w
        ELSE}
#end------mark by guanyao160427
     #塞雜發單
           BEGIN WORK
           INITIALIZE g_ina.* TO NULL
           LET g_ina.ina00   = '1'
           #LET g_ina.ina14   = '1'
           LET g_ina.ina02   = tm.dat
           LET g_ina.ina03   = tm.dat
           LET g_ina.ina04   = tm.dept
           #LET g_ina.ina06   = g_sfb2.sfb27    #TQC-C10041
           #LET g_ina.ina10   = g_sfb2.sfb01
           LET g_ina.ina11   = tm.peo
           LET g_ina.ina08   = '0'              #No.MOD-760148 add
           LET g_ina.ina11   = tm.peo
           LET g_ina.inaprsw = 0
           LET g_ina.inapost = 'N'
           LET g_ina.inaconf = 'N'              #MOD-920188 add
           LET g_ina.inauser = tm.peo
           SELECT gen03 INTO g_ina.inagrup FROM gen_file WHERE gen01 = tm.peo
           LET g_ina.inamodu = ''
           LET g_ina.inadate = tm.dat
           LET g_ina.inamksg = g_smy.smyapr     #No.MOD-760148 add
           LET g_ina.inaplant = g_plant #FUN-980008 add
           LET g_ina.inalegal = g_legal #FUN-980008 add
           LET g_ina.ina12 = 'N'        #FUN-870100 ADD
           LET g_ina.inapos = 'N'       #FUN-870100 ADD

           CALL s_auto_assign_no("aim",tm.ship,g_ina.ina03,'1',"ina_file","ina01","","","")
               RETURNING li_result,g_ina.ina01

           LET g_ina.inaoriu = tm.peo      #No.FUN-980030 10/01/04
           LET g_ina.inaorig = g_ina.inagrup     #No.FUN-980030 10/01/04
           INSERT INTO ina_file VALUES(g_ina.*)

           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","ins ina:",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF


           SELECT sfb98 INTO l_sfb98 FROM sfb_file
                                    WHERE sfb01=g_sfb2.sfb01
           IF SQLCA.sqlcode THEN
              LET l_sfb98=NULL
           END IF
           LET l_sno = 0
           LET l_str =  ''
           FOR i = 1 TO g_rec_b
              IF g_sfb[i].b > 0 AND g_sfb[i].b IS NOT NULL THEN 
                  #IF l_str IS NULL THEN 
                  #    LET l_str = "'" CLIPPED,g_sfb[i].sfb01 CLIPPED,"'" CLIPPED 
                  #ELSE 
                  #    LET l_str = l_str CLIPPED,",","'" CLIPPED,g_sfb[i].sfb01 CLIPPED,"'"
                  #END IF
                  IF l_str IS NULL THEN 
                   #add by liyjf190117 str #sfa08工作编号是空格 不可以直接CLIPPED ，会导致抓不到单身数据
                     IF cl_null(g_sfb[i].sfa08) THEN 
                        LET l_str = " (sfa01 = '" CLIPPED,g_sfb[i].sfb01 CLIPPED,"' and sfa03 = '" CLIPPED,g_sfb[i].tlf01 CLIPPED,"' AND sfa08 = ' ')"
                     ELSE
                     #add by liyjf190117 end  
                        LET l_str = " (sfa01 = '" CLIPPED,g_sfb[i].sfb01 CLIPPED,"' and sfa03 = '" CLIPPED,g_sfb[i].tlf01 CLIPPED,"' AND sfa08 = '" CLIPPED,g_sfb[i].sfa08 CLIPPED,"')"
                     END IF    #add by liyjf190117
                  ELSE 
                   	  #add by liyjf190117 str #sfa08工作编号是空格 不可以直接CLIPPED ，会导致抓不到单身数据
                     IF cl_null(g_sfb[i].sfa08) THEN 
                        LET l_str = l_str," or (sfa01 = '" CLIPPED,g_sfb[i].sfb01 CLIPPED,"' and sfa03 = '" CLIPPED,g_sfb[i].tlf01 CLIPPED,"' AND sfa08 = ' ')" 
                     ELSE
                     #add by liyjf190117 end  
                        LET l_str = l_str," or (sfa01 = '" CLIPPED,g_sfb[i].sfb01 CLIPPED,"' and sfa03 = '" CLIPPED,g_sfb[i].tlf01 CLIPPED,"' AND sfa08 = '" CLIPPED,g_sfb[i].sfa08 CLIPPED,"')"
                     END IF    #add by liyjf190117
                  END IF  
                  
              END IF 
           END FOR 
           LET g_sql =
             "SELECT sfa03,sfa12,sfa05,ima35,ima36,sfa01",
             " FROM sfa_file LEFT OUTER JOIN ima_file ON sfa03 = ima01",
             " WHERE ",l_str
           # foreach 塞資料
           PREPARE i301_pb2 FROM g_sql
           DECLARE sfa_curs2 CURSOR FOR i301_pb2
           FOREACH sfa_curs2 INTO g_inb.inb04,g_inb.inb08,g_inb.inb09,g_inb.inb05,g_inb.inb06,lll_sfa01
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ima_file
               WHERE ima01 = g_inb.inb04
                 AND imaacti ='Y'
              IF l_cnt = 0 THEN
                 CONTINUE FOREACH
              END IF
              #杂发数量的逻辑
               FOR i = 1 TO g_rec_b
                   IF g_sfb[i].sfb01 = lll_sfa01 AND g_sfb[i].tlf01 = g_inb.inb04 THEN 
                      LET g_inb.inb09 = g_sfb[i].b
                      EXIT FOR 
                   END IF 
               END FOR
               
             ##Add No.FUN-AA0050  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
             #IF NOT s_chk_ware(g_inb.inb05) THEN  #检查仓库是否属于当前门店
             #   LET g_inb.inb05 = ' '
             #END IF
             ##End Add No.FUN-AA0050
               LET l_sno = l_sno + 1
               IF NOT cl_null(tm.stk) THEN
                  LET g_inb.inb05=tm.stk
               END IF
               IF NOT cl_null(tm.loc) THEN
                  LET g_inb.inb06 = tm.loc
               ELSE LET g_inb.inb06 = ' '  #TQC-670017 add
               END IF


               LET g_inb.inb01  = g_ina.ina01
               LET g_inb.inb03 = l_sno
               LET g_inb.inb07  = ' ' #TQC-670017 add
               #抓異動單位
                LET l_unit1 = NULL      #No:MOD-9A0017 add
                SELECT img09 INTO l_unit1 FROM img_file
                  WHERE img01 = g_inb.inb04 AND img02 = g_inb.inb05
                    AND img03 = g_inb.inb06 AND img04 = g_inb.inb07

               #異動(inb08)/庫存單位(img09)
               CALL  s_umfchk(g_inb.inb04,g_inb.inb08,l_unit1)
                         RETURNING l_cnt,g_inb.inb08_fac
               IF l_cnt = 1 THEN
                   CALL cl_err(g_inb.inb04,'mfg3075',0)
                   LET g_inb.inb08_fac = 0
               END IF

               # LET g_inb.inb10  = '' #TQC-BC0120  mark
               #TQC-BC0120  begin
               SELECT ima24 INTO l_ima24 FROM ima_file
                WHERE ima01 = g_inb.inb04
               LET g_inb.inb10 = 'N'
               #TQC-BC0120  end
               LET g_inb.inb11  = ''
               LET g_inb.inb12  = ''
               LET g_inb.inb13  = 0
    #FUN-AB0089--add--begin
               LET g_inb.inb132 = 0
               LET g_inb.inb133 = 0
               LET g_inb.inb134 = 0
               LET g_inb.inb135 = 0
               LET g_inb.inb136 = 0
               LET g_inb.inb137 = 0
               LET g_inb.inb138 = 0
    #FUN-AB0089--add--end
               LET g_inb.inb14  = 0
               LET g_inb.inb15  = tm.reas
               LET g_inb.inb901 = ''
               LET g_inb.inb902 = g_inb.inb08
               LET g_inb.inb903 = g_inb.inb08_fac
               LET g_inb.inb904 = g_inb.inb09
               LET g_inb.inb905 = ''
               LET g_inb.inb906 = ''
               LET g_inb.inb907 = ''
               LET g_inb.inb930 = l_sfb98 #FUN-670103
               LET g_inb.inb41 = tm.pro
               #LET g_inb.inb42 = g_sfb2.sfb271  #WBS
               #LET g_inb.inb43 = g_sfb2.sfb50   #活動
               LET g_inb.inb16 = g_inb.inb09  #No.FUN-870163

              LET g_inb.inbplant = g_plant #FUN-980008 add
              LET g_inb.inblegal = g_legal #FUN-980008 add

              #判斷是否做專案庫存及批序號管理
              #IF 有專案庫存但無批序號管理，則要insert到rvbs_file
               IF s_chk_rvbs(g_inb.inb41,g_inb.inb04) THEN
                 LET g_success = 'Y'
                 #              出庫  作業代號   單號        單身序號     數量(換算成庫存數量)      專案代號
                 LET l_rvbs.rvbs00 = "aimt301"
                 LET l_rvbs.rvbs01 = g_ina.ina01
                 LET l_rvbs.rvbs02 = g_inb.inb03
                 LET l_rvbs.rvbs021= g_inb.inb04
                 LET l_rvbs.rvbs06 =g_inb.inb09*g_inb.inb08_fac
                 LET l_rvbs.rvbs08 = g_inb.inb41
                 LET l_rvbs.rvbs09 = -1   #出庫
                 CALL s_ins_rvbs("1",l_rvbs.*)
                 IF g_success = 'N' THEN
                   LET l_err = 'N'
                   EXIT FOREACH
                 END IF
               END IF
              #FUN-CB0087-xj---add---str
               IF g_aza.aza115 = 'Y' THEN
                 CALL s_reason_code(g_ina.ina01,g_ina.ina10,'',g_inb.inb04,g_inb.inb05,g_ina.ina04,g_ina.ina11) RETURNING g_inb.inb15
                 IF cl_null(g_inb.inb15) THEN
                    CALL cl_err('','aim-425',1)
                    EXIT FOREACH
                 END IF
               END IF
              #FUN-CB0087-xj---add---end
               INSERT INTO inb_file VALUES(g_inb.*)

               IF SQLCA.sqlcode THEN
                  LET l_err = SQLCA.sqlcode
                  CALL cl_err3("ins","inb_file",g_inb.inb01,g_inb.inb03,l_err,"","ins inb:",1)  #No.FUN-660128
                  EXIT FOREACH
               END IF
               #str-----add by guanyao160426
               IF NOT cl_null(g_inb.inb01) THEN
                  IF NOT cl_null(g_dan) THEN
                     UPDATE tc_ree_file SET tc_ree08 = g_inb.inb01,
                                            tc_ree09 = g_inb.inb04,
                                            tc_ree10 = g_inb.inb09,
                                            tc_ree11 = 'Y' 
                                      WHERE tc_ree01 = g_dan
                  END IF 
               END IF 
               #edn-----add by guanyao160426
           END FOREACH
           CLOSE WINDOW i301_m_w


           IF cl_null(l_err) AND g_inb.inb01 IS NOT NULL  THEN
           
        COMMIT WORK
              #LET l_cmd = "aimt301 '", g_ina.ina01 CLIPPED ,"'"
              #CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
              CALL cl_err(g_ina.ina01,'',1)
              CALL t370sub_y_chk(g_ina.ina01,1,'Y') #FUN-B50138  #TQC-C40079 add Y 
              IF g_success = "Y" THEN
               CALL t370sub_y_upd(g_ina.ina01,'Y',FALSE) #FUN-B50138
              END IF
              IF g_success = "Y" THEN
                CALL t370sub_s_chk(g_ina.ina01,'Y',FALSE,tm.dat) #FUN-B50138
                IF g_success = "Y" THEN
                   CALL t370sub_s_upd(g_ina.ina01,8,FALSE)    #FUN-B50138
                END IF
              END IF
              IF g_success = "Y" THEN 
              　 CALL cl_err(g_ina.ina01,'cxc-003',1)  #单据生成OK，且审核&扣账OK
                 
              ELSE 
                 CALL cl_err(g_ina.ina01,'cxc-004',1)  #单据生成ＯＫ，但是审核&扣账失败
              END IF 
           ELSE
              ROLLBACK WORK
           END IF

  #END IF  #mark by guanyao160427
END FUNCTION
#str-----add by guanyao160427
FUNCTION p001_change_rel_rel()  #分摊还原  #查询多选-确定-还原
    DEFINE l_cmd STRING 
    LET l_cmd = "cxcp001x"
    CALL cl_cmdrun_wait(l_cmd)
END FUNCTION 
#end-----add by guanyao160427
