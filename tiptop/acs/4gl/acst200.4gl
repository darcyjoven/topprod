# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acst200.4gl
# Descriptions...: 模擬成本資料轉為料件成本資料
# Date & Author..: 92/01/14 By MAY
# Release 4.0....: 92/07/24 By Jones
# search % to modify
 # Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   tm       RECORD                          # Print condition RECORD
             a      LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(01),
             b      LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(01),
             c      LIKE type_file.chr1     #No.FUN-680071 VARCHAR(01)
            END RECORD,
    l_imb   RECORD LIKE imb_file.*,
    l_iml   RECORD LIKE iml_file.*,
    g_csa   RECORD LIKE csa_file.*,
    g_csb   RECORD LIKE csb_file.*,
    g_sql   RECORD LIKE csb_file.*,
     g_wc                string,  #No.FUN-580092 HCN
    g_cmd               LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(60)
    l_sql               LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(100)
 
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0064
   DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
 
   LET p_row = 5 LET p_col = 9
 
   OPEN WINDOW acst201_w AT p_row,p_col
     WITH FORM "acs/42f/acst200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   SELECT csc02 INTO tm.b FROM csc_file WHERE csc01 = '0'
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err('','mfg6013',1)   #No.FUN-660089
      CALL cl_err3("sel","csc_file","","","mfg6013","","",1)  #No.FUN-660089
      EXIT PROGRAM
   END IF
 
   LET tm.a = 'Y'
   LET tm.c = tm.b
 
   CASE tm.b
      WHEN '1'
         CALL cl_getmsg('mfg1315',g_lang) RETURNING g_msg
      WHEN '2'
         CALL cl_getmsg('mfg1316',g_lang) RETURNING g_msg
      WHEN '3'
         CALL cl_getmsg('mfg1317',g_lang) RETURNING g_msg
   END CASE
 
   DISPLAY g_msg TO FORMONLY.b
   DISPLAY BY NAME tm.a,tm.c
 
   INPUT BY NAME tm.a,tm.c WITHOUT DEFAULTS
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      AFTER FIELD c
          IF tm.c NOT MATCHES '[123]'  OR tm.c IS NULL THEN
             NEXT FIELD c
          END IF
 
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
 
   IF tm.a = 'Y' THEN
      IF cl_sure(17,20) THEN
         CALL t200_u()       #imb_file 的UPDATE
         CALL t200_u1()      #iml_file 的UPDATE
      END IF
   END IF
 
   CLOSE WINDOW acst200_w
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
 
END MAIN
 
FUNCTION t200_u()
 
   LET l_sql = " SELECT * FROM csa_file ",
               " WHERE csa02 = '0' ",
               " ORDER BY csa01 "
   PREPARE t200_pre FROM l_sql
   DECLARE t200_cs CURSOR FOR t200_pre
 
   FOREACH t200_cs INTO g_csa.*
      DISPLAY g_csa.csa01 AT 1,1
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      INITIALIZE l_imb.* TO  NULL
 
      SELECT *  FROM imb_file WHERE imb01 = g_csa.csa01
      IF SQLCA.sqlcode THEN
         LET l_imb.imb01 = g_csa.csa01
         LET l_imb.imbgrup=g_grup    #資料所有者所屬群
         LET l_imb.imbmodu=NULL      #資料修改日期
         LET l_imb.imbdate=g_today   #資料建立日期
         LET l_imb.imbacti='Y'       #有效資料
         LET l_imb.imbuser = g_user
         #---020613 add
         LET l_imb.imb111  =0         #not null
         LET l_imb.imb112  =0         #not null
         LET l_imb.imb1131 =0         #not null
         LET l_imb.imb1132 =0         #not null
         LET l_imb.imb114  =0         #not null
         LET l_imb.imb115  =0         #not null
         LET l_imb.imb1151 =0         #not null
         LET l_imb.imb116  =0         #not null
         LET l_imb.imb1171 =0         #not null
         LET l_imb.imb1172 =0         #not null
         LET l_imb.imb119  =0         #not null
         LET l_imb.imb118  =0         #not null
         LET l_imb.imb120  =0         #not null
         LET l_imb.imb121  =0         #not null
         LET l_imb.imb122  =0         #not null
         LET l_imb.imb1231 =0         #not null
         LET l_imb.imb1232 =0         #not null
         LET l_imb.imb124  =0         #not null
         LET l_imb.imb125  =0         #not null
         LET l_imb.imb1251 =0         #not null
         LET l_imb.imb126  =0         #not null
         LET l_imb.imb1271 =0         #not null
         LET l_imb.imb1272 =0         #not null
         LET l_imb.imb129  =0         #not null
         LET l_imb.imb130  =0         #not null
         LET l_imb.imb211  =0         #not null
         LET l_imb.imb212  =0         #not null
         LET l_imb.imb2131 =0         #not null
         LET l_imb.imb2132 =0         #not null
         LET l_imb.imb214  =0         #not null
         LET l_imb.imb215  =0         #not null
         LET l_imb.imb2151 =0         #not null  
         LET l_imb.imb216  =0         #not null
         LET l_imb.imb2171 =0         #not null
         LET l_imb.imb2172 =0         #not null
         LET l_imb.imb219  =0         #not null
         LET l_imb.imb218  =0         #not null
         LET l_imb.imb220  =0         #not null
         LET l_imb.imb221  =0         #not null
         LET l_imb.imb222  =0         #not null
         LET l_imb.imb2231 =0         #not null
         LET l_imb.imb2232 =0         #not null
         LET l_imb.imb224  =0         #not null
         LET l_imb.imb225  =0         #not null
         LET l_imb.imb2251 =0         #not null
         LET l_imb.imb226  =0         #not null
         LET l_imb.imb2271 =0         #not null
         LET l_imb.imb2272 =0         #not null
         LET l_imb.imb229  =0         #not null
         LET l_imb.imb230  =0         #not null
         LET l_imb.imb311  =0         #not null
         LET l_imb.imb312  =0         #not null
         LET l_imb.imb3131 =0         #not null
         LET l_imb.imb3132 =0         #not null
         LET l_imb.imb314  =0         #not null
         LET l_imb.imb315  =0         #not null
         LET l_imb.imb3151 =0         #not null
         LET l_imb.imb316  =0         #not null
         LET l_imb.imb3171 =0         #not null
         LET l_imb.imb3172 =0         #not null
         LET l_imb.imb319  =0         #not null
         LET l_imb.imb318  =0         #not null
         LET l_imb.imb320  =0         #not null
         LET l_imb.imb321  =0         #not null
         LET l_imb.imb322  =0         #not null
         LET l_imb.imb3231 =0         #not null
         LET l_imb.imb3232 =0         #not null
         LET l_imb.imb324  =0         #not null
         LET l_imb.imb325  =0         #not null
         LET l_imb.imb3251 =0         #not null
         LET l_imb.imb326  =0         #not null
         LET l_imb.imb3271 =0         #not null
         LET l_imb.imb3272 =0         #not null
         LET l_imb.imb329  =0         #not null
         LET l_imb.imb330  =0         #not null
         #---020613 add
 
         LET l_imb.imboriu = g_user      #No.FUN-980030 10/01/04
         LET l_imb.imborig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO imb_file VALUES(l_imb.*)       # DISK WRITE
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_imb.imb01,SQLCA.sqlcode,1)   #No.FUN-660089
            CALL cl_err3("ins","imb_file",l_imb.imb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
         END IF
      END IF
      CASE tm.c
         WHEN '1'
            UPDATE imb_file SET imb111 = g_csa.csa0301,
                                imb112 = g_csa.csa0302,
                                imb1131= g_csa.csa0303,
                                imb1132= g_csa.csa0304,
                                imb114 = g_csa.csa0305,
                                imb115 = g_csa.csa0306,
                                imb116 = g_csa.csa0307,
                                imb1171= g_csa.csa0308,
                                imb1172= g_csa.csa0309,
                                imb119 = g_csa.csa0310,
                                imb118 = g_csa.csa0311,
                                imb120 = g_csa.csa0312,
                                imb121 = g_csa.csa0321,
                                imb122 = g_csa.csa0322,
                                imb1231= g_csa.csa0323,
                                imb1232= g_csa.csa0324,
                                imb124 = g_csa.csa0325,
                                imb125 = g_csa.csa0326,
                                imb126 = g_csa.csa0327,
                                imb1271= g_csa.csa0328,
                                imb1272= g_csa.csa0329,
                                imb129 = g_csa.csa0330,
                                imb130 = g_csa.csa0331
             WHERE imb01 = g_csa.csa01
         WHEN '2'
            UPDATE imb_file SET imb211 = g_csa.csa0301,
                                imb212 = g_csa.csa0302,
                                imb2131= g_csa.csa0303,
                                imb2132= g_csa.csa0304,
                                imb214 = g_csa.csa0305,
                                imb215 = g_csa.csa0306,
                                imb216 = g_csa.csa0307,
                                imb2171= g_csa.csa0308,
                                imb2172= g_csa.csa0309,
                                imb219 = g_csa.csa0310,
                                imb218 = g_csa.csa0311,
                                imb220 = g_csa.csa0312,
                                imb221 = g_csa.csa0321,
                                imb222 = g_csa.csa0322,
                                imb2231= g_csa.csa0323,
                                imb2232= g_csa.csa0324,
                                imb224 = g_csa.csa0325,
                                imb225 = g_csa.csa0326,
                                imb226 = g_csa.csa0327,
                                imb2271= g_csa.csa0328,
                                imb2272= g_csa.csa0329,
                                imb229 = g_csa.csa0330,
                                imb230 = g_csa.csa0331
             WHERE imb01 = g_csa.csa01
         WHEN '3'
            UPDATE imb_file SET imb311 = g_csa.csa0301,
                                imb312 = g_csa.csa0302,
                                imb3131= g_csa.csa0303,
                                imb3132= g_csa.csa0304,
                                imb314 = g_csa.csa0305,
                                imb315 = g_csa.csa0306,
                                imb316 = g_csa.csa0307,
                                imb3171= g_csa.csa0308,
                                imb3172= g_csa.csa0309,
                                imb319 = g_csa.csa0310,
                                imb318 = g_csa.csa0311,
                                imb320 = g_csa.csa0312,
                                imb321 = g_csa.csa0321,
                                imb322 = g_csa.csa0322,
                                imb3231= g_csa.csa0323,
                                imb3232= g_csa.csa0324,
                                imb324 = g_csa.csa0325,
                                imb325 = g_csa.csa0326,
                                imb326 = g_csa.csa0327,
                                imb3271= g_csa.csa0328,
                                imb3272= g_csa.csa0329,
                                imb329 = g_csa.csa0330,
                                imb330 = g_csa.csa0331
             WHERE imb01 = g_csa.csa01
      END CASE
   END FOREACH
END FUNCTION
 
FUNCTION t200_u1()
DEFINE    l_sql1     LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(100)
              l_csb01    LIKE csb_file.csb01,
              l_csb04    LIKE csb_file.csb04
 
   LET l_sql1 = " SELECT * FROM csb_file",
                " WHERE csb02 = '0' ",
                " ORDER BY csb01"
   PREPARE t200_pre1 FROM l_sql1
   DECLARE t200_cs1 CURSOR FOR t200_pre1
 
   FOREACH t200_cs1 INTO g_csb.*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
      SELECT * FROM iml_file
       WHERE iml01 = g_csb.csb01
         AND iml02 = g_csb.csb04
      IF SQLCA.sqlcode THEN
         CASE tm.c
            WHEN '1'
                INSERT INTO iml_file(iml01,iml02,iml031,iml032,iml033)  #No.MOD-470041
                    VALUES(g_csb.csb01,g_csb.csb04,g_csb.csb05,0,0)
            WHEN '2'
                INSERT INTO iml_file(iml01,iml02,iml031,iml032,iml033)  #No.MOD-470041
                    VALUES(g_csb.csb01,g_csb.csb04,0,g_csb.csb05,0)
            WHEN '3'
                INSERT INTO iml_file(iml01,iml02,iml031,iml032,iml033)  #No.MOD-470041
                    VALUES(g_csb.csb01,g_csb.csb04,0,0,g_csb.csb05)
         END CASE
      ELSE
         CASE tm.c
            WHEN '1'
               UPDATE iml_file SET iml031=g_csb.csb05
                WHERE iml01 = g_csb.csb01
                  AND iml02 = g_csb.csb04
            WHEN '2'
               UPDATE iml_file SET iml032=g_csb.csb05
                WHERE iml01 = g_csb.csb01
                  AND iml02 = g_csb.csb04
            WHEN '3'
               UPDATE iml_file SET iml033=g_csb.csb05
                WHERE iml01 = g_csb.csb01
                  AND iml02 = g_csb.csb04
         END CASE
      END IF
  END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001> #
