/*
================================================================================
檔案代號:sff_file
檔案名稱:工单负荷明细资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sff_file
(
sff01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
sff02       varchar2(10) NOT NULL,   /*工作站编号                             */
                                     /*工作站編號                             */
sff03       date NOT NULL,           /*该周周一                               */
                                     /*該週週一                               */
                                     /*以該週第一天星期一為其該週代表日       */
                                     /*系統處理時將以此為 Index               */
sff04       date,                    /*该周周六                               */
                                     /*該週週六                               */
                                     /*該週下限日期                           */
sff05       number(15,3),            /*负荷时数                               */
                                     /*負荷時數                               */
                                     /*儲存該工單使用該工作站總工時           */
sffplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sff_file add  constraint sff_pk primary key  (sff01,sff02,sff03) enable validate;
grant select on sff_file to tiptopgp;
grant update on sff_file to tiptopgp;
grant delete on sff_file to tiptopgp;
grant insert on sff_file to tiptopgp;
grant index on sff_file to public;
grant select on sff_file to ods;
