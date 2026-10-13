/*
================================================================================
檔案代號:shm_file
檔案名稱:Run Card 资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shm_file
(
shm01       varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
shm012      varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
shm05       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
shm06       varchar2(10),            /*使用工艺编号                           */
                                     /*使用製程編號  ecu01                    */
shm08       number(15,3) NOT NULL,   /*生产数量                               */
                                     /*生產數量                               */
shm09       number(15,3) NOT NULL,   /*完工入库数量                           */
                                     /*完工入庫數量                           */
shm10       number(15,3) NOT NULL,   /*返工数量                               */
                                     /*再加工數量                             */
shm11       number(15,3) NOT NULL,   /*F.Q.C 数量                             */
                                     /*F.Q.C 數量                             */
shm111      number(15,3) NOT NULL,   /*MRB   数量                             */
                                     /*MRB   數量                             */
shm12       number(15,3) NOT NULL,   /*报废数量                               */
                                     /*報廢數量                               */
shm121      number(15,3) NOT NULL,   /*在制盘盈亏量                           */
                                     /*在製盤盈虧量  add 99/04/27             */
shm122      number(15,3),            /*No Use                                 */
shm13       date,                    /*预计起始生产日期                       */
                                     /*預計起始生產日期                       */
shm14       varchar2(5),             /*预计起始生产时间                       */
                                     /*預計起始生產時間(時:分)                */
shm15       date,                    /*预计结束生产日期                       */
                                     /*預計結束生產日期                       */
shm16       varchar2(5),             /*预计结束生产时间                       */
                                     /*預計結束生產時間(時:分)                */
shm17       number(5),               /*已完工工艺序号                         */
                                     /*已完工製程序號                         */
shm28       varchar2(1),             /*结案否                                 */
                                     /*結案否                                 */
shm86       varchar2(23),            /*Run Card                               */
shm91       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm92       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm93       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm94       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm95       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm96       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm97       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm98       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shm99       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂(USER DEFINE)                */
shmacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
shmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
shmgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
shmmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
shmdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
shmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
shmoriu     varchar2(10),            /*资料建立者                             */
shmorig     varchar2(10),            /*资料建立部门                           */
shm18       varchar2(20),            /*号机                                   */
ta_shm01    number(15,3),            /*PNL数                                  */
ta_shm02    varchar2(1),             /*可报工否                               */
ta_shm03    varchar2(40),            /*原LOT单号                              */
ta_shm04    varchar2(1),             /*期初开工否                             */
ta_shm05    varchar2(40),            /*投产批次号                             */
ta_shm06    varchar2(1)              /*user                                   */
);

create        index shm_02 on shm_file (shm05);
alter table shm_file add  constraint shm_pk primary key  (shm01) enable validate;
grant select on shm_file to tiptopgp;
grant update on shm_file to tiptopgp;
grant delete on shm_file to tiptopgp;
grant insert on shm_file to tiptopgp;
grant index on shm_file to public;
grant select on shm_file to ods;
