# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp310.4gl
# Descriptions...: 
# Date & Author..: 00/05/05 By Apple 
# Modify.........: No.MOD-4A0252 04/10/22 By Smapmin 工單編號開窗
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No: FUN-560155 05/06/23 By pengu  (A18)工單編號開窗無資料
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-630277 06/03/29 By pengu 若系統參數設"工單發放時產生製程"時，
                                #                  無法產出產品製程資訊
# Modify.........: No.MOD-640124 06/04/09 By Joe 報表頁尾應出現(結  束)
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-760114 07/06/15 By Sarah 1.產生後的報表,表頭與資料中間的空白行太多
#                                                  2.產生單身後,按放棄並重新執行,請將畫面清除
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色
# Modify.........: No.MOD-870259 07/07/23 By claire new改為DYNAMIC ARRAY
# Modify.........: No.CHI-8B0035 08/12/15 By jan 產生 run card 時應剔除已分割的 run card 
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A80102 10/08/25 By kim GP5.25號機管理
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B80153 11/08/26 By Vampire 在asfp310()裡統計生產數量時不應用g_seq去做for迴圈，而是將i給g_seq
# Modify.........: No:TQC-BC0058 11/12/09 By SunLM FOR循環用new.getLength()
# Modify.........: No:MOD-C30627 12/03/13 By tanxc 增加g_slip錯誤提示及栏位控制
# Modify.........: No:


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_sfb01  LIKE sfb_file.sfb01,
         g_lot    LIKE ima_file.ima56,
         g_slip   LIKE shm_file.shm01,
         g_ynum1  LIKE sfb_file.sfb08,    #add by jixf 160809
         g_num2   LIKE sfb_file.sfb08,    #add by jixf 160809
         g_shm    RECORD LIKE shm_file.*,
         g_sfb05  LIKE sfb_file.sfb05,
         g_sfb06  LIKE sfb_file.sfb06,
         g_sfb08  LIKE sfb_file.sfb08,
         g_sfb13  LIKE sfb_file.sfb13,
         g_sfb15  LIKE sfb_file.sfb15,
         g_sfb14  LIKE sfb_file.sfb14,
         g_sfb16  LIKE sfb_file.sfb16,
         g_sfb919 LIKE sfb_file.sfb919,    #FUN-A80102
#        g_t1     VARCHAR(3),
         g_t1     LIKE oay_file.oayslip,                     #No.FUN-550067         #No.FUN-680121 VARCHAR(05)
        #new ARRAY[600]  OF RECORD                            #MOD-870259 mark
         new DYNAMIC ARRAY  OF RECORD                         #MOD-870259  
                seq             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#               woqty           LIKE ima_file.ima26           #No.FUN-680121 DEC(15,3)
                shm18           LIKE shm_file.shm18,          #FUN-A80102
                woqty           LIKE type_file.num15_3        #GP5.2  #NO.FUN-A20044
                END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE   g_seq           LIKE type_file.num5         #MOD-870259 add
DEFINE g_sfbud07         LIKE sfb_file.sfbud07       #add by guanyao160715
DEFINE   g_msg           LIKE type_file.chr1000      #add by guanyao160908

DEFINE  g_imaud10        LIKE ima_file.imaud10
#str----add by guanyao160908
DEFINE  g_ta_shm05 DYNAMIC ARRAY  OF RECORD
         ta_shm05    LIKE shm_file.ta_shm05
         END RECORD 
#end----add by guanyao160908
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   CALL p310_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p310_tm()
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
   DEFINE   p_row,p_col,i      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_ima02            LIKE ima_file.ima02,
            l_ima021           LIKE ima_file.ima021,
            l_ima55            LIKE ima_file.ima55,
            l_ima56            LIKE ima_file.ima56,
#           l_sum              LIKE ima_file.ima26,        #No.FUN-680121 DEC(15,3)
            l_sum              LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044  
            l_totqty,l_woqty   LIKE sfb_file.sfb08,
            l_smy58            LIKE smy_file.smy58,
            l_smy52            LIKE smy_file.smy52,
#           l_t1               VARCHAR(03),
            l_t1               LIKE smy_file.smyslip,      # Prog. Version..: '5.30.06-13.03.12(05) #No.FUN-550067 
            l_flag             LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)
            l_seq,l_i    LIKE type_file.num5         #No.FUN-680121 SMALLINT
   DEFINE   l_aza41            LIKE aza_file.aza41,
            l_chr              LIKE type_file.num5         #No.FUN-680121 SMALLINT
   DEFINE l_ssn,l_esn     LIKE shm_file.shm18          #FUN-A80102
   DEFINE l_snum,l_enum   LIKE type_file.num20         #FUN-A80102
   DEFINE l_sfb86         LIKE sfb_file.sfb86          #add by guanyao160713
   DEFINE l_round         LIKE type_file.num15_3       #add by jixf 160809
   DEFINE l_imaud10       LIKE ima_file.imaud10
   DEFINE l_sfbud09       LIKE  sfb_file.sfbud09
   DEFINE l_mod      like img_file.img10
   DEFINE g_p varchar(03)
   #add by lixwz201225 s---
   DEFINE l_sql            STRING,
          l_ta_shm05       LIKE shm_file.ta_shm05,
          l_max_pixuhao      LIKE type_file.num5,
          l_year,l_month,l_day  LIKE type_file.num5
   #add by lixwz201225 e---
   
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 
      LET p_col = 20
   ELSE
      LET p_row = 2 
      LET p_col = 2 
   END IF
 
   OPEN WINDOW p310_w AT p_row,p_col
        WITH FORM "asf/42f/asfp310" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   #FUN-A80102(S)
   IF g_sma.sma1421='Y' THEN
      CALL cl_set_comp_visible("shm18,sfb919",TRUE)
   ELSE
      CALL cl_set_comp_visible("shm18,sfb919",FALSE)
   END IF
   #FUN-A80102(E)

   CALL cl_opmsg('z')
   CLEAR FORM 
 
   WHILE TRUE
      LET g_sfb01 = ' ' LET g_lot = ' ' LET g_slip = ' '
      DISPLAY BY NAME g_sfb01,g_lot,g_slip 
      CALL cl_set_head_visible("grid01,grid02,grid03","YES")  #NO.FUN-6B0031
      #INPUT BY NAME g_sfb01,g_lot,g_slip WITHOUT DEFAULTS    #mark by guanyao160615
      #INPUT BY NAME g_sfb01,g_lot WITHOUT DEFAULTS            #add by guanyao160615   #mark by jixf 160809
      INPUT g_sfb01,g_num2,g_lot WITHOUT DEFAULTS FROM g_sfb01,num2,g_lot   #add by jixf 160809
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     ON ACTION help                    #No.TQC-770004
         LET g_action_choice="help"     #No.TQC-770004
         CALL cl_show_help()              #No.TQC-770004
         CONTINUE INPUT                  #No.TQC-770004
 
         AFTER FIELD g_sfb01      #工單 
            IF not cl_null(g_sfb01)  THEN 
               SELECT sfb05,sfb06,sfb08,sfb13,sfb15,sfb14,sfb16,sfb919,sfbud07,sfbud10
                 INTO g_sfb05,g_sfb06,g_sfb08,g_sfb13,g_sfb15,g_sfb14,g_sfb16,g_sfb919   #FUN-A80102
                      ,g_sfbud07,l_imaud10  #add by guanyao160715
                 FROM sfb_file
                WHERE sfb01 = g_sfb01 AND sfb87='Y' AND sfbacti='Y'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_sfb01,'asf-312',0)   #No.FUN-660128
                  CALL cl_err3("sel","sfb_file",g_sfb01,"","asf-312","","",0)    #No.FUN-660128
                  NEXT FIELD g_sfb01
               END IF
               #str----mark by guanyao160810
               #str-----add by guanyao160713
               #LET l_sfb86 = ''
               #SELECT sfb86 INTO l_sfb86 FROM sfb_file WHERE sfb01 = g_sfb01 
               #IF NOT cl_null(l_sfb86) THEN
               #    CALL cl_err3("sel","sfb_file",g_sfb01,"","csf-038","","",0)
               #    NEXT FIELD g_sfb01
               #END IF 
               #end-----add by guanyao160713
               #end----mark by guanyao160810
               SELECT sum(shm08) INTO l_sum FROM shm_file WHERE shm012 = g_sfb01
                                                            #No.CHI-8B0035--BEGIN
                                                            AND shm01 NOT IN
                                                                (SELECT shq02 FROM shp_file,shq_file
                                                                  WHERE shp01 = shq01
                                                                    AND shpconf = 'Y')
                                                             #No.CHI-8B0035--END--
                #NO.xyb-begin
                SELECT sfb02 INTO g_p FROM sfb_file WHERE sfb01 = g_sfb01                
                SELECT sfbud10*100 INTO l_ima56 FROM sfb_file WHERE sfb01 = g_sfb01
                IF g_p = "5" THEN
                    LET l_ima56 = ' '
                END IF 
                #NO.xyb-end
               
               IF l_sum IS NULL THEN
                  LET l_sum=0
               END IF
               DISPLAY "g_sfb08=",g_sfb08
               DISPLAY "l_sum=",l_sum
               #LET g_sfb08=g_sfb08-l_sum   #mark by jixf 160809
               #IF g_sfb08<=0 THEN          #mark by jixf 160809
          #     IF g_sfb08-l_sum<=0 THEN     #add by jixf 160809

           select sfbud09 INTO l_sfbud09 from sfb_file where sfb01=g_sfb01 and sfb81>to_date('2020-07-20','yyyy-mm-dd')

		   IF l_sfbud09 is NULL THEN
		   LET l_sfbud09=1
		   END IF 

		   IF l_sfbud09=0 THEN
		   LET l_sfbud09=1
		   END IF
		    
        #  SELECT ceil(g_sfb08/l_sfbud09*100) INTO g_sfb08 FROM dual   


		   IF g_sfb08-l_sum<=0 THEN     #add by jixf 160809 
                  CALL cl_err(g_sfb01,'asf-312',0)
                  NEXT FIELD g_sfb01
               END IF

               #str----add by jixf 160809
               SELECT SUM(shm08) INTO g_ynum1 FROM shm_file WHERE shm012=g_sfb01
               IF cl_null(g_ynum1) THEN 
                  LET g_ynum1=0
               END IF 

 
 


               LET g_num2=g_sfb08-g_ynum1

               IF g_num2<=0 THEN 
                  CALL cl_err(g_sfb01,'csf-312',1)
                  NEXT FIELD g_sfb01
               END IF 
               #end----add by jixf 160809
               
               DISPLAY g_sfb05  TO FORMONLY.sfb05 
               DISPLAY g_sfb08  TO FORMONLY.sfb08 
               DISPLAY g_sfb13  TO FORMONLY.sfb13 
               DISPLAY g_sfb15  TO FORMONLY.sfb15 
               DISPLAY g_sfb919 TO FORMONLY.sfb919  #FUN-A80102
               DISPLAY g_ynum1  TO FORMONLY.ynum1   #add by jixf 160809
               DISPLAY g_num2   TO FORMONLY.num2    #add by jixf 160809
               
#              LET l_t1=g_sfb01[1,3]
               LET l_t1 = s_get_doc_no(g_sfb01)        #No.FUN-550067  
               LET g_errno = ''
               SELECT smy58,smy52 INTO l_smy58,l_smy52
                 FROM smy_file WHERE smyslip = l_t1
               CASE
                  WHEN SQLCA.SQLCODE = 100
                     LET g_errno ='mfg0014' 
                  WHEN l_smy58 = 'N'
                     LET g_errno ='asf-822'
                  OTHERWISE   
                     LET g_errno = SQLCA.SQLCODE USING '-------'
               END CASE
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD g_sfb01
               END IF 
               #LET g_slip = l_smy52   #mark by guanyao160615
               #DISPLAY BY NAME g_slip #mark by guanyao160615
               
               SELECT ima02,ima021,ima55 INTO l_ima02,l_ima021,l_ima55 
                 FROM ima_file WHERE ima01 = g_sfb05
               IF SQLCA.sqlcode THEN 
                  LET l_ima02 = ' ' 
                  LET l_ima021= ' ' 
                  LET l_ima55 = ' ' 
                  LET l_imaud10 = ' ' 
               END IF
               #IF cl_null(g_lot) THEN
               #   LET g_lot = l_ima56
               #END IF
               LET g_lot = l_ima56
               DISPLAY l_ima02 TO FORMONLY.ima02  
               DISPLAY l_ima021 TO FORMONLY.ima021 
               DISPLAY l_ima55 TO FORMONLY.ima55  
               DISPLAY g_lot   TO FORMONLY.g_lot  
               DISPLAY l_imaud10 TO FORMONLY.imaud10
               LET g_imaud10=l_imaud10
            END IF

         #str---add by jixf 160809
         AFTER FIELD num2
            IF NOT cl_null(g_num2) AND g_num2>0 THEN 
               IF g_num2 > g_sfb08-g_ynum1 THEN
                  LET  g_num2 = g_sfb08-g_ynum1
                  CALL cl_err(g_num2,'csf-314',1)
                  NEXT FIELD num2
               END IF 
            END IF 
          
            IF NOT cl_null(g_num2) AND g_num2>0 AND l_imaud10>0 THEN 
               LET l_round=0
               SELECT MOD(g_num2,l_imaud10) INTO l_round FROM dual 
               #160903
               --IF l_round>0 THEN 
                  --CALL cl_err(g_num2,'csf-313',1)
                  --NEXT FIELD num2
               --END IF 
            END IF 
            #tianry  161110tianry 新增判断 必须是排版数的倍数
            IF (g_sfb01[1,3] <> 'MSY' AND g_sfb01[1,3] <> 'MSF' AND g_sfb01[1,3] <> 'MYB' AND g_sfb01[1,3] <> 'MSA' AND g_sfb01[1,3] <> 'MSG' AND g_sfb01[1,3] <> 'MRA' AND g_sfb01[1,3] <> 'MKT' AND g_sfb01[1,3] <> 'MST') THEN 
            LET l_mod=(g_num2 MOD l_imaud10) 
            IF l_mod!=0   THEN 
               CALL cl_err('','csf-909',1)
               NEXT FIELD num2
            END IF
            END if


            #tianry add end 
         #end---add by jixf 160809
         AFTER FIELD g_lot        #批量 
            IF cl_null(g_lot) OR g_lot <=0 OR g_lot > g_sfb08 THEN
               NEXT FIELD g_lot
            END IF

            #str---add by jixf 160809
            IF NOT cl_null(g_lot) AND g_lot>0 AND l_imaud10>0 THEN 
               LET l_round=0
               SELECT MOD(g_lot,l_imaud10) INTO l_round FROM dual 
               #1609903
               --IF l_round>0 THEN 
                  --CALL cl_err(g_lot,'csf-313',1)
                  --NEXT FIELD g_lot
               --END IF 
            END IF 
            #end---add by jixf 160809
             #tianry  161110tianry 新增判断 必须是排版数的倍数
            IF (g_sfb01[1,3] <> 'MSY' AND g_sfb01[1,3] <> 'MSF' AND g_sfb01[1,3] <> 'MYB' AND g_sfb01[1,3] <> 'MSA' AND g_sfb01[1,3] <> 'MSG' AND g_sfb01[1,3] <> 'MRA' AND g_sfb01[1,3] <> 'MKT' AND g_sfb01[1,3] <> 'MST' ) THEN 
            LET l_mod=(g_lot MOD l_imaud10)
            IF l_mod!=0 THEN
               CALL cl_err('','csf-909',1)
               NEXT FIELD num2
            END IF
            IF g_lot > l_ima56 THEN
               CALL cl_err('','csf-122',1)
               NEXT FIELD num2
            END IF
            END IF 
         #AFTER FIELD g_slip  #mark by guanyao160615
           #No.MOD-C30627 -- mark -- begin --
           # IF cl_null(g_slip) THEN
           #    CALL cl_err('run card','sub-522',0)   #No.MOD-C30627 add
           #    NEXT FIELD g_slip 
           # END IF
           #No.MOD-C30627 -- mark -- end ---
      #No.FUN-550067 --start--        
#            LET g_t1 = g_slip[1,3]
           #str------#mark by guanyao160615
            #CALL s_check_no("asf",g_slip,"","2","","","")                                                                      
            #  RETURNING li_result,g_slip                                                                                         
            #IF (NOT li_result) THEN                                                                                                 
            #   NEXT FIELD g_slip                                                                                                     
            #END IF               
            #end-----#mark by guanyao160615            
#           LET g_errno = ' '
#           CALL s_mfgslip(g_t1,'asf','2')
#           IF NOT cl_null(g_errno) THEN	 		#抱歉,有問題
#              CALL cl_err(g_t1,g_errno,0) NEXT FIELD g_slip
#           END IF
#           IF cl_null(g_slip[5,10]) AND g_smy.smyauno = 'N' THEN
#              NEXT FIELD g_slip
#           END IF
      #No.FUN-550067 ---end---    
            #str-----add by guanyao160713
            ON ACTION root_work
               CALL p310_root()
            #end-----add by guanyao160713
      
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(g_sfb01)
                     #--MOD-560155
                       SELECT aza41 INTO l_aza41 FROM aza_file
                      CASE
                         WHEN l_aza41 = '1'
                              LET l_chr=3
                         WHEN l_aza41 = '2'
                              LET l_chr=4
                         WHEN l_aza41 = '3'
                              LET l_chr=5
                     END CASE
                     CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sfb04"   #MOD-4A0252新增q_sfb04  #mark by guanyao160713
                     # LET g_qryparam.form = "cq_sfb04"   #MOD-4A0252新增q_sfb04  #add by guanyao160713
                     LET g_qryparam.default1 = g_sfb01
                     LET g_qryparam.arg1 = l_chr 
                     CALL cl_create_qry() RETURNING g_sfb01
                     DISPLAY g_sfb01 TO FORMONLY.g_sfb01 
                     NEXT FIELD g_sfb01
 
#                    CALL q_sfb(3,3,g_sfb01,'123') RETURNING g_sfb01
#                    CALL FGL_DIALOG_SETBUFFER( g_sfb01 )
#                    CALL cl_init_qry_var()
 #                    LET g_qryparam.form = "q_sfb04"   #MOD-4A0252新增q_sfb04
#                    LET g_qryparam.default1 = g_sfb01
#                    LET g_qryparam.arg1 = l_chr 
#                    display g_qryparam.arg1
#                    LET g_qryparam.arg1 = "l_sum"
#                    CALL cl_create_qry() RETURNING g_sfb01
#                     CALL FGL_DIALOG_SETBUFFER( g_sfb01 )
#                    DISPLAY g_sfb01 TO FORMONLY.g_sfb01 
#                    NEXT FIELD g_sfb01
                  #--end
            #str-----mark by guanyao160615
            #      WHEN INFIELD(g_slip) 
            #        #CALL q_smy(FALSE,FALSE,g_slip,'asf','2') RETURNING g_slip   #TQC-670008
            #         CALL q_smy(FALSE,FALSE,g_slip,'ASF','2') RETURNING g_slip   #TQC-670008
#           #          CALL FGL_DIALOG_SETBUFFER( g_slip )
            #            DISPLAY g_slip TO FORMONLY.g_slip 
            #            NEXT FIELD g_slip 
            #end------mark by guanyao160615
               OTHERWISE EXIT CASE
              END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
      #MOD-C30627--begin--
         AFTER INPUT 
         IF NOT INT_FLAG THEN
        #str-----mark by guanyao
	    #IF cl_null(g_slip) THEN
	    #   CALL cl_err('g_slip','sub-522',0)
        #       NEXT FIELD g_slip
	    #END IF 
        #end-----mark by guanyao
         END IF
      #MOD-C30627--end--
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF

      #str-----add by guanyao160730
      IF cl_confirm('csf-042') THEN 
         CALL p310_root()
      END IF 
      #end----add by guanyao160730
 
      MESSAGE "WAITING..." 
      CALL ui.Interface.refresh()
      #FOR g_i=1 TO 600 INITIALIZE new[g_i].* TO NULL END FOR  #MOD-870259 mark
      #FUN-A80102(S)
      IF g_sma.sma1421='Y' AND g_sfb919 IS NOT NULL THEN
         LET l_ssn = ''
         LET l_esn = ''
         CALL s_machine_de_code(g_sfb05,g_sfb919) RETURNING l_ssn,l_esn
         LET l_snum = l_ssn
         LET l_enum = l_esn
      END IF
      #FUN-A80102(E)
      CALL new.clear()                                         #MOD-870259
      LET g_i=1
      #-->依批量產生Run Card張數-------
      IF g_lot >0 THEN
         LET l_totqty = 0  LET l_woqty = 0
         #LET l_mod = g_sfb08 MOD g_lot    #mark by jixf 160809
         LET l_mod = g_num2 MOD g_lot      #add by jixf 160809
         #LET l_seq = (g_sfb08 /g_lot)     #mark by jixf 160809
         LET l_seq = (g_num2 /g_lot)       #add by jixf 170809
         IF l_mod != 0 THEN
            LET l_seq = l_seq + 1 
         END IF
         FOR l_i=1 TO l_seq
             LET l_woqty  = g_lot
             LET l_totqty = l_totqty + l_woqty
             #IF g_sfb08 < l_totqty THEN    #mark by jixf 160809
             IF g_num2 < l_totqty THEN      #add by jixf 160809
                #LET l_woqty = g_sfb08 - l_totqty + l_woqty   #mark by jixf 160809
                LET l_woqty = g_num2 - l_totqty + l_woqty     #add by jixf 160809
             END IF
             LET new[l_i].seq = l_i
             LET new[l_i].woqty=l_woqty
             #FUN-A80102(S)
             IF g_sma.sma1421='Y' AND g_sfb919 IS NOT NULL THEN
                IF l_woqty = 1 THEN
                   IF l_esn IS NOT NULL THEN  #有起始和截止流水碼
                      LET new[l_i].shm18 = s_machine_en_code(g_sfb05,l_snum)
                      LET l_snum = l_snum + 1
                   ELSE  #計畫批號為號機
                      LET new[l_i].shm18 = g_sfb919
                   END IF
                END IF
             END IF
             #FUN-A80102(E)
         END FOR
      END IF
      #-----------------------------------------
      #CALL SET_COUNT(l_seq)          #MOD-870259 mark
      LET g_seq = l_seq               #MOD-870259
      #DISPLAY l_seq TO FORMONLY.cnt 

      #add by lixwz201225 s---
      # 自动编码增加中间表，取号锁表，防止重复
      # 中间表名shm05_file 字段 pixuhao ，pixuhaoyear ，pixuhaomonth ，pixuhaoday
      # 开始事务之前取号，防止事务中，别人又执行作业 
      # 21/01/09 作业被人还原掉，21/01/16 重新部署
      LET l_year = YEAR(g_today) 
      LET l_month = MONTH(g_today)
      LET l_day = DAY(g_today)
 
      DECLARE max_pixuhao CURSOR FOR SELECT pixuhao  FROM shm05_file WHERE pixuhaoyear = ?  and pixuhaomonth = ? and pixuhaoday= ? FOR UPDATE
      BEGIN WORK
         OPEN max_pixuhao USING l_year,l_month,l_day
         FETCH max_pixuhao INTO l_max_pixuhao

         IF cl_null(l_max_pixuhao) OR l_max_pixuhao = 0THEN
            LET l_max_pixuhao = 1
            INSERT INTO shm05_file VALUES(
               l_max_pixuhao,l_year,l_month,l_day
            )
         ELSE
            LET l_max_pixuhao = l_max_pixuhao+1
            UPDATE shm05_file SET pixuhao=l_max_pixuhao
            WHERE pixuhaoyear=l_year AND pixuhaomonth =l_month AND pixuhaoday = l_day
         END IF 
         IF sqlca.sqlerrd[3] <>1 THEN 
            CALL cl_err("取号失败！请截图提交MIS","!",1)
            ROLLBACK WORK
            CLOSE WINDOW p310_w
            RETURN
         END IF
      COMMIT WORK  
      #取号成功，开始处理
      LET l_ta_shm05='dhy-' CLIPPED,l_year USING '&&&&' CLIPPED,l_month USING '&&' CLIPPED,l_day USING '&&' CLIPPED,l_max_pixuhao USING '&&&&' CLIPPED 
      #add by lixwz201225 e---

      ERROR ""
      BEGIN WORK 
      LET g_success='Y' 
      CALL asfp310(l_ta_shm05)  #mod by lixwz201225 增加传参
      CALL s_showmsg()           #NO.FUN-710026
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            #str TQC-760114 add
            LET g_sfb05 = ' ' LET g_sfb08 = ' ' LET g_sfb13 = ' '
            LET g_sfb15 = ' ' LET l_ima02 = ' ' LET l_ima021= ' '
            LET l_ima55 = ' '
            DISPLAY g_sfb05 TO FORMONLY.sfb05 
            DISPLAY g_sfb08 TO FORMONLY.sfb08 
            DISPLAY g_sfb13 TO FORMONLY.sfb13 
            DISPLAY g_sfb15 TO FORMONLY.sfb15 
            DISPLAY l_ima02 TO FORMONLY.ima02  
            DISPLAY l_ima021 TO FORMONLY.ima021 
            DISPLAY l_ima55 TO FORMONLY.ima55  
           #FOR g_i=1 TO 600 INITIALIZE new[g_i].* TO NULL END FOR  #MOD-870259 mark
            CALL new.clear()                                        #MOD-870259
            DISPLAY ARRAY new TO s_new.* ATTRIBUTE(UNBUFFERED)
               BEFORE DISPLAY
                  EXIT DISPLAY
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE DISPLAY
            END DISPLAY
            #end TQC-760114 add
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      ERROR ""
      CLOSE WINDOW p310_w
      EXIT WHILE
   END WHILE 
   ERROR ""  
END FUNCTION
 
FUNCTION asfp310(p_ta_shm05)
   DEFINE   li_result     LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
   DEFINE l_za05          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(40)
   DEFINE l_sfb           RECORD LIKE sfb_file.*
   DEFINE l_sfc           RECORD LIKE sfc_file.*
   DEFINE l_sfd           RECORD LIKE sfd_file.*
   DEFINE l_minopseq      LIKE ecb_file.ecb03 
   DEFINE new_part        LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
   DEFINE i,j             LIKE type_file.num10         #No.FUN-680121 INTEGER
#  DEFINE l_qty           LIKE ima_file.ima26,         #No.FUN-680121 DEC(15,3)
   DEFINE l_qty           LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          l_name          LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #External(Disk) file name
   DEFINE l_x             LIKE type_file.num5    #add by guanyao160615
   DEFINE l_temp          LIKE type_file.chr20   #add by guanyao160615
   DEFINE l_imaud10       LIKE ima_file.imaud10  #add by guanyao160715
   DEFINE l_year          LIKE type_file.chr10   #add by jixf 160809
   DEFINE l_month         LIKE type_file.chr10   #add by jixf 160809
   DEFINE l_day           LIKE type_file.chr10   #add by jixf 160809
   DEFINE l_number        LIKE type_file.chr10    #add by jixf 160809
   DEFINE l_ta_shm05      LIKE shm_file.ta_shm05  #add by jixf 160809
   DEFINE  l_mod          LIKE img_file.img10   #tianru add  
   #add by lixwz201225 s--- 
   DEFINE p_ta_shm05   LIKE shm_file.ta_shm05
   #add by lixwz201225 e---
   INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
      AFTER FIELD woqty  
        LET i=ARR_CURR()
        IF cl_null(new[i].woqty) OR new[i].woqty <0 THEN 
           NEXT FIELD woqty   
        END IF
        #LET g_seq = i        #MOD-B80153 add  #TQC-BC0058  mark
        LET g_seq = new.getLength()  #TQC-BC0058  add =當前數組長度
         #tianry  161110tianry 新增判断 必须是排版数的倍数
        LET l_mod=(new[i].woqty MOD g_imaud10)
        IF (g_sfb01[1,3] <> 'MSY' AND g_sfb01[1,3] <> 'MSF' AND g_sfb01[1,3] <> 'MYB' AND g_sfb01[1,3] <> 'MSA' AND g_sfb01[1,3] <> 'MSG' AND g_sfb01[1,3] <> 'MRA' AND g_sfb01[1,3] <> 'MKT') THEN 
        IF l_mod!=0 THEN
           CALL cl_err('','csf-909',1)
           NEXT FIELD woqty
        END IF
        END IF 


#.....add by Carol 01/08/28:NO.3396..................
      AFTER INPUT 
        IF INT_FLAG THEN EXIT INPUT END IF 
        LET l_qty = 0 
        FOR g_i=1 TO g_seq   #MOD-870259 modify 600 
            IF NOT cl_null(new[g_i].woqty) AND new[g_i].woqty > 0 THEN 
               LET l_qty = l_qty + new[g_i].woqty 
            END IF 
        END FOR
        IF l_qty > g_sfb08 THEN 
           CALL cl_err('','asf-576',0)
           NEXT FIELD seq
        END IF   
#........................................................
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("grid01,grid02,grid03","AUTO")                                                                                      
#NO.FUN-6B0031--END   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 LET g_success='N' RETURN END IF
   IF NOT cl_sure(19,0) THEN LET g_success='N' RETURN END IF
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfp310'
#  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#  FOR g_i = 1 TO g_len-1 LET g_dash[g_i,g_i]='=' END FOR
   CALL cl_outnam('asfp310') RETURNING l_name
   #FUN-A80102(S)
   IF g_sma.sma1421='N' OR cl_null(g_sma.sma1421) THEN
      LET g_zaa[34].zaa06 = 'Y'
   END IF
   #FUN-A80102(E)
   #str----add by guanyao160715
   LET l_imaud10 = ''
   IF g_sfbud07 = 0 OR cl_null(g_sfbud07) THEN 
   ELSE 
      LET l_imaud10 = g_sfb08/g_sfbud07   
   END IF 
   #end----add by guanyao160715
   START REPORT p310_rep TO l_name
 
   # -------------
   # 陣列列印資料
   # -------------
   CALL s_showmsg_init()    #NO.FUN-710026
   #str---add by jixf 160809 自动生成投产批次号
   #mark by lixwz201225 s--- 
   # LET l_ta_shm05='dhy'
   # LET l_year=YEAR(g_today)
   # LET l_month=MONTH(g_today)
   # LET l_day=DAY(g_today)

   # LET l_month=l_month USING '&&' 
   # LET l_day=l_day USING '&&'

   # LET l_ta_shm05='dhy-' CLIPPED,l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
   # SELECT MAX(substr(ta_shm05,13,4)) INTO l_number FROM shm_file WHERE substr(ta_shm05,1,12)=l_ta_shm05
   # IF cl_null(l_number) THEN
   #    LET l_number=0
   # ELSE 
   #    LET l_number=l_number+1
   # END IF 
   # LET l_number=l_number USING '&&&&'
   # LET l_ta_shm05=l_ta_shm05 CLIPPED,l_number CLIPPED
   #mark by lixwz201225 e---
   
   LET l_ta_shm05 = p_ta_shm05 #add by lixwz201225
   
   LET g_ta_shm05[1].ta_shm05 = l_ta_shm05 #add by guanyao160908
   #end---add by jixf 160809
   FOR i=1 TO g_seq         #MOD-870259 modify 600  
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end 
        IF cl_null(new[i].woqty) THEN EXIT FOR END IF
        INITIALIZE g_shm.* TO NULL
        #--(1)Run Card  (shm_file)---------------------------
        LET g_shm.shm012 =g_sfb01 
        LET g_shm.shm05  =g_sfb05
        LET g_shm.shm06  =g_sfb06 
        LET g_shm.shm08  =new[i].woqty
        LET g_shm.shm09  =0 
        LET g_shm.shm10  =0 
        LET g_shm.shm11  =0 
        LET g_shm.shm111 =0 
        LET g_shm.shm12  =0 
        LET g_shm.shm121 =0 
        LET g_shm.shm13  =g_sfb13
        LET g_shm.shm15  =g_sfb15
#NO.3403 01/08/31 BY Carol add ................
        LET g_shm.shm14  =g_sfb14
        LET g_shm.shm16  =g_sfb16
#..............................................
        LET g_shm.shm17  =''
        LET g_shm.shm18  =new[i].shm18   #FUN-A80102
        LET g_shm.shm28  ='N'
        LET g_shm.shmacti='Y'
        LET g_shm.shmuser=g_user
        LET g_shm.shmgrup=g_grup
        LET g_shm.shmdate=g_today 
        LET g_shm.shmplant = g_plant #FUN-980008 add
        LET g_shm.shmlegal = g_legal #FUN-980008 add
        LET g_shm.ta_shm02 = 'Y' #str---add by huanglf160721
      
       #No.FUN-550067 --start--           
        #str----mark by guanyao160615
        #CALL s_auto_assign_no("asf",g_slip,g_today,"","shm_file","shm01","","Y","") 
        #RETURNING li_result,g_shm.shm01                                                    
      #IF (NOT li_result) THEN  
        #end----mark by guanyao160615      
#       CALL s_shmauno(g_slip,g_today) RETURNING g_i,g_shm.shm01
#       IF g_i THEN 
      #No.FUN-550067 ---end---    
       #    LET g_success = 'N' RETURN  END IF  #mark by guanyao160615
        #str-----add by guanyao160615
        LET l_x = ''
        SELECT length(g_sfb01) INTO l_x FROM dual 
        SELECT max(substr(shm01,l_x+2,3)) INTO l_temp FROM shm_file WHERE substr(shm01,1,l_x) = g_sfb01
        IF cl_null(l_temp) THEN
           LET l_temp = '001'
        ELSE 
           LET l_temp = l_temp +1
           LET l_temp = l_temp USING '&&&'
        END IF 
        LET g_shm.shm01 = g_sfb01 CLIPPED,'-' CLIPPED,l_temp,'-00'
        IF cl_null(g_shm.shm01) THEN 
           LET g_success = 'N' RETURN
        END IF 
        #end-----add by guanyao160615]
        #str----add by guanyao160715
        IF NOT cl_null(l_imaud10) AND l_imaud10!= 0  THEN 
           LET g_shm.ta_shm01 = g_shm.shm08/l_imaud10
        END IF 
        SELECT ceil(g_shm.ta_shm01*100)/100 INTO g_shm.ta_shm01 FROM dual   #add by guanyao160728
        #end----add by guanyao160715
        LET g_shm.shmoriu = g_user      #No.FUN-980030 10/01/04
        LET g_shm.shmorig = g_grup      #No.FUN-980030 10/01/04

        LET g_shm.ta_shm05=l_ta_shm05   #add by jixf 160809
        LET g_shm.ta_shm06 = 'N'  #add by guanyao160928
        INSERT INTO shm_file VALUES(g_shm.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_shm.shm01,'asf-738',1)  #No.FUN-660128
#          CALL cl_err3("ins","shm_file",g_shm.shm01,"","asf-738","","",1)    #No.FUN-660128 #NO.FUN-710026
           CALl s_errmsg('shm01',g_shm.shm01,g_shm.shm01,'asf-738',1)         #NO.FUN-710026
           LET g_success='N' 
#          RETURN                                                             #NO.FUN-710026 
           CONTINUE FOR                                                       #NO.FUN-710026
        END IF
 
        #--(2)產生製程(sgm_file)-----------------------------
      #------------------No.TQC-630277 modify
       #IF g_sma.sma26 = '2' THEN CALL p310_crrut() END IF 
        IF g_sma.sma26 != '1' THEN CALL p310_crrut() END IF 
      #------------------No.TQC-630277 end
 
        OUTPUT TO REPORT p310_rep(g_shm.*)
   END FOR
   #str-----add by guanyao160714
   IF g_success = 'Y' THEN 
      CALL p310_ins_root(l_ta_shm05)  #mod by jizf 160809 增加传参
   END IF 
   #str-----add by guanyao160714
#NO.FUN-710026----begin 
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#NO.FUN-710026----end  
   #str-----add by guanyao160908
   CALL cl_get_feldname('ta_shm05', g_lang) RETURNING g_msg
   CALL cl_show_array(base.TypeInfo.CREATE(g_ta_shm05), g_msg, g_msg)
   #end-----add by guanyao160908
   FINISH REPORT p310_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   ERROR ""
 
END FUNCTION
 
   
REPORT p310_rep(l_shm)
  DEFINE  l_shm RECORD LIKE shm_file.*,
          l_last_sw    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1) # No.MOD-640124
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY l_shm.shm01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
    # PRINT ' '   #TQC-760114 mark
    # LET g_pageno = g_pageno + 1
      PRINT ' '
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]  #FUN-A80102
      PRINT g_dash1
      LET l_last_sw = 'n'      ## No.MOD-640124
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],l_shm.shm01,                   #Run Card
            COLUMN g_c[32],l_shm.shm012,                  #工單
            COLUMN g_c[33],l_shm.shm05,                   #料件
            COLUMN g_c[34],l_shm.shm18,                   #號機  #FUN-A80102
         #  COLUMN g_c[34],l_shm.shm08 using'-------&.&&&'    #生產數量
            COLUMN g_c[35],l_shm.shm08 using'-------------&.&&&'    #生產數量 #No.TQC-6A0087 #FUN-A80102
   ## No.MOD-640124 BY Joe .......................................start
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   ## No.MOD-640124 BY Joe .......................................end
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF
END REPORT
 
    
FUNCTION p310_crrut()
  DEFINE l_ecb RECORD LIKE ecb_file.*
 
  IF not cl_null(g_sfb06) THEN
       #-->檢查製程追蹤產生否
       SELECT COUNT(*) INTO g_cnt FROM sgm_file WHERE sgm01= g_shm.shm01
         IF g_cnt > 0 THEN
            DELETE FROM sgm_file WHERE sgm01 = g_shm.shm01
            IF SQLCA.sqlerrd[3]=0 THEN
               LET g_success = 'N'
#              CALL cl_err('','asf-386',0)    #No.FUN-660128
               CALL cl_err3("del","sgm_file",g_shm.shm01,"","asf-386","","",0)    #No.FUN-660128
               RETURN
            END IF  
         END IF
       #-->產生Run Card 製程追蹤檔(sgm_file)
       CALL s_runcard(g_shm.shm01,g_shm.shm012,g_shm.shm06,
                      g_shm.shm05,g_shm.shm08)
          RETURNING g_errno 
       IF not cl_null(g_errno)  THEN 
          CALL cl_err(g_sfb01,g_errno,0)
          LET g_success = 'N' RETURN 
       END IF
  END IF
END FUNCTION

#str-----add by guanyao160713
FUNCTION p310_root()
DEFINE l_sql     STRING
DEFINE l_wc      STRING
DEFINE l_sum     LIKE shm_file.shm08 
DEFINE l_rec_b1  LIKE type_file.num5
DEFINE l_sfb   DYNAMIC ARRAY OF RECORD   
      sel         LIKE type_file.chr1,
      sfb01       LIKE sfb_file.sfb01, 
      sfb05       LIKE sfb_file.sfb05,
      sfb06       LIKE sfb_file.sfb06,
      sfb08       LIKE sfb_file.sfb08,
      num1        LIKE sfb_file.sfb08,   #add by jixf 160809
      num2        LIKE sfb_file.sfb08,   #add by jixf 160809
      sfb08_1     LIKE sfb_file.sfb08,
      imaud10     LIKE ima_file.imaud10,
      imaud07     LIKE ima_file.imaud07, #str----add byhuanglf160801
      sfb13       LIKE sfb_file.sfb13,
      sfb15       LIKE sfb_file.sfb15,
      sfb14       LIKE sfb_file.sfb14,
      sfb16       LIKE sfb_file.sfb16,
      sfb919      LIKE sfb_file.sfb919
     END RECORD 

DEFINE l_sfb_1   RECORD   
      sel         LIKE type_file.chr1,
      sfb01       LIKE sfb_file.sfb01, 
      sfb05       LIKE sfb_file.sfb05,
      sfb06       LIKE sfb_file.sfb06,
      sfb08       LIKE sfb_file.sfb08,
      num1        LIKE sfb_file.sfb08,   #add by jixf 160809
      num2        LIKE sfb_file.sfb08,   #add by jixf 160809
      sfb08_1     LIKE sfb_file.sfb08,
      imaud10     LIKE ima_file.imaud10,
      imaud07     LIKE ima_file.imaud07,#str----add byhuanglf160801
      sfb13       LIKE sfb_file.sfb13,
      sfb15       LIKE sfb_file.sfb15,
      sfb14       LIKE sfb_file.sfb14,
      sfb16       LIKE sfb_file.sfb16,
      sfb919      LIKE sfb_file.sfb919
     END RECORD
DEFINE l_sel_n    LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE   p_row,p_col,i      LIKE type_file.num5
DEFINE l_i         LIKE type_file.num5
DEFINE l_round     LIKE type_file.num15_3
   
    IF cl_null(g_sfb05) THEN 
       RETURN 
    END IF 

    DROP TABLE asfp310_sel_sfb
   CREATE TEMP TABLE asfp310_sel_sfb(
      sel         LIKE type_file.chr1,
      sfb01       LIKE sfb_file.sfb01, 
      sfb05       LIKE sfb_file.sfb05,
      sfb06       LIKE sfb_file.sfb06,
      sfb08       LIKE sfb_file.sfb08,
      num1        LIKE sfb_file.sfb08,   #add by jixf 160809
      num2        LIKE sfb_file.sfb08,   #add by jixf 160809
      sfb08_1     LIKE sfb_file.sfb08,
      imaud10     LIKE ima_file.imaud10,
      imaud07     LIKE ima_file.imaud07,
      sfb13       LIKE sfb_file.sfb13,
      sfb15       LIKE sfb_file.sfb15,
      sfb14       LIKE sfb_file.sfb14,
      sfb16       LIKE sfb_file.sfb16,
      sfb919      LIKE sfb_file.sfb919)
   DELETE FROM asfp310_sel_sfb
   

    OPEN WINDOW p310_w_p AT p_row,p_col WITH FORM "csf/42f/csfp310_p"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
     CALL cl_ui_locale('csfp310_p')
     CALL l_sfb.clear()

     CONSTRUCT l_wc ON sfb01,sfb05,sfb06,sfb08,imaud10,imaud07,sfb13,sfb15,sfb14,sfb16,sfb919 #str----add by huanglf160801
        FROM s_sfb[1].sfb01,s_sfb[1].sfb05,s_sfb[1].sfb06,s_sfb[1].sfb08,s_sfb[1].imaud10,s_sfb[1].imaud07,s_sfb[1].sfb13,
             s_sfb[1].sfb15,s_sfb[1].sfb14,s_sfb[1].sfb16,s_sfb[1].sfb919                     #str----add by huanglf160801
     BEFORE CONSTRUCT
         CALL cl_qbe_init()

         ON ACTION controlp
            CASE
              WHEN INFIELD(sfb01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "cq_sfb_1"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.arg1 = g_sfb01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfb01
                   NEXT FIELD sfb01
              WHEN INFIELD(sfb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "cq_sfb_2"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.arg1 = g_sfb01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfb05
                   NEXT FIELD sfb05
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
                  
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT 
               
         ON ACTION qbe_select
            CALL cl_qbe_select()

   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p310_w_p
      RETURN
   END IF     
   LET l_ac = 1
   LET l_sql = "SELECT 'N',sfb01,sfb05,sfb06,sfb08,0,0,sfb08,sfbud10,imaud07,sfb13,sfb15,sfb14,sfb16,sfb919",  #str----add by huanglf160801 #mod by jixf 160809 add 0,0
               "  FROM sfb_file ,ima_file ",
               " WHERE sfb86 = '",g_sfb01,"'",
               "   AND sfb87='Y' ",
               "   AND ima01 = sfb05",   #add by guanyao160730
               "   AND ",l_wc CLIPPED,
               "   AND sfbacti='Y'"
   PREPARE sfb_pre FROM l_sql
   DECLARE sfb_cur CURSOR FOR sfb_pre
   FOREACH sfb_cur INTO l_sfb[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach sfb_cur',SQLCA.SQLCODE,1)
      END IF

      #str---add by jixf 160809
      SELECT SUM(shm08) INTO l_sfb[l_ac].num1 FROM shm_file WHERE shm012=l_sfb[l_ac].sfb01
      IF cl_null(l_sfb[l_ac].num1) THEN 
         LET l_sfb[l_ac].num1=0
      END IF 
      LET l_sfb[l_ac].num2=l_sfb[l_ac].sfb08-l_sfb[l_ac].num1
      #end---add by jixf 160809
      
      LET  l_sum = ''
      SELECT SUM(shm08) INTO l_sum FROM shm_file WHERE shm012 = l_sfb[l_ac].sfb01
                                                   AND shm01 NOT IN
                                                      (SELECT shq02 FROM shp_file,shq_file
                                                                   WHERE shp01 = shq01
                                                                     AND shpconf = 'Y')
      
      #IF l_sum >0 THEN    #mark by jixf 160810
      IF l_sum >= l_sfb[l_ac].sfb08 THEN  #add by jixf 160810
        
         CONTINUE FOREACH 
      END IF 
    
      
       IF l_sfb[l_ac].sfb08_1>l_sfb[l_ac].imaud10*100 THEN
               LET  l_sfb[l_ac].sfb08_1=l_sfb[l_ac].imaud10*100
      END IF
             
      INSERT INTO asfp310_sel_sfb VALUES(l_sfb[l_ac].*)
      LET l_ac = l_ac +1      
   END FOREACH

   CALL l_sfb.deleteElement(l_ac)
   LET l_rec_b1= l_ac - 1
   LET l_ac = 0

   DISPLAY ARRAY l_sfb TO s_sfb.* ATTRIBUTE(COUNT=l_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY
   
   LET l_ac = 1

   INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
         ATTRIBUTE(COUNT=l_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)

       BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_sfb_1.*=l_sfb[l_ac].*
         BEGIN WORK 


       #str---add by jixf 160809
       AFTER FIELD num2
          IF NOT cl_null(l_sfb[l_ac].num2) AND l_sfb[l_ac].num2>0 THEN 
             IF l_sfb[l_ac].num2 > l_sfb[l_ac].sfb08-l_sfb[l_ac].num1 THEN
                LET  l_sfb[l_ac].num2 = l_sfb[l_ac].sfb08-l_sfb[l_ac].num1
                CALL cl_err(l_sfb[l_ac].num2,'csf-314',1)
                NEXT FIELD num2
             END IF 
          END IF 
          
          IF NOT cl_null(l_sfb[l_ac].num2) AND l_sfb[l_ac].num2>0 AND l_sfb[l_ac].imaud10>0 THEN 
             LET l_round=0
             SELECT MOD(l_sfb[l_ac].num2,l_sfb[l_ac].imaud10) INTO l_round FROM dual
            #160903 
             --IF l_round>0 THEN 
                --CALL cl_err(l_sfb[l_ac].num2,'csf-313',1)
                --NEXT FIELD num2
             --END IF 
          END IF 

          


       IF l_sfb[l_ac].sfb08_1>l_sfb[l_ac].imaud10*100 THEN
               LET  l_sfb[l_ac].sfb08_1=l_sfb[l_ac].imaud10*100
             END IF
  DISPLAY  l_sfb[l_ac].sfb08_1

        AFTER FIELD sfb08_1
          IF NOT cl_null(l_sfb[l_ac].sfb08_1) AND l_sfb[l_ac].sfb08_1>0 AND l_sfb[l_ac].imaud10>0 THEN 
             LET l_round=0

             IF l_sfb[l_ac].sfb08_1>l_sfb[l_ac].imaud10*100 THEN 
               LET  l_sfb[l_ac].sfb08_1=l_sfb[l_ac].imaud10*100
             END IF 
             SELECT MOD(l_sfb[l_ac].sfb08_1,l_sfb[l_ac].imaud10) INTO l_round FROM dual 
             #160903
             --IF l_round>0 THEN 
                --CALL cl_err(l_sfb[l_ac].sfb08_1,'csf-313',1)
                --NEXT FIELD sfb08_1
             --END IF
          END IF 
       #end---add by jixf 160809
       
       ON ROW CHANGE
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             ROLLBACK WORK
             EXIT INPUT 
          END IF
          UPDATE asfp310_sel_sfb SET sel = l_sfb[l_ac].sel,
                                     sfb08_1 = l_sfb[l_ac].sfb08_1,
                                     num2=l_sfb[l_ac].num2    #add by jixf 160809
           WHERE sfb01 = l_sfb[l_ac].sfb01

       ON ACTION sel_all
          FOR l_i = 1 TO l_rec_b1
             LET l_sfb[l_i].sel = 'Y'
          END FOR 
          UPDATE asfp310_sel_sfb SET sel = 'Y'

       ON ACTION unsel_all
          FOR l_i = 1 TO l_rec_b1
             LET l_sfb[l_i].sel = 'N'
          END FOR  
          UPDATE asfp310_sel_sfb SET sel = 'N'

       ON ACTION CONTROLG
           CALL cl_cmdask()

       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

       ON ACTION about
           CALL cl_about()

       ON ACTION help
           CALL cl_show_help()
          
       AFTER ROW 
         IF INT_FLAG THEN
             LET INT_FLAG = 0
             ROLLBACK WORK
             EXIT INPUT 
         END IF
         COMMIT WORK 

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p310_w_p
      RETURN
   END IF
   CLOSE WINDOW p310_w_p
END FUNCTION 
#end-----add by guanyao160713
#str-----add by guanyao160714
FUNCTION p310_ins_root(l_ta_shm05)        #mod by jixf 160809 增加接参
DEFINE l_sql       STRING 
DEFINE l_x         LIKE type_file.num5
DEFINE l_totqty,l_woqty   LIKE sfb_file.sfb08,
       l_mod,l_seq,l_i    LIKE type_file.num5
DEFINE l_ta_shm05   LIKE shm_file.ta_shm05   #add by jixf 160809
DEFINE l_tmp     RECORD 
      sel         LIKE type_file.chr1,
      sfb01       LIKE sfb_file.sfb01, 
      sfb05       LIKE sfb_file.sfb05,
      sfb06       LIKE sfb_file.sfb06,
      sfb08       LIKE sfb_file.sfb08,
      num1        LIKE sfb_file.sfb08,  #add by jixf 160809
      num2        LIKE sfb_file.sfb08,  #add by jixf 160809
      sfb08_1     LIKE sfb_file.sfb08,
      imaud10     LIKE ima_file.imaud10,  #str----add by huanglf160801
      imaud07     LIKE ima_file.imaud07,
      sfb13       LIKE sfb_file.sfb13,
      sfb15       LIKE sfb_file.sfb15,
      sfb14       LIKE sfb_file.sfb14,
      sfb16       LIKE sfb_file.sfb16,
      sfb919      LIKE sfb_file.sfb919
        END RECORD 
DEFINE l_shm      RECORD LIKE shm_file.*
DEFINE l_ssn,l_esn     LIKE shm_file.shm18          
DEFINE l_snum,l_enum   LIKE type_file.num20   
DEFINE l_shm18         LIKE shm_file.shm18
DEFINE l_temp          LIKE type_file.chr20   #add by guanyao160615
DEFINE l_imaud10       LIKE ima_file.imaud10  #add by guanyao160715
DEFINE l_imaud07       LIKE ima_file.imaud07  #str----add by huanglf160801
DEFINE l_sfbud07       LIKE sfb_file.sfbud07  #add by guanyao160715   

    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM  asfp310_sel_sfb WHERE sel = 'Y'
    IF l_x = 0 OR cl_null(l_x) THEN 
       RETURN 
    END IF 

    LET l_sql = "SELECT * FROM asfp310_sel_sfb WHERE  sel = 'Y'"
    PREPARE tmp_pre FROM l_sql
    DECLARE tmp_cur CURSOR FOR tmp_pre
    FOREACH tmp_cur INTO l_tmp.*
        
       IF g_sma.sma1421='Y' AND l_tmp.sfb919 IS NOT NULL THEN
         LET l_ssn = ''
         LET l_esn = ''
         CALL s_machine_de_code(l_tmp.sfb05,l_tmp.sfb919) RETURNING l_ssn,l_esn
         LET l_snum = l_ssn
         LET l_enum = l_esn
      END IF
      #str----add by guanyao160715
      #LET l_sfbud07 = ''
      #LET l_imaud10 = ''
      #SELECT sfbud07 INTO l_sfbud07 FROM sfb_file WHERE sfb01 = l_tmp.sfb01
      #IF cl_null(l_sfbud07) OR l_sfbud07 = 0 THEN 
      #ELSE 
      #   LET l_imaud10 = l_tmp.sfb08/l_sfbud07
      #END IF 
      #end----add by guanyao160715
       #IF l_tmp.imaud10 = 0 OR cl_null(l_tmp.imaud10) THEN 
       #   LET l_tmp.imaud10 = 1
       #END IF 
      #IF l_tmp.sfb08 >0 THEN    #mark by jixf 160809
      IF l_tmp.num2 >0 THEN      #add by jixf 160809
       #IF g_lot >0 THEN
         LET l_totqty = 0  LET l_woqty = 0
         #SELECT ceil(l_tmp.sfb08/l_tmp.sfb08_1) INTO l_seq FROM dual   #mark by jixf 160809
         SELECT ceil(l_tmp.num2/l_tmp.sfb08_1) INTO l_seq FROM dual     #add by jixf 160809
         IF l_seq = 0 THEN 
            LET l_seq = 1
         END IF 
         FOR l_i=1 TO l_seq
            IF l_i = l_seq THEN 
               #LET l_totqty = l_tmp.sfb08-(l_seq-1)*l_tmp.sfb08_1   #mark by jixf 160809
               LET l_totqty = l_tmp.num2-(l_seq-1)*l_tmp.sfb08_1     #add by jixf 160809
            ELSE 
               LET l_totqty = l_tmp.sfb08_1
            END IF 
            IF g_sma.sma1421='Y' AND l_tmp.sfb919 IS NOT NULL THEN
               IF l_woqty = 1 THEN
                  IF l_esn IS NOT NULL THEN 
                     LET l_shm18 = s_machine_en_code(l_tmp.sfb05,l_snum)
                     LET l_snum = l_snum + 1
                  ELSE  #計畫批號為號機
                     LET l_shm18 = l_tmp.sfb919
                  END IF
                END IF
             END IF

             IF l_totqty = 0 THEN 
                LET g_success = 'N'
                RETURN 
             END IF 
             INITIALIZE l_shm.* TO NULL
             #--(1)Run Card  (shm_file)---------------------------
             LET l_shm.shm012 =l_tmp.sfb01
             LET l_shm.shm05  =l_tmp.sfb05
             LET l_shm.shm06  =l_tmp.sfb06
             LET l_shm.shm08  =l_totqty
             LET l_shm.shm09  =0 
             LET l_shm.shm10  =0 
             LET l_shm.shm11  =0 
             LET l_shm.shm111 =0 
             LET l_shm.shm12  =0 
             LET l_shm.shm121 =0 
             LET l_shm.shm13  =l_tmp.sfb13
             LET l_shm.shm15  =l_tmp.sfb15
             LET l_shm.shm14  =l_tmp.sfb14
             LET l_shm.shm16  =l_tmp.sfb16
             LET l_shm.shm17  =''
             LET l_shm.shm18  =l_shm18   #FUN-A80102
             LET l_shm.shm28  ='N'
             LET l_shm.shmacti='Y'
             LET l_shm.shmuser=g_user
             LET l_shm.shmgrup=g_grup
             LET l_shm.shmdate=g_today
             LET l_shm.shmplant = g_plant #FUN-980008 add
             LET l_shm.shmlegal = g_legal #FUN-980008 add
             #str---add by guanyao160715
             LET l_shm.ta_shm02 = 'Y' #str---add by huanglf160721
             IF NOT cl_null(l_tmp.imaud10) AND l_tmp.imaud10 != 0 THEN
                LET l_shm.ta_shm01 = l_totqty/l_tmp.imaud10   
             END IF 
             SELECT ceil(l_shm.ta_shm01*100)/100 INTO l_shm.ta_shm01 FROM dual   #add by guanyao160728
             #end---add by guanyao160715
      
             LET l_x = ''
             LET l_temp = ''
             SELECT length(l_tmp.sfb01) INTO l_x FROM dual 
             SELECT MAX(substr(shm01,l_x+2,3)) INTO l_temp FROM shm_file WHERE substr(shm01,1,l_x) = l_tmp.sfb01
             IF cl_null(l_temp) THEN
                LET l_temp = '001'
             ELSE 
                LET l_temp = l_temp +1
                LET l_temp = l_temp USING '&&&'
             END IF 
             LET l_shm.shm01 = l_tmp.sfb01 CLIPPED,'-' CLIPPED,l_temp,'-00'
             IF cl_null(l_shm.shm01) THEN 
                LET g_success = 'N' 
                RETURN
             END IF 
             LET l_shm.shmoriu = g_user      #No.FUN-980030 10/01/04
             LET l_shm.shmorig = g_grup      #No.FUN-980030 10/01/04

             LET l_shm.ta_shm05=l_ta_shm05   #add by jixf 160809
             LET l_shm.ta_shm06='N'   #add by guanyao160928
             INSERT INTO shm_file VALUES(l_shm.*)
             IF SQLCA.sqlcode THEN
                CALl s_errmsg('shm01',l_shm.shm01,l_shm.shm01,'asf-738',1)         #NO.FUN-710026
                LET g_success='N' 
                RETURN                                                        #NO.FUN-710026
             END IF
 
             #--(2)產生製程(sgm_file)-----------------------------
             #------------------No.TQC-630277 modify
             IF g_sma.sma26 != '1' THEN 
                IF not cl_null(l_tmp.sfb06) THEN
                   #-->檢查製程追蹤產生否
                   SELECT COUNT(*) INTO g_cnt FROM sgm_file WHERE sgm01= l_shm.shm01
                   IF g_cnt > 0 THEN
                      DELETE FROM sgm_file WHERE sgm01 = l_shm.shm01
                      IF SQLCA.sqlerrd[3]=0 THEN
                         LET g_success = 'N'
                         CALL cl_err3("del","sgm_file",l_shm.shm01,"","asf-386","","",0)    #No.FUN-660128
                         RETURN 
                      END IF  
                   END IF
                   #-->產生Run Card 製程追蹤檔(sgm_file)
                   CALL s_runcard(l_shm.shm01,l_shm.shm012,l_shm.shm06,
                                  l_shm.shm05,l_shm.shm08)
                      RETURNING g_errno 
                   IF not cl_null(g_errno)  THEN 
                      CALL cl_err(l_tmp.sfb01,g_errno,0)
                      LET g_success = 'N' 
                      RETURN 
                   END IF
                END IF
             END IF 
             #------------------No.TQC-630277 end
 
             OUTPUT TO REPORT p310_rep(l_shm.*)
         END FOR
      END IF
    END FOREACH 
END FUNCTION 
#end-----add by guanyao160714
