/*
================================================================================
檔案代號:rpj_file
檔案名稱:粗略产能规划时距档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rpj_file
(
rpj01       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
rpj02       varchar2(10) NOT NULL,   /*工作站编号                             */
                                     /*工作站編號                             */
rpj03       number(5) NOT NULL,      /*时距编号                               */
                                     /*時距代號                               */
rpj04       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
rpj06       date,                    /*起始日期                               */
rpj07       date,                    /*结束日期                               */
                                     /*結束日期                               */
rpj08       number(15,3),            /*总设置小时                             */
                                     /*總設置小時                             */
rpj09       number(15,3),            /*总生产小时                             */
                                     /*總生產小時                             */
rpj10       number(15,3),            /*工作站产能                             */
                                     /*工作站產能(小時)                       */
rpj11       varchar2(4),             /*工作站工作历编号                       */
                                     /*工作站工作曆編號                       */
rpj12       number(5)                /*工作站资源数                           */
                                     /*Workstation Resources(for Calculating Capacity)*/
);

alter table rpj_file add  constraint rpj_pk primary key  (rpj01,rpj02,rpj03,rpj04) enable validate;
grant select on rpj_file to tiptopgp;
grant update on rpj_file to tiptopgp;
grant delete on rpj_file to tiptopgp;
grant insert on rpj_file to tiptopgp;
grant index on rpj_file to public;
grant select on rpj_file to ods;
