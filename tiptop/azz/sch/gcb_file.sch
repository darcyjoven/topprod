/*
================================================================================
檔案代號:gcb_file
檔案名稱:文件资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gcb_file
(
gcb01       varchar2(30) NOT NULL,   /*文件编号                               */
                                     /*Refer to gca_file.gca01                */
gcb02       varchar2(3) NOT NULL,    /*文件类型                               */
                                     /*Refer to gca_file.gca02                */
gcb03       varchar2(10) NOT NULL,   /*文件分辑                               */
                                     /*Refer to gca_file.gca03                */
gcb04       varchar2(3) NOT NULL,    /*文件版本                               */
                                     /*Refer to gca_file.gca04                */
gcb05       varchar2(100),           /*文件说明                               */
gcb06       varchar2(255),           /*文件完整说明                           */
gcb07       varchar2(255),           /*文件名称                               */
gcb08       varchar2(1),             /*文件储存方式                           */
gcb09       blob,                    /*文件内容(数据库储存时使用)             */
gcb10       varchar2(255),           /*文件位置(File Server 储存时使用        */
gcb11       varchar2(1),             /*文件读取权限                           */
gcb12       varchar2(1),             /*文件异动权限                           */
gcb13       varchar2(10),            /*文件建立人员                           */
gcb14       varchar2(10),            /*文件建立人员群组                       */
gcb15       date,                    /*文件建立日期                           */
gcb16       varchar2(10),            /*最后异动人员                           */
gcb17       varchar2(10),            /*最后异动人员群组                       */
gcb18       date                     /*最后异动日期                           */
);

alter table gcb_file add  constraint gcb_pk primary key  (gcb01,gcb02,gcb03,gcb04) enable validate;
grant select on gcb_file to tiptopgp;
grant update on gcb_file to tiptopgp;
grant delete on gcb_file to tiptopgp;
grant insert on gcb_file to tiptopgp;
grant index on gcb_file to public;
grant select on gcb_file to ods;
