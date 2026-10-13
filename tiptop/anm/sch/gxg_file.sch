/*
================================================================================
檔案代號:gxg_file
檔案名稱:质押/解除质押维护资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxg_file
(
gxg011      varchar2(20) NOT NULL,   /*申请单号                               */
                                     /*申請單號             #02/12/11 add     */
gxg01       varchar2(20),            /*存单号码                               */
                                     /*存單號碼                               */
gxg02       number(5) NOT NULL,      /*异动序号                               */
                                     /*異動序號                               */
gxg021      varchar2(1),             /*性质                                   */
                                     /*性質                                   */
                                     /*'1':質押                               */
                                     /*'2':解除                               */
gxg03       date,                    /*质押日期                               */
                                     /*質押日期                               */
gxg04       varchar2(10),            /*质押对象                               */
                                     /*質押對象                               */
gxg05       number(20,6),            /*质押金额                               */
                                     /*質押金額                               */
gxg06       varchar2(80),            /*质押性质                               */
                                     /*質押性質                               */
gxg07       varchar2(20),            /*质押凭证编号                           */
                                     /*質押傳票編號                           */
gxg08       date,                    /*质押凭证日期                           */
                                     /*質押傳票日期                           */
gxg09       date,                    /*解除日期                               */
gxg10       varchar2(20),            /*解除质押凭证编号                       */
                                     /*解除質押傳票編號                       */
gxg11       date,                    /*解除质押凭证日期                       */
                                     /*解除質押傳票日期                       */
gxgconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
gxguser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護。                             */
gxggrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護。                             */
gxgmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護。                             */
gxgdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護。                             */
gxgacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護。                             */
gxgud01     varchar2(255),           /*自订字段-Textedit                      */
gxgud02     varchar2(40),            /*自订字段-文字                          */
gxgud03     varchar2(40),            /*自订字段-文字                          */
gxgud04     varchar2(40),            /*自订字段-文字                          */
gxgud05     varchar2(40),            /*自订字段-文字                          */
gxgud06     varchar2(40),            /*自订字段-文字                          */
gxgud07     number(15,3),            /*自订字段-数值                          */
gxgud08     number(15,3),            /*自订字段-数值                          */
gxgud09     number(15,3),            /*自订字段-数值                          */
gxgud10     number(10),              /*自订字段-整数                          */
gxgud11     number(10),              /*自订字段-整数                          */
gxgud12     number(10),              /*自订字段-整数                          */
gxgud13     date,                    /*自订字段-日期                          */
gxgud14     date,                    /*自订字段-日期                          */
gxgud15     date,                    /*自订字段-日期                          */
gxglegal    varchar2(10) NOT NULL,   /*所属法人                               */
gxgoriu     varchar2(10),            /*资料建立者                             */
gxgorig     varchar2(10)             /*资料建立部门                           */
);

create        index gxg_03 on gxg_file (gxg10);
create        index gxg_02 on gxg_file (gxg07);
alter table gxg_file add  constraint gxg_pk primary key  (gxg011,gxg02) enable validate;
grant select on gxg_file to tiptopgp;
grant update on gxg_file to tiptopgp;
grant delete on gxg_file to tiptopgp;
grant insert on gxg_file to tiptopgp;
grant index on gxg_file to public;
grant select on gxg_file to ods;
