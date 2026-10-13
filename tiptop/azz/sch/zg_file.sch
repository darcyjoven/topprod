/*
================================================================================
檔案代號:zg_file
檔案名稱:统计图型单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zg_file
(
zg01        varchar2(5) NOT NULL,    /*图形编号                               */
                                     /*圖形代號                               */
zg02        varchar2(1),             /*图形类型                               */
                                     /*圖形類別                               */
                                     /*1.Bar chart 2.Line chart 3.Pie chart   */
zg03        number(5),               /*Group no                               */
                                     /*Ex: 12 (月)                            */
zg04        number(5),               /*Item no                                */
                                     /*每一 Group 內的 Item 數目              */
                                     /*Ex: 3 (業務員)                         */
zg05        varchar2(80),            /*图形抬头                               */
                                     /*圖形抬頭                               */
                                     /*TITLE                                  */
zg06        varchar2(80),            /*图形次抬头                             */
                                     /*圖形次抬頭                             */
                                     /*SUBTITLE                               */
zg07        varchar2(80),            /*纵轴标题                               */
                                     /*縱軸標題                               */
                                     /*X-WAY                                  */
zg08        varchar2(80),            /*横轴标题                               */
                                     /*橫軸標題                               */
                                     /*Y-WAY                                  */
zg09        varchar2(80),            /*明细标题                               */
                                     /*明細標題                               */
                                     /*LABEL                                  */
zg10        varchar2(70),            /*SQL-1                                  */
zg11        varchar2(70),            /*SQL-2                                  */
zg12        varchar2(70),            /*SQL-3                                  */
zguser      varchar2(10),            /*资料所有者                             */
zgdate      date,                    /*日期                                   */
zgorig      varchar2(10),            /*资料建立部门                           */
zgoriu      varchar2(10)             /*资料建立者                             */
);

alter table zg_file add  constraint zg_pk primary key  (zg01) enable validate;
grant select on zg_file to tiptopgp;
grant update on zg_file to tiptopgp;
grant delete on zg_file to tiptopgp;
grant insert on zg_file to tiptopgp;
grant index on zg_file to public;
grant select on zg_file to ods;
