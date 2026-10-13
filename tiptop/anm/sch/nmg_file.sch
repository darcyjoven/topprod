/*
================================================================================
檔案代號:nmg_file
檔案名稱:银行存款异动记录档(转账)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmg_file
(
nmg00       varchar2(20) NOT NULL,   /*收支单号                               */
                                     /*收支單號                               */
nmg01       date,                    /*收支日期                               */
nmg02       varchar2(11),            /*No Use                                 */
nmg021      varchar2(24),            /*No Use                                 */
nmg03       number(10),              /*No Use                                 */
nmg04       number(8,4),             /*No Use                                 */
nmg05       number(20,6),            /*原币出帐金额                           */
                                     /*原幣出帳金額                           */
nmg06       number(20,6),            /*本币出帐金额                           */
                                     /*本幣出帳金額                           */
nmg07       varchar2(11),            /*No Use                                 */
nmg071      varchar2(24),            /*No Use                                 */
nmg08       number(10),              /*No Use                                 */
nmg09       number(20,10),           /*重估汇率                               */
nmg10       number(20,6),            /*本币未冲金额                           */
nmg11       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
nmg12       varchar2(80),            /*摘要                                   */
                                     /*摘    要                               */
nmg13       varchar2(20),            /*凭证号码                               */
                                     /*傳票號碼                               */
nmg14       date,                    /*凭证日期                               */
                                     /*傳票日期                               */
nmg15       varchar2(2),             /*No Use                                 */
nmg16       varchar2(2),             /*No Use                                 */
nmg17       varchar2(4),             /*No Use                                 */
nmg18       varchar2(10),            /*厂商/客户编号                          */
                                     /*廠商/客戶編號                          */
nmg19       varchar2(40),            /*厂商/客户简称                          */
                                     /*廠商/客戶簡稱                          */
nmg20       varchar2(2),             /*入帐类型                               */
                                     /*入帳類別                               */
                                     /*  1 .廠商匯款出帳                      */
                                     /*  21.客戶匯款     22.押匯入帳          */
                                     /*  21/22 這兩類可沖AR                   */
                                     /*   0.其它                              */
nmg21       varchar2(20),            /*收状单号                               */
                                     /*收狀單號 (nmg20='22'時,須輸入)         */
nmg22       varchar2(4),             /*原始冲帐币种                           */
                                     /*原始沖帳幣別 (由收狀單帶出,或人工輸入) */
nmg23       number(20,6),            /*原币入帐金额                           */
                                     /*原幣入帳金額                           */
nmg24       number(20,6),            /*已冲金额                               */
                                     /*已沖金額 (nmg20='2*'時,由沖帳作業更新) */
nmg25       number(20,6),            /*本币入帐金额                           */
                                     /*本幣入帳金額                           */
nmg26       varchar2(10),            /*No Use                                 */
nmg27       varchar2(16),            /*No Use                                 */
nmg28       number(5),               /*No Use                                 */
nmg29       varchar2(1),             /*暂收否                                 */
                                     /*No use ->暫收否    #No.+099            */
nmg30       varchar2(24),            /*暂收科目                               */
                                     /*No use ->暫收科目  #No.+099            */
nmgconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
nmgacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code #6185                  */
nmguser     varchar2(10),            /*资料录入者                             */
                                     /*資料輸入者                             */
nmggrup     varchar2(10),            /*资料录入者部门                         */
                                     /*資料輸入者部門                         */
nmgmodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By #6185                 */
nmgdate     date,                    /*资料录入日期                           */
                                     /*資料輸入日期                           */
nmg301      varchar2(24),            /*暂收科目二                             */
nmgud01     varchar2(255),           /*自订字段-Textedit                      */
nmgud02     varchar2(40),            /*自订字段-文字                          */
nmgud03     varchar2(40),            /*自订字段-文字                          */
nmgud04     varchar2(40),            /*自订字段-文字                          */
nmgud05     varchar2(40),            /*自订字段-文字                          */
nmgud06     varchar2(40),            /*自订字段-文字                          */
nmgud07     number(15,3),            /*自订字段-数值                          */
nmgud08     number(15,3),            /*自订字段-数值                          */
nmgud09     number(15,3),            /*自订字段-数值                          */
nmgud10     number(10),              /*自订字段-整数                          */
nmgud11     number(10),              /*自订字段-整数                          */
nmgud12     number(10),              /*自订字段-整数                          */
nmgud13     date,                    /*自订字段-日期                          */
nmgud14     date,                    /*自订字段-日期                          */
nmgud15     date,                    /*自订字段-日期                          */
nmglegal    varchar2(10) NOT NULL,   /*所属法人                               */
nmgoriu     varchar2(10),            /*资料建立者                             */
nmgorig     varchar2(10),            /*资料建立部门                           */
nmg31       varchar2(20)             /*付款单号                               */
);

create        index nmg_05 on nmg_file (nmg18);
create        index nmg_02 on nmg_file (nmg01);
create        index nmg_03 on nmg_file (nmg02);
create        index nmg_04 on nmg_file (nmg07);
create        index nmg_06 on nmg_file (nmg13);
alter table nmg_file add  constraint nmg_pk primary key  (nmg00) enable validate;
grant select on nmg_file to tiptopgp;
grant update on nmg_file to tiptopgp;
grant delete on nmg_file to tiptopgp;
grant insert on nmg_file to tiptopgp;
grant index on nmg_file to public;
grant select on nmg_file to ods;
