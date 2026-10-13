/*
================================================================================
檔案代號:gxh_file
檔案名稱:利息收入暂估资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxh_file
(
gxh011      varchar2(20) NOT NULL,   /*定存申请单号                           */
                                     /*定存申請單號            #02/12/11 add  */
gxh01       varchar2(20),            /*定存号码                               */
                                     /*定存號碼                               */
gxh02       number(5) NOT NULL,      /*年度                                   */
gxh03       number(5) NOT NULL,      /*月份                                   */
gxh04       varchar2(1),             /*计息方式                               */
                                     /*計息方式 1.月付 2.到期整付             */
gxh05       date,                    /*起算日期                               */
gxh06       date,                    /*止算日期                               */
gxh07       number(10),              /*天数                                   */
                                     /*天數                                   */
gxh08       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
gxh09       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
gxh10       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
gxh11       number(20,6),            /*暂估原币利息                           */
                                     /*暫估原幣利息     02/11/26 alter        */
gxh12       number(20,6),            /*暂估本币利息                           */
                                     /*暫估本幣利息                           */
gxh13       varchar2(20),            /*收息单号                               */
                                     /*收息單號                               */
gxh14       varchar2(20),            /*存入银行                               */
                                     /*存入銀行                               */
gxh15       varchar2(1),             /*审核否                                 */
gxh16       varchar2(1),             /*No Use                                 */
gxh17       number(15,3),            /*No Use                                 */
gxhglno     varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
gxhuser     varchar2(10),            /*资料所有者                             */
gxhgrup     varchar2(10),            /*资料所有部门                           */
gxhmodu     varchar2(10),            /*资料更改者                             */
gxhdate     date,                    /*最近更改日                             */
gxhud01     varchar2(255),           /*自订字段-Textedit                      */
gxhud02     varchar2(40),            /*自订字段-文字                          */
gxhud03     varchar2(40),            /*自订字段-文字                          */
gxhud04     varchar2(40),            /*自订字段-文字                          */
gxhud05     varchar2(40),            /*自订字段-文字                          */
gxhud06     varchar2(40),            /*自订字段-文字                          */
gxhud07     number(15,3),            /*自订字段-数值                          */
gxhud08     number(15,3),            /*自订字段-数值                          */
gxhud09     number(15,3),            /*自订字段-数值                          */
gxhud10     number(10),              /*自订字段-整数                          */
gxhud11     number(10),              /*自订字段-整数                          */
gxhud12     number(10),              /*自订字段-整数                          */
gxhud13     date,                    /*自订字段-日期                          */
gxhud14     date,                    /*自订字段-日期                          */
gxhud15     date,                    /*自订字段-日期                          */
gxhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
gxhorig     varchar2(10),            /*资料建立部门                           */
gxhoriu     varchar2(10)             /*资料建立者                             */
);

create        index gxh_02 on gxh_file (gxhglno);
alter table gxh_file add  constraint gxh_pk primary key  (gxh011,gxh02,gxh03) enable validate;
grant select on gxh_file to tiptopgp;
grant update on gxh_file to tiptopgp;
grant delete on gxh_file to tiptopgp;
grant insert on gxh_file to tiptopgp;
grant index on gxh_file to public;
grant select on gxh_file to ods;
