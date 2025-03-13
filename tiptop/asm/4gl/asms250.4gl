# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asms250.4gl
# Descriptions...: 系統參數設定作業–採購
# Date & Author..: 92/12/23 By Keith
#                : 重新安排畫面及程式重新Coding 
# Modify.........: 95/03/21 By Danny (加sma886[4],sma886[5])
#                : By charis 將asm45改為'N'後,就無法將該欄位改為'Y'
#                : By iceman 將sam31 open 
# Modify.........: No.MOD-530517 05/03/28 By Carol 出貨版本defult值請調整為:
#                                                  '採購料件成本計算方式'-->default為'0.不作任何成本異動'
#                                                  '請購單輸入時,MISC料件輸入科目'-->default為'N'
# Modify.........: No.MOD-530144 05/04/13 By pengu 發出採購單時，『更新料件主檔最近單價』時，結果是更新到『料件�供應商最近單價
# Modify.........:NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: NO.FUN-720041 07/03/02 BY yiting 加入供應商評核參數
# Modify.........: No.TQC-770042 07/07/13 By Rayven 采購數量大于請購數量差異百分比ABC類若為空，則賦0
# Modify.........: No.FUN-710060 07/08/06 By jamie sma62、sma63從畫面移除
#                                                  程式中原判斷sma62=1者改為判斷ima86=1 OR 3、判斷sma63=1者改為判斷ima86=2 OR 3
# Modify.........: No.MOD-780158 07/08/28 By claire 參數擋掉sma886[6]='N' AND sma886[8]='Y'
#                                                   若 sma886_8 改成Y,則自動set sma886_6=Y 
#                                                   若 sma886_6 改成N,則自動set sma886_8=N ) 
# Modify.........: No.MOD-7A0202 07/10/31 By Smapmin 變數判斷錯誤
# Modify.........: No.FUN-7B0015 08/01/04 By lilingyu 頁簽sma841新增'8.依BODY取價' 
# Modify.........: No.FUN-850120 08/05/21 By rainy 新增sma90收貨�出通單是否做批�序號管理
# Modify.........: No.MOD-870161 08/07/14 By chenmoyan 當不勾選“使用請購功能”時，“請購單也直接錄入”欄直接設為N
# Modify.........: No.MOD-890197 08/09/19 By Smapmin 將BEFORE FIELD sma45mark掉
# Modify.........: No.FUN-930113 09/03/17 By mike 拿掉sma841整段的邏輯
# Modify.........: No.FUN-870100 09/07/17 By cockroach 流通零售移植
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0340 09/12/22 By Cockroach sma132~sam138只在零售業態使用
# Modify.........: No.TQC-A20037 10/02/11 By Cockroach Add "sma140"  
# Modify.........: No.FUN-B30161 11/03/30 By xianghui 入庫單確認時，自動產生帳款(sma91),無發票資料時，產生暫估(sma92)
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40028 11/04/13 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-B40030 11/04/18 By Smapmin 將sma886[3]這個參數隱藏
# Modify.........: No:FUN-B60150 11/06/30 By baogc 添加成本代銷控制欄位
# Modify.........: No:FUN-C40089 12/04/30 By bart 移除採購單價可否為零
# Modify.........: No:FUN-C80030 12/08/13 By xujing sma90根据sma95的值进行控管
# Modify.........: No:MOD-C80173 12/09/20 By jt_chen FUNCTION asms250_u()中CALL asms250_i()後請增加INT_FLAG判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_t         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma886_1       LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_2	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_3	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_4	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_5	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_6	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_7	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_sma886_8	 LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),
        g_menu           LIKE type_file.chr1   #No.FUN-690010   VARCHAR(1)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211    #FUN-B40028
    CALL asms250(2,2) 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211    #FUN-B40028
END MAIN  
 
FUNCTION asms250(p_row,p_col)
    DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
   OPEN WINDOW asms250_w WITH FORM "asm/42f/asms250" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()

   CALL cl_chg_comp_att("g_sma886_3","HIDDEN","1")   #CHI-B40030
 
   IF g_azw.azw04 <> '2' THEN                       #No.FUN-870100
      CALL cl_set_comp_visible('Page5',FALSE)      #No.FUN-870100
      CALL cl_set_comp_visible("sma132,sma133,sma134,sma135,sma136,sma137,sma138,sma140",FALSE) #TQC-A20037 ADD
      CALL cl_set_comp_visible("sma146",FALSE) #FUN-B60150 ADD
   END IF                                           #No.FUN-870100
   CALL asms250_show()
 
   LET g_action_choice=""
   CALL asms250_menu()
 
   CLOSE WINDOW asms250_w
END FUNCTION
 
FUNCTION asms250_show()
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
   DISPLAY BY NAME g_sma.sma31, g_sma.sma44,
                   g_sma.sma45, g_sma.sma32, g_sma.sma33, g_sma.sma341,
                   g_sma.sma342,g_sma.sma343,         #FUN-710060 拿掉g_sma.sma62,g_sma.sma63,
                   g_sma.sma102,g_sma.sma108,g_sma.sma110,g_sma886_1,g_sma886_2,
                   g_sma.sma85,g_sma.sma401,g_sma.sma402,g_sma.sma403,g_sma.sma41,
                  #g_sma.sma103,g_sma.sma90,g_sma.sma134,g_sma.sma135,g_sma886_6,g_sma886_8,g_sma886_7,    #FUN-850120 add sma90  #FUN-870100 add sma134,sma135
                   g_sma.sma103,g_sma.sma90,g_sma.sma134,g_sma.sma135,g_sma.sma140,g_sma886_6,g_sma886_8,g_sma886_7,  #TQC-A20037 ADD sma140
                   g_sma886_3,g_sma886_4,g_sma886_5,g_sma.sma91,g_sma.sma92,g_sma.sma111,        #FUN-B30161 add sma91.sma92
                   g_sma.sma25,g_sma.sma84,g_sma.sma109, #FUN-C40089 g_sma.sma112, #FUN-930113 拿掉g_sma.sma841 
                   g_sma.sma113,g_sma.sma842,g_sma.sma843,g_sma.sma844,g_sma.sma83,
                   g_sma.sma114,g_sma.sma904  #FUN-640012 add 904
 #NO.FUN-720041 start--
   DISPLAY BY NAME g_sma.sma910,g_sma.sma911,g_sma.sma912,
                   g_sma.sma913,g_sma.sma914,g_sma.sma915,
                   g_sma.sma136,g_sma.sma137,g_sma.sma138,g_sma.sma132,g_sma.sma133,     #FUN-870100 add sma136,sma137,sma138,sma132,sma133
                   g_sma.sma146  #FUN-B60150 ADD
 #NO.FUN-720041 end---
{--Genero 修改
    DISPLAY BY NAME g_sma.sma31, g_sma.sma44,
                    g_sma.sma45, g_sma.sma32, g_sma.sma33,  g_sma.sma341,
                    g_sma.sma342,g_sma.sma343,
                   #g_sma.sma351,g_sma.sma352,g_sma.sma353,
                    g_sma.sma41, g_sma.sma36,
                    g_sma.sma37, g_sma.sma401,g_sma.sma402,
                    g_sma.sma403,       #FUN-710060 拿掉g_sma.sma62, g_sma.sma63,
                    g_sma.sma84, g_sma.sma109,g_sma.sma110, g_sma.sma85, 
                    g_sma.sma38, g_sma.sma111,
                    g_sma.sma25, g_sma.sma102,g_sma.sma103,  #bugno.6810 add
                    g_sma.sma108
---}
                    
    LET g_sma886_1=g_sma.sma886[1,1] DISPLAY g_sma886_1 TO g_sma886_1
    LET g_sma886_2=g_sma.sma886[2,2] DISPLAY g_sma886_2 TO g_sma886_2
    LET g_sma886_3=g_sma.sma886[3,3] DISPLAY g_sma886_3 TO g_sma886_3
    LET g_sma886_4=g_sma.sma886[4,4] DISPLAY g_sma886_4 TO g_sma886_4
    LET g_sma886_5=g_sma.sma886[5,5] DISPLAY g_sma886_5 TO g_sma886_5
    LET g_sma886_6=g_sma.sma886[6,6] DISPLAY g_sma886_6 TO g_sma886_6
    LET g_sma886_7=g_sma.sma886[7,7] DISPLAY g_sma886_7 TO g_sma886_7
    LET g_sma886_8=g_sma.sma886[8,8] DISPLAY g_sma886_8 TO g_sma886_8
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms250_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START--
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL asms250_u()
       END IF
#NO.FUN-5B0134 END---- 
   #Genero modi
   #ON ACTION apm_para_2 
   #        CALL asms250_1()
    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #EXIT MENU
    ON ACTION exit
            LET g_action_choice = "exit"
    EXIT MENU
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION asms250_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql = "SELECT * FROM sma_file WHERE sma00 = '0' FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN sma_curl 
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,0)
       RETURN
    END IF
    FETCH sma_curl INTO g_sma.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_sma_o.* = g_sma.*
    LET g_sma_t.* = g_sma.*
    
  
    
   DISPLAY BY NAME g_sma.sma31, g_sma.sma44,
                   g_sma.sma45, g_sma.sma32, g_sma.sma33, g_sma.sma341,
                   g_sma.sma342,g_sma.sma343,         #FUN-710060 拿掉g_sma.sma62,g_sma.sma63,
                   g_sma.sma102,g_sma.sma108,g_sma.sma110,g_sma886_1,g_sma886_2,
                   g_sma.sma85,g_sma.sma401,g_sma.sma402,g_sma.sma403,g_sma.sma41,
                 # g_sma.sma103,g_sma.sma90,g_sma.sma134,g_sma.sma135,g_sma886_6,g_sma886_8,g_sma886_7,       #FUN-850120 add sma90  #FUN-870100 add sma134,sma135
                   g_sma.sma103,g_sma.sma90,g_sma.sma134,g_sma.sma135,g_sma.sma140,g_sma886_6,g_sma886_8,g_sma886_7, #TQC-A20037Add sma140
                   g_sma886_3,g_sma886_4,g_sma886_5,g_sma.sma91,g_sma.sma92,g_sma.sma111,       #FUN-B30161 add sma91.sma92
                   g_sma.sma25,g_sma.sma84,g_sma.sma109,#FUN-C40089 g_sma.sma112, #FUN-930113 拿掉g_sma.sma841 
                   g_sma.sma113,g_sma.sma842,g_sma.sma843,g_sma.sma844,g_sma.sma83,
                   g_sma.sma114,g_sma.sma904  #FUN-640012 add 904
   
  DISPLAY BY NAME  g_sma.sma910,g_sma.sma911,g_sma.sma912,   #FUN-720041
                   g_sma.sma913,g_sma.sma914,g_sma.sma915,   #FUN-720041
                   g_sma.sma136,g_sma.sma137,g_sma.sma138,g_sma.sma132,g_sma.sma133,     #FUN-870100 add sma136,sma137,sma138,sma132,sma133
                   g_sma.sma146  #FUN-B60150 add sma146 

{--Genero修改
    DISPLAY BY NAME g_sma.sma31, g_sma.sma44,
                    g_sma.sma45, g_sma.sma32, g_sma.sma33,  g_sma.sma341,
                    g_sma.sma342,g_sma.sma343,
                  # g_sma.sma351,g_sma.sma352,g_sma.sma353,
                    g_sma.sma41, g_sma.sma36,
                    g_sma.sma37, g_sma.sma401,g_sma.sma402,
                    g_sma.sma403,      #FUN-710060 拿掉g_sma.sma62, g_sma.sma63,
                    g_sma.sma84, g_sma.sma109,g_sma.sma110, g_sma.sma85,
                    g_sma.sma38, g_sma.sma111,
                    g_sma.sma25, g_sma.sma102,g_sma.sma103,  #bugno:6810 add
                    g_sma.sma108
--}
                    
     IF cl_null(g_sma886_4)  THEN LET g_sma.sma886[4,4] = 'N'  END IF  #MOD-530517
     IF cl_null(g_sma.sma25) THEN LET g_sma.sma25 = '0' END IF         #MOD-530517
    LET g_sma886_1=g_sma.sma886[1,1] DISPLAY g_sma886_1 TO g_sma886_1
    LET g_sma886_2=g_sma.sma886[2,2] DISPLAY g_sma886_2 TO g_sma886_2
    LET g_sma886_3=g_sma.sma886[3,3] DISPLAY g_sma886_3 TO g_sma886_3
    LET g_sma886_4=g_sma.sma886[4,4] DISPLAY g_sma886_4 TO g_sma886_4
    LET g_sma886_5=g_sma.sma886[5,5] DISPLAY g_sma886_5 TO g_sma886_5
    LET g_sma886_6=g_sma.sma886[6,6] DISPLAY g_sma886_6 TO g_sma886_6
    LET g_sma886_7=g_sma.sma886[7,7] DISPLAY g_sma886_7 TO g_sma886_7
    LET g_sma886_8=g_sma.sma886[8,8] DISPLAY g_sma886_8 TO g_sma886_8
    CALL asms250_i()
    #MOD-C80173 -- add start --
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CALL cl_err('',9001,0)
       CLOSE sma_curl
       ROLLBACK WORK
       RETURN
    END IF
    #MOD-C80173 -- add end --
    IF cl_null(g_sma.sma25) THEN LET g_sma.sma25 = '0' END IF         #MOD-530517
    UPDATE sma_file SET
            sma31 = g_sma.sma31,
            sma44 = g_sma.sma44,
            sma45 = g_sma.sma45,
            sma32 = g_sma.sma32,
            sma33 = g_sma.sma33,
            sma341= g_sma.sma341,
            sma342= g_sma.sma342,
            sma343= g_sma.sma343,
           #sma351= g_sma.sma351,
           #sma352= g_sma.sma352,
           #sma353= g_sma.sma353,
            sma41 = g_sma.sma41,
           #sma36 = g_sma.sma36,
           #sma37 = g_sma.sma37,
            sma401= g_sma.sma401,
            sma402= g_sma.sma402,
            sma403= g_sma.sma403,
            sma886= g_sma.sma886,
           #sma62 = g_sma.sma62,    #FUN-710060 mark
           #sma63 = g_sma.sma63,    #FUN-710060 mark
            sma84 = g_sma.sma84,
            sma85 = g_sma.sma85,
           #sma38 = g_sma.sma38,
           #sma841= g_sma.sma841,   #FUN-930113 mark
            sma842= g_sma.sma842,
            sma843= g_sma.sma843,
            sma844= g_sma.sma844,
            sma83 = g_sma.sma83,
            sma25 = g_sma.sma25,
            sma102= g_sma.sma102,   #bugno:6810 add
            sma103= g_sma.sma103,   #bugno:6810 add
            sma90 = g_sma.sma90,    #FUN-850120 add
            sma108= g_sma.sma108,   #bugno:7231 add
            sma109= g_sma.sma109,   #bugno:7231 add
            sma110= g_sma.sma110,   #bugno:7231 add
            sma111= g_sma.sma111,   #bugno:7231 add
            #sma112= g_sma.sma112,   #bugno:7231 add  #FUN-C40089
            sma113= g_sma.sma113,   #bugno:7231 add
            sma114= g_sma.sma114,   #bugno:7231 add
            sma904= g_sma.sma904,    #FUN-640012
            sma910= g_sma.sma910,   #FUN-720041
            sma911= g_sma.sma911,   #FUN-720041
            sma912= g_sma.sma912,   #FUN-720041
            sma913= g_sma.sma913,   #FUN-720041
            sma914= g_sma.sma914,   #FUN-720041
            sma915= g_sma.sma915,   #FUN-720041
            sma136= g_sma.sma136,   #FUN-870100
            sma137= g_sma.sma137,   #FUN-870100
            sma138= g_sma.sma138,   #FUN-870100
            sma132= g_sma.sma132,   #FUN-870100
            sma133= g_sma.sma133,   #FUN-870100
            sma134= g_sma.sma134,   #FUN-870100
            sma135= g_sma.sma135    #FUN-870100
           ,sma140= g_sma.sma140    #TQC-A20037
           ,sma91 = g_sma.sma91     #FUN-B30161
           ,sma92 = g_sma.sma92     #FUN-B30161 
           ,sma146= g_sma.sma146    #FUN-B60150 ADD
        WHERE sma00='0'
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
        ROLLBACK WORK
    END IF
   #Genero modi
   # CALL asms250_1()   #No.B136 010328 by linda add 
    CLOSE sma_curl
    COMMIT WORK 
END FUNCTION
 
FUNCTION asms250_i()
   DEFINE   l_dir   LIKE type_file.chr1,   #No.FUN-690010   VARCHAR(01),
            l_dir1  LIKE type_file.chr1    #No.FUN-690010   VARCHAR(01)
   DEFINE   l_cnt1  LIKE type_file.num5    #NO.FUN-720041
   DEFINE   l_cnt2  LIKE type_file.num5    #NO.FUN-720041
   DEFINE   l_cnt3  LIKE type_file.num5    #NO.FUN-740021
   DEFINE   l_cnt4  LIKE type_file.num5    #NO.FUN-720041
   DEFINE   l_n     LIKE type_file.num5    #No.FUN-870100
 
   INPUT BY NAME g_sma.sma31,g_sma.sma44,g_sma.sma45,g_sma.sma904,  #FUN-640012 add sma904
                 g_sma.sma146,g_sma.sma32,g_sma.sma33,              #FUN-B60150 add sma146
                 g_sma.sma341,g_sma.sma342,g_sma.sma343,            #FUN-710060 拿掉g_sma.sma62,g_sma.sma63,
                 g_sma.sma102,g_sma.sma108,g_sma.sma110,g_sma886_1,g_sma886_2,
                 g_sma.sma85,g_sma.sma401,g_sma.sma402,g_sma.sma403,g_sma.sma41,
                #g_sma.sma103,g_sma.sma90,g_sma.sma134,g_sma.sma135,g_sma886_6,g_sma886_8,g_sma886_7,g_sma886_3,    #FUN-850120 add sma90  #FUN-870100 add sma134,sma135
                 g_sma.sma103,g_sma.sma90,g_sma.sma134,g_sma.sma135,g_sma.sma140,g_sma886_6,g_sma886_8,g_sma886_7,g_sma886_3,    #TQC-A20037 ADD
                 g_sma886_4,g_sma886_5,g_sma.sma91,g_sma.sma92,g_sma.sma111,g_sma.sma25, #FUN-930113拿掉g_sma.sma841   #FUN-B30161 add sma91,sma92
                 g_sma.sma84,g_sma.sma109,g_sma.sma113,g_sma.sma842,#FUN-C40089g_sma.sma112,
                 g_sma.sma843,g_sma.sma844,g_sma.sma83,g_sma.sma114,
                 g_sma.sma910,g_sma.sma911,g_sma.sma912,g_sma.sma913,  #FUN-720041
                 g_sma.sma914,g_sma.sma915,                            #FUN-720041
                 g_sma.sma136,g_sma.sma137,g_sma.sma138,g_sma.sma132,g_sma.sma133     #FUN-870100 add sma136,sma137,sma138,sma132,sma133
       WITHOUT DEFAULTS 
 
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL s250_set_entry()
        CALL s250_set_no_entry()
        LET g_before_input_done = TRUE
        #FUN-C80030---add---str---
        IF g_sma.sma95 = 'N' THEN
           LET g_sma.sma90 = 'N' 
           DISPLAY BY NAME g_sma.sma90
           CALL cl_set_comp_entry('sma90',FALSE)
        ELSE
           CALL cl_set_comp_entry('sma90',TRUE)
        END IF
        #FUN-C80030---add---end---
 
    BEFORE FIELD sma31
        CALL s250_set_entry()
 
    AFTER FIELD sma31
        CALL s250_set_no_entry()
 
#----modi by kitty 97/06/19 modi by iceman for tiptop 4.00 99/06/02 
#     AFTER FIELD sma31
#        LET l_dir = "D"
#        IF g_sma.sma31 NOT MATCHES '[YN]'
#           OR g_sma.sma31 IS NULL OR g_sma.sma31 = ' ' THEN
#              LET g_sma.sma31=g_sma_o.sma31
#              DISPLAY BY NAME g_sma.sma31
#              NEXT FIELD sma31
#        END IF
#        LET g_sma_o.sma31=g_sma.sma31
 
 
      BEFORE FIELD sma44
         IF g_sma.sma31 = "N" THEN
            LET g_sma.sma44 = "N"
            DISPLAY BY NAME g_sma.sma44
            NEXT FIELD sma45
         END IF
 
      AFTER FIELD sma44
         IF NOT cl_null(g_sma.sma44) THEN
             IF g_sma.sma44 NOT MATCHES '[YN]' THEN
                 LET g_sma.sma44=g_sma_o.sma44
                 DISPLAY BY NAME g_sma.sma44
                 NEXT FIELD sma44
             END IF
             LET g_sma_o.sma44=g_sma.sma44
         END IF
 
      #-----MOD-890197---------
      #BEFORE FIELD sma45
      #   IF g_sma.sma45 = "N" THEN
      #      LET g_sma.sma32 = "N"
      #      LET g_sma.sma33 = "N"
      #      LET g_sma.sma341 = 0
      #      LET g_sma.sma342 = 0
      #      LET g_sma.sma343 = 0
      #      DISPLAY BY NAME g_sma.sma32,g_sma.sma33,
      #                      g_sma.sma341,g_sma.sma342,
      #                      g_sma.sma343
      #   END IF
      #-----END MOD-890197-----
  
      AFTER FIELD sma45
         IF NOT cl_null(g_sma.sma45) THEN
             IF g_sma.sma45 NOT MATCHES '[YN]' THEN
                 LET g_sma.sma45=g_sma_o.sma45
                 DISPLAY BY NAME g_sma.sma45
                 NEXT FIELD sma45
             END IF
             LET g_sma_o.sma45=g_sma.sma45
         END IF
 
      BEFORE FIELD sma32
#        CALL s250_set_entry()
         IF g_sma.sma31 = "N" THEN
            LET g_sma.sma32 = "N"
            LET g_sma.sma33 = "N"
            LET g_sma.sma341 = 0
            LET g_sma.sma342 = 0
            LET g_sma.sma343 = 0
            DISPLAY BY NAME g_sma.sma32
            DISPLAY BY NAME g_sma.sma33
            DISPLAY BY NAME g_sma.sma341
            DISPLAY BY NAME g_sma.sma342
            DISPLAY BY NAME g_sma.sma343
            NEXT FIELD sma41
         END IF
 
      ON CHANGE sma32
         IF g_sma.sma32 = 'Y' THEN
            CALL s250_set_entry()
         ELSE
            CALL s250_set_no_entry()
         END IF
 
      AFTER FIELD sma32
         IF NOT cl_null(g_sma.sma32) THEN
             IF g_sma.sma32 NOT MATCHES "[YN]"
                OR g_sma.sma32 IS NULL OR g_sma.sma32 = ' ' THEN
                   LET g_sma.sma32=g_sma_o.sma32
                   DISPLAY BY NAME g_sma.sma32
                   NEXT FIELD sma32
             END IF
             LET g_sma_o.sma32=g_sma.sma32
#            CALL s250_set_no_entry()
         END IF
  
      BEFORE FIELD sma33
         IF g_sma.sma32 = "N" THEN
            LET g_sma.sma341 = 0
            LET g_sma.sma342 = 0
            LET g_sma.sma343 = 0
            DISPLAY BY NAME g_sma.sma341
            DISPLAY BY NAME g_sma.sma342
            DISPLAY BY NAME g_sma.sma343
           #NEXT FIELD sma62       #FUN-710060 mark  #Genero 原來是sma41
            NEXT FIELD sma102      #FUN-710060 mod   #Genero 原來是sma41
         END IF
 
      AFTER FIELD sma33
         IF NOT cl_null(g_sma.sma33) THEN
             IF g_sma.sma33 NOT MATCHES '[RW]' THEN
                 LET g_sma.sma33=g_sma_o.sma33
                 DISPLAY BY NAME g_sma.sma33
                 NEXT FIELD sma33
             END IF
             LET g_sma_o.sma33=g_sma.sma33
         END IF
 
      AFTER FIELD sma341
         IF NOT cl_null(g_sma.sma341) THEN
             IF g_sma.sma341 > 100 OR g_sma.sma341 < 0 THEN
                   LET g_sma.sma341=g_sma_o.sma341
                   DISPLAY BY NAME g_sma.sma341
                   NEXT FIELD sma341
             END IF
             LET g_sma_o.sma341=g_sma.sma341
         END IF
         #No.TQC-770042 --start--
         IF cl_null(g_sma.sma341) THEN
            LET g_sma.sma341 = 0
            DISPLAY BY NAME g_sma.sma341
            LET g_sma_o.sma341 = g_sma.sma341
         END IF
         #No.TQC-770042 --end--
 
      AFTER FIELD sma342
         IF NOT cl_null(g_sma.sma342) THEN
             IF g_sma.sma342 > 100 OR g_sma.sma342 < 0 THEN
                 LET g_sma.sma342=g_sma_o.sma342
                 DISPLAY BY NAME g_sma.sma342
                 NEXT FIELD sma342
             END IF
             LET g_sma_o.sma342=g_sma.sma342
         END IF
         #No.TQC-770042 --start--
         IF cl_null(g_sma.sma342) THEN
            LET g_sma.sma342 = 0
            DISPLAY BY NAME g_sma.sma342
            LET g_sma_o.sma342 = g_sma.sma342
         END IF
         #No.TQC-770042 --end--
 
      AFTER FIELD sma343
         IF NOT cl_null(g_sma.sma343) THEN
             IF g_sma.sma343 > 100 OR g_sma.sma343 < 0 THEN
                   LET g_sma.sma343=g_sma_o.sma343
                   DISPLAY BY NAME g_sma.sma343
                   NEXT FIELD sma343
             END IF
             LET g_sma_o.sma343=g_sma.sma343
         END IF
         #No.TQC-770042 --start--
         IF cl_null(g_sma.sma343) THEN
            LET g_sma.sma343 = 0
            DISPLAY BY NAME g_sma.sma343
            LET g_sma_o.sma343 = g_sma.sma343
         END IF
         #No.TQC-770042 --end--
{
      AFTER FIELD sma351
         IF g_sma.sma351 > 100 OR g_sma.sma351 < 0 
            OR g_sma.sma351 IS NULL OR g_sma.sma351 = ' ' THEN
               LET g_sma.sma351=g_sma_o.sma351
               DISPLAY BY NAME g_sma.sma351
               NEXT FIELD sma351
         END IF
         LET g_sma_o.sma351=g_sma.sma351
 
      AFTER FIELD sma352
         IF g_sma.sma352 > 100 OR g_sma.sma352 < 0 
            OR g_sma.sma352 IS NULL OR g_sma.sma352 = ' ' THEN
               LET g_sma.sma352=g_sma_o.sma352
               DISPLAY BY NAME g_sma.sma352
               NEXT FIELD sma352
         END IF
         LET g_sma_o.sma352=g_sma.sma352
         LET l_dir = "D"
 
      BEFORE FIELD sma353 
         IF l_dir = "U" AND g_sma.sma31 = "N" THEN
            NEXT FIELD sma45
         END IF
         IF l_dir = "U" AND g_sma.sma31 = "Y" AND g_sma.sma32 = "N" THEN
            NEXT FIELD sma32
         END IF
      AFTER FIELD sma353
         IF g_sma.sma353 > 100 OR g_sma.sma353 < 0 
            OR g_sma.sma353 IS NULL OR g_sma.sma353 = ' ' THEN
               LET g_sma.sma353=g_sma_o.sma353
               DISPLAY BY NAME g_sma.sma353
               NEXT FIELD sma353
         END IF
         LET g_sma_o.sma353=g_sma.sma353
}
 
      AFTER FIELD sma41
         IF NOT cl_null(g_sma.sma41) THEN
             IF g_sma.sma41 NOT MATCHES '[YN]' THEN
                 LET g_sma.sma41=g_sma_o.sma41
                 DISPLAY BY NAME g_sma.sma41
                 NEXT FIELD sma41
             END IF
             LET g_sma_o.sma41=g_sma.sma41
         END IF
      
{--Genero 修改
      BEFORE FIELD sma36
         CALL s250_set_entry()
 
      AFTER FIELD sma36
         IF NOT cl_null(g_sma.sma36) THEN
             IF g_sma.sma36 NOT MATCHES '[YN]' THEN
                   LET g_sma.sma36=g_sma_o.sma36
                   DISPLAY BY NAME g_sma.sma36
                   NEXT FIELD sma36
             END IF
             LET g_sma_o.sma36=g_sma.sma36
             LET l_dir = "U"
             LET l_dir1 = "D"
         END IF
         CALL s250_set_no_entry()
 
      BEFORE FIELD sma37
         IF g_sma.sma36 = "N" THEN
            LET g_sma.sma37 = 0
            DISPLAY BY NAME g_sma.sma37
            NEXT FIELD sma401
         END IF
 
      AFTER FIELD sma37
         IF NOT cl_null(g_sma.sma37) THEN
             IF g_sma.sma37 > 100 OR g_sma.sma37 < 0 THEN
                 LET g_sma.sma37=g_sma_o.sma37
                 DISPLAY BY NAME g_sma.sma37
                 NEXT FIELD sma37
             END IF
             LET g_sma_o.sma37=g_sma.sma37
         END IF
---}
 
      AFTER FIELD sma401
         IF NOT cl_null(g_sma.sma401) THEN
             IF g_sma.sma401 > 100 OR g_sma.sma401 < 0 THEN
                 LET g_sma.sma401=g_sma_o.sma401
                 DISPLAY BY NAME g_sma.sma401
                 NEXT FIELD sma401
             END IF
             LET g_sma_o.sma401=g_sma.sma401
             LET l_dir1 = "U"
         END IF
 
      AFTER FIELD sma402
         IF NOT cl_null(g_sma.sma402) THEN
             IF g_sma.sma402 > 100 OR g_sma.sma402 < 0 THEN
                 LET g_sma.sma402=g_sma_o.sma402
                 DISPLAY BY NAME g_sma.sma402
                 NEXT FIELD sma402
             END IF
             LET g_sma_o.sma402=g_sma.sma402
         END IF
 
      AFTER FIELD sma403
         IF NOT cl_null(g_sma.sma403) THEN
             IF g_sma.sma403 > 100 OR g_sma.sma403 < 0 THEN
                 LET g_sma.sma403=g_sma_o.sma403
                 DISPLAY BY NAME g_sma.sma403
                 NEXT FIELD sma403
             END IF
             LET g_sma_o.sma403=g_sma.sma403
         END IF
 
      AFTER FIELD g_sma886_1
         IF NOT cl_null(g_sma886_1) THEN
             IF g_sma886_1 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma886_1
             END IF
         END IF
 
      AFTER FIELD g_sma886_2
         IF NOT cl_null(g_sma886_2) THEN
             IF g_sma886_2 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma886_2
             END IF
         END IF
 
      AFTER FIELD g_sma886_4
         IF NOT cl_null(g_sma886_4) THEN
             IF g_sma886_4 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma886_4
             END IF
         END IF

      #FUN-C80030---add---str---
      AFTER FIELD sma90
         IF g_sma.sma95 != g_sma.sma90 AND g_sma.sma95 = 'N' THEN
            CALL cl_err('','asm-233',0)
            LET g_sma.sma90 = g_sma.sma95
            NEXT FIELD sma90
         END IF
      #FUN-C80030---add---end---
 
      ON CHANGE sma91
         IF g_sma.sma91 = 'N' THEN
            CALL cl_set_comp_entry("sma92",FALSE)
            LET g_sma.sma92 = 'N'
            DISPLAY BY NAME g_sma.sma92
         ELSE
            CALL cl_set_comp_entry("sma92",TRUE)
         END IF         
 
      BEFORE FIELD sma92
         IF g_sma.sma91 = 'N' THEN 
            CALL cl_set_comp_entry("sma92",FALSE)
            LET g_sma.sma92 = 'N'
         END IF 
      AFTER FIELD g_sma886_5
         IF NOT cl_null(g_sma886_5) THEN
             IF g_sma886_5 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma886_5
             END IF
         END IF
  
      BEFORE FIELD g_sma886_6
         CALL s250_set_entry()
 
     #AFTER FIELD g_sma886_6   #MOD-780158 mark
      ON CHANGE g_sma886_6     #MOD-780158 modify  
         IF g_sma886_6 = 'N' THEN
             LET g_sma886_8 = 'N'
             DISPLAY BY NAME g_sma886_8
         END IF
         CALL s250_set_no_entry()
  
     #AFTER FIELD g_sma886_8    #MOD-780158 mark
      ON CHANGE g_sma886_8      #MOD-780158 modify
         IF NOT cl_null(g_sma886_8) THEN
             IF g_sma886_8 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma886_8
             END IF
        #MOD-780158-begin-add
         IF g_sma886_8 = 'Y' THEN
             LET g_sma886_6 = 'Y'
             DISPLAY BY NAME g_sma886_6
         END IF
        #MOD-780158-end-add
         END IF
#bugno:6810 add .....................................................
 
      BEFORE FIELD sma102 
         IF cl_null(g_sma.sma102) THEN
            LET g_sma.sma102 = 'Y'
         END IF 
         DISPLAY BY NAME g_sma.sma102
 
      AFTER FIELD sma102 
         IF NOT cl_null(g_sma.sma102) THEN
             IF g_sma.sma102 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD sma102
             END IF
         END IF
 
      BEFORE FIELD sma103 
         IF cl_null(g_sma.sma103) THEN 
            LET g_sma.sma103 = '1'
         END IF 
         DISPLAY BY NAME g_sma.sma103
 
      AFTER FIELD sma103 
         IF NOT cl_null(g_sma.sma103) THEN
             IF g_sma.sma103 NOT MATCHES "[012]" THEN
                 NEXT FIELD sma103
             END IF
         END IF
#bugno:6810 end .....................................................
#No.FUN-870100---start---
 
      AFTER FIELD sma134
        IF g_sma.sma134<=0 THEN
           CALL cl_err('',-32406,0)
           LET g_sma.sma134 = g_sma_t.sma134
           NEXT FIELD sma134
        END IF
#No.FUN-870100---end---
 
      BEFORE FIELD sma108                          #BugNo.7231
         IF cl_null(g_sma.sma108) THEN
            LET g_sma.sma108 = 'Y' 
         END IF 
         DISPLAY BY NAME g_sma.sma108
 
      AFTER FIELD sma108 
         IF NOT cl_null(g_sma.sma108) THEN
             IF g_sma.sma108 NOT MATCHES "[YN]" THEN
                 NEXT FIELD sma108
             END IF
         END IF                                    #BugNo.7231 END
 
     #FUN-710060---mark---str---
     #AFTER FIELD sma62
     #   IF NOT cl_null(g_sma.sma62) THEN
     #       IF g_sma.sma62 NOT MATCHES '[12]' THEN
     #           LET g_sma.sma62=g_sma_o.sma62
     #           DISPLAY BY NAME g_sma.sma62
     #           NEXT FIELD sma62
     #       END IF
     #       LET g_sma_o.sma62=g_sma.sma62
     #   END IF
 
     #AFTER FIELD sma63
     #   IF NOT cl_null(g_sma.sma63) THEN
     #       IF g_sma.sma63 NOT MATCHES '[12]' THEN
     #           LET g_sma.sma63=g_sma_o.sma63
     #           DISPLAY BY NAME g_sma.sma63
     #           NEXT FIELD sma63
     #       END IF
     #       LET g_sma_o.sma63=g_sma.sma63
     #   END IF
     #FUN-710060---mark---end---
 
      AFTER FIELD sma84
         IF NOT cl_null(g_sma.sma84) THEN
             IF g_sma.sma84 > 100 OR g_sma.sma84 < 0 THEN
                 LET g_sma.sma84=g_sma_o.sma84
                 DISPLAY BY NAME g_sma.sma84
                 NEXT FIELD sma84
             END IF
             LET g_sma_o.sma84=g_sma.sma84
         END IF
 
      BEFORE FIELD sma109                          #BugNo.7231
         IF cl_null(g_sma.sma109) THEN
            LET g_sma.sma109 = 'W' 
         END IF 
         DISPLAY BY NAME g_sma.sma109
 
      AFTER FIELD sma109                           #BugNo.7231
         IF NOT cl_null(g_sma.sma109) THEN
            IF g_sma.sma109 NOT MATCHES "[RW]" THEN
                NEXT FIELD sma109
            END IF
         END IF                                    #BugNo.7231 END
 
      BEFORE FIELD sma110                          #BugNo.7231
         IF cl_null(g_sma.sma110) THEN
            LET g_sma.sma110 = 1
         END IF 
         DISPLAY BY NAME g_sma.sma110
 
      AFTER FIELD sma110                           #BugNo.7231
         IF NOT cl_null(g_sma.sma110) THEN
             IF g_sma.sma110 < 1 THEN
                NEXT FIELD sma110
             END IF
         END IF
                                                   #BugNo.7231 END
 
      AFTER FIELD sma85
         IF NOT cl_null(g_sma.sma85) THEN
             IF g_sma.sma85 NOT MATCHES '[RW]' THEN
                LET g_sma.sma85=g_sma_o.sma85
                DISPLAY BY NAME g_sma.sma85
                NEXT FIELD sma85
             END IF
             LET g_sma_o.sma85=g_sma.sma85
         END IF
 
{--Genero拿掉
      AFTER FIELD sma38
         IF NOT cl_null(g_sma.sma38) THEN
             IF g_sma.sma38 NOT MATCHES '[YN]' THEN
                 LET g_sma.sma38=g_sma_o.sma38
                 DISPLAY BY NAME g_sma.sma38
                 NEXT FIELD sma38
             END IF
             LET g_sma_o.sma38=g_sma.sma38
         END IF
--}
      BEFORE FIELD sma111                          #BugNo.7231
         IF cl_null(g_sma.sma111) THEN
            LET g_sma.sma111 = 'Y'
         END IF 
         DISPLAY BY NAME g_sma.sma111
 
      AFTER FIELD sma111                           #BugNo.7231
         IF NOT cl_null(g_sma.sma111) THEN
             IF g_sma.sma111 NOT MATCHES "[YN]" THEN
                 NEXT FIELD sma111
             END IF
         END IF                                    #BugNo.7231 END
 
      AFTER FIELD g_sma886_3
         IF NOT cl_null(g_sma886_3) THEN
             IF g_sma886_3 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma886_3
             END IF
         END IF
      
#--Genero add合併採購參數二
      #FUN-C40089---begin
      #BEFORE FIELD sma112                          #BugNo.7231
      #   IF cl_null(g_sma.sma112) THEN
      #      LET g_sma.sma112 = 'Y' 
      #   END IF 
      #   DISPLAY BY NAME g_sma.sma112
 
      #AFTER FIELD sma112                           #BugNo.7231
      #   IF NOT cl_null(g_sma.sma112) THEN
      #       IF g_sma.sma112 NOT MATCHES "[YN]" THEN
      #           NEXT FIELD sma112
      #       END IF
      #   END IF                                    #BugNo.7231 END
      #FUN-C40089---end
      AFTER FIELD sma25
         IF NOT cl_null(g_sma.sma25) THEN
            IF g_sma.sma25 NOT MATCHES '[012]' THEN
                LET g_sma.sma25=g_sma_o.sma25
                DISPLAY BY NAME g_sma.sma25
                NEXT FIELD sma25
            END IF
            LET g_sma_o.sma25=g_sma.sma25
         END IF             
    
#FUN-930113 mark --start
     #AFTER FIELD sma841
     #    IF NOT cl_null(g_sma.sma841) THEN
     #       #NO.FUN-7B0015   ---START---
     #       IF NOT s_industry("icd") THEN
     #          IF g_sma.sma841 ="8" THEN
     #              CALL cl_err(g_sma.sma841,"asm-250",1)
     #              NEXT FIELD sma841
     #          END IF
     #       END IF           
     #       #NNO.FUN-7B0015 ---END--- 
     #        IF g_sma.sma841 NOT MATCHES '[12345678]' THEN #NO:7231 增加7.核價檔取價
     #            LET g_sma.sma841=g_sma_o.sma841
     #            DISPLAY BY NAME g_sma.sma841
     #            NEXT FIELD sma841
     #       END IF
     #       LET g_sma_o.sma841=g_sma.sma841
     #   END IF
#FUN-930113 mark --end
  
      AFTER FIELD sma842
         IF NOT cl_null(g_sma.sma842) THEN
             IF g_sma.sma842 NOT MATCHES '[123]' THEN
                 LET g_sma.sma842=g_sma_o.sma842
                 DISPLAY BY NAME g_sma.sma842
                 NEXT FIELD sma842
             END IF
             LET g_sma_o.sma842=g_sma.sma842
         END IF
  
      BEFORE FIELD sma113                          #BugNo.7231
         IF cl_null(g_sma.sma113) THEN
            LET g_sma.sma113 = '1' 
         END IF 
         DISPLAY BY NAME g_sma.sma113
 
      AFTER FIELD sma113                           #BugNo.7231
         IF NOT cl_null(g_sma.sma113) THEN
             IF g_sma.sma113 NOT MATCHES "[123]" THEN
                 NEXT FIELD sma113
             END IF
         END IF                                    #BugNo.7231 END
 
      BEFORE FIELD sma114                          #BugNo.7231
         IF cl_null(g_sma.sma114) THEN
            LET g_sma.sma114 = 'Y' 
         END IF 
         DISPLAY BY NAME g_sma.sma114
 
      AFTER FIELD sma114                           #BugNo.7231
         IF NOT cl_null(g_sma.sma114) THEN
             IF g_sma.sma114 NOT MATCHES "[YN]" THEN
                 NEXT FIELD sma114
             END IF
         END IF                                    #BugNo.7231 END
 
      AFTER FIELD sma843
         IF NOT cl_null(g_sma.sma843) THEN 
             IF g_sma.sma843 NOT MATCHES '[123]' THEN
                 LET g_sma.sma843=g_sma_o.sma843
                 DISPLAY BY NAME g_sma.sma843
                 NEXT FIELD sma843
             END IF
             LET g_sma_o.sma843=g_sma.sma843
         END IF
  
      AFTER FIELD sma844
         IF NOT cl_null(g_sma.sma844) THEN
             IF g_sma.sma844 NOT MATCHES '[123]' THEN
                LET g_sma.sma844=g_sma_o.sma844
                DISPLAY BY NAME g_sma.sma844
                NEXT FIELD sma844
             END IF
             LET g_sma_o.sma844=g_sma.sma844
         END IF
  
      AFTER FIELD sma83
         IF NOT cl_null(g_sma.sma83) THEN
             IF g_sma.sma83 NOT MATCHES '[123]' THEN
                 LET g_sma.sma83=g_sma_o.sma83
                 DISPLAY BY NAME g_sma.sma83
                 NEXT FIELD sma83
             END IF
             LET g_sma_o.sma83=g_sma.sma83
         END IF
#--add end
 
#FUN-720041  start----
     AFTER FIELD sma910
         IF NOT cl_null(g_sma.sma910) THEN
             SELECT COUNT(*) INTO l_cnt1
               FROM ppa_file
              WHERE ppa02 = g_sma.sma910
             IF l_cnt1 = 0 THEN
                 CALL cl_err('','asm-623',1)
                 NEXT FIELD sma910
             END IF
         END IF
 
     AFTER FIELD sma911
         IF NOT cl_null(g_sma.sma911) THEN
             SELECT COUNT(*) INTO l_cnt2
               FROM ppa_file
              WHERE ppa02 = g_sma.sma911
             #IF l_cnt1 = 0 THEN   #MOD-7A0202
             IF l_cnt2 = 0 THEN   #MOD-7A0202
                 CALL cl_err('','asm-623',1)
                 NEXT FIELD sma911
             END IF
         END IF
 
     AFTER FIELD sma912
         IF NOT cl_null(g_sma.sma912) THEN
             SELECT COUNT(*) INTO l_cnt3
               FROM ppa_file
              WHERE ppa02 = g_sma.sma912
             IF l_cnt3 = 0 THEN
                 CALL cl_err('','asm-623',1)
                 NEXT FIELD sma912
             END IF
         END IF
 
     AFTER FIELD sma913
         IF NOT cl_null(g_sma.sma913) THEN
             SELECT COUNT(*) INTO l_cnt4
               FROM ppa_file
              WHERE ppa02 = g_sma.sma913
             IF l_cnt4 = 0 THEN
                 CALL cl_err('','asm-623',1)
                 NEXT FIELD sma913
             END IF
         END IF
 
     AFTER FIELD sma914
         IF NOT cl_null(g_sma.sma914) THEN
             IF g_sma.sma914 < 0 THEN
                 LET g_sma.sma914 = g_sma_o.sma914
                 DISPLAY BY NAME g_sma.sma914
                 NEXT FIELD sma914
             END IF
         END IF
 
     AFTER FIELD sma915
         DISPLAY g_sma.sma915 TO FORMONLY.sma915
         IF NOT cl_null(g_sma.sma915) THEN
             IF g_sma.sma915 > 99 OR g_sma.sma915 < 0 THEN 
                 LET g_sma.sma915=g_sma_o.sma915
                 DISPLAY BY NAME g_sma.sma915
                 NEXT FIELD sma915
             END IF
         END IF
#FUN-720041 end-------
 
#No.FUN-870100---start---
     AFTER FIELD sma136
         IF cl_null(g_sma.sma136) THEN
               CALL cl_err('','asm-609',1)
               NEXT FIELD sma136
         END IF
 
      AFTER FIELD sma137
        IF cl_null(g_sma.sma137) THEN
               CALL cl_err('','asm-609',1)
               NEXT FIELD sma137
         END IF
        IF g_sma.sma137<0 THEN
           CALL cl_err('',-32406,0)
           LET g_sma.sma137 = g_sma_t.sma137
           NEXT FIELD sma137
        END IF
 
     AFTER FIELD sma133
        IF g_sma.sma133<0 THEN
           CALL cl_err('',-32406,0)
           LET g_sma.sma133 = g_sma_t.sma133
           NEXT FIELD sma133
        END IF
 
     AFTER FIELD sma135
        IF cl_null(g_sma.sma135) THEN
               CALL cl_err('','asm-609',1)
               NEXT FIELD sma135
        END IF

     AFTER FIELD sma140
        IF cl_null(g_sma.sma140) THEN
               CALL cl_err('','asm-609',1)
               NEXT FIELD sma140
        END IF
 
     AFTER FIELD sma138
        IF cl_null(g_sma.sma138) THEN
               CALL cl_err('','asm-609',1)
               NEXT FIELD sma138
        END IF
 
     AFTER FIELD sma132
        IF cl_null(g_sma.sma132) THEN
               CALL cl_err('','asm-609',1)
               NEXT FIELD sma132
        END IF
 
#No.FUN-870100---end---
 
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
#No.MOD-870161 --Begin                                                                                                              
         IF g_sma.sma31='N' THEN                                                                                                     
            LET g_sma.sma44='N'                                                                                                    
            DISPLAY BY NAME g_sma.sma44
         END IF                                                                                                                      
#No.MOD-870161 --END 
 
#NO.FUN-720041 start--
     ON ACTION CONTROLP                  
        CASE
           WHEN INFIELD(sma910)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ppa" 
              LET g_qryparam.default1 = g_sma.sma910
              CALL cl_create_qry() RETURNING g_sma.sma910
              DISPLAY BY NAME g_sma.sma910
              NEXT FIELD sma910
           WHEN INFIELD(sma911)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ppa" 
              LET g_qryparam.default1 = g_sma.sma911
              CALL cl_create_qry() RETURNING g_sma.sma911
              DISPLAY BY NAME g_sma.sma911
              NEXT FIELD sma911
           WHEN INFIELD(sma912)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ppa" 
              LET g_qryparam.default1 = g_sma.sma912
              CALL cl_create_qry() RETURNING g_sma.sma912
              DISPLAY BY NAME g_sma.sma912
              NEXT FIELD sma912
           WHEN INFIELD(sma913)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ppa" 
              LET g_qryparam.default1 = g_sma.sma913
              CALL cl_create_qry() RETURNING g_sma.sma913
              DISPLAY BY NAME g_sma.sma913
              NEXT FIELD sma913
           OTHERWISE         
        END CASE
#NO.FUN-720041 end----
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
 
   LET g_sma.sma886[1,1] = g_sma886_1
   LET g_sma.sma886[2,2] = g_sma886_2
   LET g_sma.sma886[3,3] = g_sma886_3
 #MOD-530517
   IF cl_null(g_sma886_4) THEN 
      LET g_sma886_4 = 'N'
   END IF
##
   LET g_sma.sma886[4,4] = g_sma886_4
   LET g_sma.sma886[5,5] = g_sma886_5
   LET g_sma.sma886[6,6] = g_sma886_6
   LET g_sma.sma886[7,7] = g_sma886_7
   LET g_sma.sma886[8,8] = g_sma886_8
END FUNCTION
 
{----Genero modi
FUNCTION asms250_i1()
   INPUT BY NAME g_sma.sma841, g_sma.sma842,g_sma.sma843, 
                 g_sma.sma844, g_sma.sma83,
                 g_sma.sma112, g_sma.sma114,g_sma.sma113
       WITHOUT DEFAULTS 
 
      BEFORE FIELD sma112                          #BugNo.7231
         IF cl_null(g_sma.sma112) THEN
            LET g_sma.sma112 = 'Y' 
         END IF 
         DISPLAY BY NAME g_sma.sma112
 
      AFTER FIELD sma112                           #BugNo.7231
         IF NOT cl_null(g_sma.sma112) THEN
             IF g_sma.sma112 NOT MATCHES "[YN]" THEN
                 NEXT FIELD sma112
             END IF
         END IF                                    #BugNo.7231 END
 
      AFTER FIELD sma841
         IF NOT cl_null(g_sma.sma841) THEN
             IF g_sma.sma841 NOT MATCHES '[1234567]' THEN #NO:7231 增加7.核價檔取價
                 LET g_sma.sma841=g_sma_o.sma841
                 DISPLAY BY NAME g_sma.sma841
                 NEXT FIELD sma841
             END IF
             LET g_sma_o.sma841=g_sma.sma841
         END IF
  
      AFTER FIELD sma842
         IF NOT cl_null(g_sma.sma842) THEN
             IF g_sma.sma842 NOT MATCHES '[123]' THEN
                 LET g_sma.sma842=g_sma_o.sma842
                 DISPLAY BY NAME g_sma.sma842
                 NEXT FIELD sma842
             END IF
             LET g_sma_o.sma842=g_sma.sma842
         END IF
  
      BEFORE FIELD sma113                          #BugNo.7231
         IF cl_null(g_sma.sma113) THEN
            LET g_sma.sma113 = '1' 
         END IF 
         DISPLAY BY NAME g_sma.sma113
 
      AFTER FIELD sma113                           #BugNo.7231
         IF NOT cl_null(g_sma.sma113) THEN
             IF g_sma.sma113 NOT MATCHES "[123]" THEN
                 NEXT FIELD sma113
             END IF
         END IF                                    #BugNo.7231 END
 
      BEFORE FIELD sma114                          #BugNo.7231
         IF cl_null(g_sma.sma114) THEN
            LET g_sma.sma114 = 'Y' 
         END IF 
         DISPLAY BY NAME g_sma.sma114
 
      AFTER FIELD sma114                           #BugNo.7231
         IF NOT cl_null(g_sma.sma114) THEN
             IF g_sma.sma114 NOT MATCHES "[YN]" THEN
                 NEXT FIELD sma114
             END IF
         END IF                                    #BugNo.7231 END
 
      AFTER FIELD sma843
         IF NOT cl_null(g_sma.sma843) THEN 
             IF g_sma.sma843 NOT MATCHES '[123]' THEN
                 LET g_sma.sma843=g_sma_o.sma843
                 DISPLAY BY NAME g_sma.sma843
                 NEXT FIELD sma843
             END IF
             LET g_sma_o.sma843=g_sma.sma843
         END IF
  
      AFTER FIELD sma844
         IF NOT cl_null(g_sma.sma844) THEN
             IF g_sma.sma844 NOT MATCHES '[123]' THEN
                LET g_sma.sma844=g_sma_o.sma844
                DISPLAY BY NAME g_sma.sma844
                NEXT FIELD sma844
             END IF
             LET g_sma_o.sma844=g_sma.sma844
         END IF
  
      AFTER FIELD sma83
         IF NOT cl_null(g_sma.sma83) THEN
             IF g_sma.sma83 NOT MATCHES '[123]' THEN
                 LET g_sma.sma83=g_sma_o.sma83
                 DISPLAY BY NAME g_sma.sma83
                 NEXT FIELD sma83
             END IF
             LET g_sma_o.sma83=g_sma.sma83
         END IF
      
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
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
 
END FUNCTION
 
{--沒用先拿掉
FUNCTION asms250_sma32()
   INPUT BY NAME g_sma.sma33 WITHOUT DEFAULTS 
 
      AFTER FIELD sma33
         IF NOT cl_null(g_sma.sma33) THEN
             IF g_sma.sma33 NOT MATCHES '[RW]' THEN
                 LET g_sma.sma33=g_sma_o.sma33
                 DISPLAY BY NAME g_sma.sma33
                 NEXT FIELD sma33
             END IF
             LET g_sma_o.sma33=g_sma.sma33
         END IF
 
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
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
END FUNCTION
---}
 
{--Genero modi
#No.B136 010328 by linda mod
FUNCTION asms250_1()
    WHILE TRUE
        OPEN WINDOW asms2501_w1 WITH FORM "asm/42f/asms2501" 
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
        CALL cl_ui_locale("asms2501")
 
        DISPLAY BY NAME g_sma.sma112, g_sma.sma841, g_sma.sma842,
                        g_sma.sma113, g_sma.sma114, g_sma.sma843,
                        g_sma.sma844, g_sma.sma83
        
        CLOSE WINDOW asms2501_w1
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
                sma31 = g_sma.sma31,
                sma44 = g_sma.sma44,
                sma45 = g_sma.sma45,
                sma32 = g_sma.sma32,
                sma33 = g_sma.sma33,
                sma341= g_sma.sma341,
                sma342= g_sma.sma342,
                sma343= g_sma.sma343,
               #sma351= g_sma.sma351,
               #sma352= g_sma.sma352,
               #sma353= g_sma.sma353,
                sma41 = g_sma.sma41,
               #sma36 = g_sma.sma36,
               #sma37 = g_sma.sma37,
                sma401= g_sma.sma401,
                sma402= g_sma.sma402,
                sma403= g_sma.sma403,
                sma886= g_sma.sma886,
               #sma62 = g_sma.sma62,   #FUN-710060 mark
               #sma63 = g_sma.sma63,   #FUN-710060 mark
                sma84 = g_sma.sma84,
                sma85 = g_sma.sma85,
               #sma38 = g_sma.sma38,
                sma841= g_sma.sma841,
                sma842= g_sma.sma842,
                sma843= g_sma.sma843,
                sma844= g_sma.sma844,
                sma83 = g_sma.sma83,
                sma25 = g_sma.sma25,
                sma102= g_sma.sma102,   #bugno:6810 add
                sma103= g_sma.sma103,   #bugno:6810 add
                sma90 = g_sma.sma90,    #FUN-850120 add
                sma108= g_sma.sma108,   #bugno:7231 add
                sma109= g_sma.sma109,   #bugno:7231 add
                sma110= g_sma.sma110,   #bugno:7231 add
                sma111= g_sma.sma111,   #bugno:7231 add
                sma112= g_sma.sma112,   #bugno:7231 add
                sma113= g_sma.sma113,   #bugno:7231 add
                sma114= g_sma.sma114,   #bugno:7231 add
                sma910= g_sma.sma910,   #FUN-720041
                sma911= g_sma.sma911,   #FUN-720041
                sma912= g_sma.sma912,   #FUN-720041
                sma913= g_sma.sma913,   #FUN-720041
                sma914= g_sma.sma914,   #FUN-720041
                sma915= g_sma.sma915    #FUN-720041
            WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
----}
 
#genero
FUNCTION s250_set_entry()
 
   IF INFIELD(sma31) OR (NOT g_before_input_done) THEN
#     CALL cl_set_comp_entry("sma44,sma32,sma33,sma341,sma342,sma343",TRUE)
      CALL cl_set_comp_entry("sma44,sma32",TRUE)
   END IF
 
{--Genero modi
   IF INFIELD(sma36) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma37",TRUE)
   END IF
--}
 
   IF INFIELD(sma886_6) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma886_8",TRUE)
   END IF
 
   IF INFIELD(sma32) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma33,sma341,sma342,sma343",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION s250_set_no_entry()
 
   IF INFIELD(sma31) OR (NOT g_before_input_done) THEN
      IF g_sma.sma31='N' THEN
 #        CALL cl_set_comp_entry("sma44,sma32,sma33,sma341,sma342,sma343",FALSE)
          CALL cl_set_comp_entry("sma44,sma32",FALSE)
      END IF
   END IF
 
{--Genero modi
   IF INFIELD(sma36) OR (NOT g_before_input_done) THEN
      IF g_sma.sma36='N' THEN
          CALL cl_set_comp_entry("sma37",FALSE)
      END IF
   END IF
--}
 
   IF INFIELD(sma886_6) OR (NOT g_before_input_done) THEN
      IF g_sma886_6 = 'N' THEN
          CALL cl_set_comp_entry("sma886_8",FALSE)
      END IF
   END IF
 
   IF INFIELD(sma32) OR (NOT g_before_input_done) THEN
      IF g_sma.sma32='N' THEN
          CALL cl_set_comp_entry("sma33,sma341,sma342,sma343",FALSE)
      END IF
   END IF
   
   IF g_sma.sma91 = 'N' THEN 
      CALL cl_set_comp_entry("sma92",FALSE)
   END IF 
 
END FUNCTION
