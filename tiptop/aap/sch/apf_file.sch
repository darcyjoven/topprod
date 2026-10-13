/*
================================================================================
檔案代號:apf_file
檔案名稱:付款单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apf_file
(
apf00       varchar2(2),             /*付款性质                               */
                                     /*Payment Property                       */
                                     /*  '11':Billing Temp. Estim. AP(Auto)   */
                                     /*  '16':Billing Direct Payment (Auto)   */
                                     /*  '33':Payment                         */
                                     /*  '34':Spent Payment                   */
apf01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號                               */
apf02       date,                    /*付款日期                               */
apf03       varchar2(10),            /*付款厂商                               */
                                     /*付款廠商 pmc01                         */
apf04       varchar2(10),            /*付款人员                               */
                                     /*付款人員 gen01                         */
apf05       varchar2(10),            /*付款部门                               */
                                     /*付款部門 gem01                         */
apf06       varchar2(4),             /*币种                                   */
                                     /*幣別     azi01                         */
apf07       number(20,10),           /*汇率                                   */
                                     /*匯率 (No use)                          */
apf08f      number(20,6),            /*原币帐款金额                           */
                                     /*原幣帳款金額                           */
apf08       number(20,6),            /*本币帐款金额                           */
                                     /*本幣帳款金額                           */
apf09f      number(20,6),            /*原币暂付金额                           */
                                     /*原幣暫付金額                           */
apf09       number(20,6),            /*本币暂付金额                           */
                                     /*本幣暫付金額                           */
apf10f      number(20,6),            /*原币付款金额                           */
                                     /*原幣付款金額                           */
apf10       number(20,6),            /*本币付款金额                           */
                                     /*本幣付款金額                           */
apf11       varchar2(10),            /*付款理由                               */
                                     /*付款理由 azf01,azf02='2'               */
apf12       varchar2(40),            /*厂商简称                               */
                                     /*廠商簡稱                               */
apf13       varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
apf14       varchar2(10),            /*现金变动码                             */
                                     /*現金變動碼(只用四碼)nml01       (97/10)*/
apf15       varchar2(10),            /*No Use                                 */
apf41       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
apf43       date,                    /*抛转凭证日期                           */
                                     /*拋轉傳票日期                           */
apf44       varchar2(20),            /*抛转凭证编号                           */
                                     /*拋轉傳票編號 npp01(npq01)              */
apfinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
apfmksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
apfsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
apfdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
apfprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
apfsmax     number(5),               /*应签等级                               */
                                     /*應簽等級                               */
apfsseq     number(5),               /*已签等级                               */
                                     /*已簽等級                               */
apfprno     number(5),               /*打印次数                               */
                                     /*列印次數                               */
apfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
apfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
apfgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
apfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
apfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
apf42       varchar2(1),             /*状况码                                 */
apf992      varchar2(20),            /*集团代付单号                           */
                                     /*For 內部帳戶                           */
apfud01     varchar2(255),           /*自订字段-Textedit                      */
apfud02     varchar2(40),            /*自订字段-文字                          */
apfud03     varchar2(40),            /*自订字段-文字                          */
apfud04     varchar2(40),            /*自订字段-文字                          */
apfud05     varchar2(40),            /*自订字段-文字                          */
apfud06     varchar2(40),            /*自订字段-文字                          */
apfud07     number(15,3),            /*自订字段-数值                          */
apfud08     number(15,3),            /*自订字段-数值                          */
apfud09     number(15,3),            /*自订字段-数值                          */
apfud10     number(10),              /*自订字段-整数                          */
apfud11     number(10),              /*自订字段-整数                          */
apfud12     number(10),              /*自订字段-整数                          */
apfud13     date,                    /*自订字段-日期                          */
apfud14     date,                    /*自订字段-日期                          */
apfud15     date,                    /*自订字段-日期                          */
apf45       varchar2(1),             /*转出码(网银)                           */
apflegal    varchar2(10) NOT NULL,   /*所属法人                               */
apforiu     varchar2(10),            /*资料建立者                             */
apforig     varchar2(10),            /*资料建立部门                           */
apf46       varchar2(10),            /*轉銷厂商                               */
apf47       varchar2(1)              /*单据类型                               */
);

create        index apf_02 on apf_file (apf44);
alter table apf_file add  constraint apf_pk primary key  (apf01) enable validate;
grant select on apf_file to tiptopgp;
grant update on apf_file to tiptopgp;
grant delete on apf_file to tiptopgp;
grant insert on apf_file to tiptopgp;
grant index on apf_file to public;
grant select on apf_file to ods;
