// class SQL{
//    static  String SQ_Music_sql= '''
// CREATE TABLE "SQ_Music" (
//   "UUID" text NOT NULL,
//   "MusicName" text,
//   "MusicArtists" text,
//   "MusicAlbum" text,
//   "MusicLyricPath" text,
//   "MusicPath" text,
//   "MusicImagePath" text,
//   "MusicTime" text,
//   "MusicDescribe" text,
//   "MusicType" text,
//   "MusicCodeType" text,
//   "MusicLyricTrans" text,
//   "MusicSourImageUrl" text,
//   "MusicSongSour" text,
//   "MusicLyricvalue" text,
//   "MusicBr" integer,
//   "UploadDrive" integer,
//   "IsLike" integer,
//   PRIMARY KEY ("UUID")
// )
// ''';
//
//    static String SQ_Play_sql='''
// CREATE TABLE "SQ_Play" (
//   "UUID" text NOT NULL,
//   "playName" TEXT,
//   "PlayImage" TEXT,
//   "PlayDescribe" TEXT,
//   "PlayIndex" TEXT,
//   "NotAllowDEL" TEXT,
//   "PlayCreateTime" integer,
//   PRIMARY KEY ("UUID")
// )
//               ''';
//
//    static   String SQ_Set_sql ='''
// CREATE TABLE "SQ_Set" (
//   "UUID" text NOT NULL,
//   "setName" TEXT,
//   "setValue" TEXT,
//   "setDescription" TEXT,
//   "setType" TEXT,
//   "index" integer,
//   PRIMARY KEY ("UUID")
// )
//      ''';
//
//    static   String SQ_Play_Music_sql = '''
//    CREATE TABLE "SQ_Play_Music" (
//    "UUID" INTEGER NOT NULL,
//    "MusicUUID" INTEGER,
//    "PlayUIUID" INTEGER,
//    PRIMARY KEY ("UUID"),
//    CONSTRAINT "mumu" FOREIGN KEY ("MusicUUID") REFERENCES "SQ_Music" ("UUID") ON DELETE CASCADE ON UPDATE NO ACTION,
//    CONSTRAINT "pupu" FOREIGN KEY ("PlayUIUID") REFERENCES "SQ_Play" ("UUID") ON DELETE CASCADE ON UPDATE NO ACTION
//    )
//    ''';
//
//    static String insert_sql = '''
// INSERT INTO "SQ_Set" VALUES ('4d728ebb5904513c850e5affd5a1ade3', 'user_name', 'SQMusic', '用户名称', 'system', 1)
// ''';
// }