/*
================================================================================
檔案代號:tc_imm_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_imm_file
(
tc_imm01    varchar2(20) NOT NULL,   /*调拨单号                               */
                                     /*調撥單號                               */
tc_imm02    date,                    /*调拨日期                               */
                                     /*調撥日期                               */
tc_imm03    varchar2(1),             /*过帐否                                 */
                                     /*過帳否(Y/N) (撥入確認)                 */
tc_imm04    varchar2(1),             /*拨出审核否                             */
                                     /*撥出確認否(Y/N/X)  X.撥出單作廢        */
tc_immdays  number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
tc_immprit  number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
tc_imm05    number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
tc_imm06    number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
tc_imm07    number(5),               /*已打印次数                             */
                                     /*已列印次數                             */
tc_imm08    varchar2(10),            /*作业编号                               */
tc_imm09    varchar2(255),           /*备注                                   */
                                     /*備註                                   */
tc_imm10    varchar2(10),            /*所属站别                               */
                                     /*資料來源1.一階段倉庫調撥2.二階段倉庫調撥3.一階段工廠調撥4.二階段工廠調撥5.刻號/BIN調整(for ICD)*/
tc_imm11    varchar2(20),            /*拨入单号                               */
                                     /*撥入單號資料來源='3' 一階段工廠調撥,且參數設定撥             出單號與撥入單號相同,             tc_imm11 default tc_imm01資料來源='2' 二階段倉庫調撥,且參數設定撥             出單號與撥入單號相同,             tc_imm11 default tc_imm01*/
tc_imm12    date,                    /*拨入日期                               */
                                     /*撥入日期                               */
tc_imm13    varchar2(10),            /*拨入人员                               */
                                     /*撥入人員                               */
tc_immacti  varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
tc_immuser  varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
tc_immgrup  varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
tc_immmodu  varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
tc_immdate  date,                    /*最近更改日                             */
                                     /*最近修改日                             */
tc_immconf  varchar2(1),             /*审核码(Y/N/X)                          */
tc_imm14    varchar2(10),            /*部门                                   */
tc_immspc   varchar2(1),             /*SPC抛转码 0/1/2                        */
tc_immud01  varchar2(255),           /*自订字段-Textedit                      */
tc_immud02  varchar2(40),            /*自订字段-文字                          */
tc_immud03  varchar2(40),            /*自订字段-文字                          */
tc_immud04  varchar2(40),            /*自订字段-文字                          */
tc_immud05  varchar2(40),            /*自订字段-文字                          */
tc_immud06  varchar2(40),            /*自订字段-文字                          */
tc_immud07  number(15,3),            /*自订字段-数值                          */
tc_immud08  number(15,3),            /*自订字段-数值                          */
tc_immud09  number(15,3),            /*自订字段-数值                          */
tc_immud10  number(10),              /*自订字段-整数                          */
tc_immud11  number(10),              /*自订字段-整数                          */
tc_immud12  number(10),              /*自订字段-整数                          */
tc_immud13  date,                    /*自订字段-日期                          */
tc_immud14  date,                    /*自订字段-日期                          */
tc_immud15  date,                    /*自订字段-日期                          */
tc_immplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_immlegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_immoriu  varchar2(10),            /*资料建立者                             */
tc_immorig  varchar2(10),            /*资料建立部门                           */
tc_imm15    varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
tc_imm16    varchar2(10),            /*申请人                                 */
tc_immmksg  varchar2(1) DEFAULT 'N' NOT NULL /*是否签核*/
);

alter table tc_imm_file add  constraint tpc_imm_pk primary key  (tc_imm01) enable validate;
grant select on tc_imm_file to tiptopgp;
grant update on tc_imm_file to tiptopgp;
grant delete on tc_imm_file to tiptopgp;
grant insert on tc_imm_file to tiptopgp;
grant index on tc_imm_file to public;
grant select on tc_imm_file to ods;
