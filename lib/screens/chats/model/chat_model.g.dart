// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChatModelCollection on Isar {
  IsarCollection<ChatModel> get chatModels => this.collection();
}

const ChatModelSchema = CollectionSchema(
  name: r'ChatModel',
  id: 3590324851517520026,
  properties: {
    r'chatId': PropertySchema(
      id: 0,
      name: r'chatId',
      type: IsarType.string,
    ),
    r'contactId': PropertySchema(
      id: 1,
      name: r'contactId',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'lastActivity': PropertySchema(
      id: 3,
      name: r'lastActivity',
      type: IsarType.dateTime,
    ),
    r'lastMessage': PropertySchema(
      id: 4,
      name: r'lastMessage',
      type: IsarType.string,
    ),
    r'lastSender': PropertySchema(
      id: 5,
      name: r'lastSender',
      type: IsarType.string,
    ),
    r'notifKey': PropertySchema(
      id: 6,
      name: r'notifKey',
      type: IsarType.string,
    ),
    r'picture': PropertySchema(
      id: 7,
      name: r'picture',
      type: IsarType.string,
    ),
    r'receiverName': PropertySchema(
      id: 8,
      name: r'receiverName',
      type: IsarType.string,
    ),
    r'reciever': PropertySchema(
      id: 9,
      name: r'reciever',
      type: IsarType.string,
    ),
    r'sender': PropertySchema(
      id: 10,
      name: r'sender',
      type: IsarType.string,
    ),
    r'time': PropertySchema(
      id: 11,
      name: r'time',
      type: IsarType.dateTime,
    ),
    r'unread': PropertySchema(
      id: 12,
      name: r'unread',
      type: IsarType.long,
    )
  },
  estimateSize: _chatModelEstimateSize,
  serialize: _chatModelSerialize,
  deserialize: _chatModelDeserialize,
  deserializeProp: _chatModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'chatId': IndexSchema(
      id: 1909629659142158609,
      name: r'chatId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chatId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _chatModelGetId,
  getLinks: _chatModelGetLinks,
  attach: _chatModelAttach,
  version: '3.1.0+1',
);

int _chatModelEstimateSize(
  ChatModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chatId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contactId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastSender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notifKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.picture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.receiverName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reciever;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _chatModelSerialize(
  ChatModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chatId);
  writer.writeString(offsets[1], object.contactId);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeDateTime(offsets[3], object.lastActivity);
  writer.writeString(offsets[4], object.lastMessage);
  writer.writeString(offsets[5], object.lastSender);
  writer.writeString(offsets[6], object.notifKey);
  writer.writeString(offsets[7], object.picture);
  writer.writeString(offsets[8], object.receiverName);
  writer.writeString(offsets[9], object.reciever);
  writer.writeString(offsets[10], object.sender);
  writer.writeDateTime(offsets[11], object.time);
  writer.writeLong(offsets[12], object.unread);
}

ChatModel _chatModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChatModel(
    chatId: reader.readStringOrNull(offsets[0]),
    id: id,
    isActive: reader.readBoolOrNull(offsets[2]) ?? true,
    lastActivity: reader.readDateTimeOrNull(offsets[3]),
    lastMessage: reader.readStringOrNull(offsets[4]),
    lastSender: reader.readStringOrNull(offsets[5]),
    notifKey: reader.readStringOrNull(offsets[6]),
    picture: reader.readStringOrNull(offsets[7]),
    receiverName: reader.readStringOrNull(offsets[8]),
    reciever: reader.readStringOrNull(offsets[9]),
    sender: reader.readStringOrNull(offsets[10]),
    time: reader.readDateTimeOrNull(offsets[11]),
    unread: reader.readLongOrNull(offsets[12]),
  );
  object.contactId = reader.readStringOrNull(offsets[1]);
  return object;
}

P _chatModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chatModelGetId(ChatModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _chatModelGetLinks(ChatModel object) {
  return [];
}

void _chatModelAttach(IsarCollection<dynamic> col, Id id, ChatModel object) {
  object.id = id;
}

extension ChatModelByIndex on IsarCollection<ChatModel> {
  Future<ChatModel?> getByChatId(String? chatId) {
    return getByIndex(r'chatId', [chatId]);
  }

  ChatModel? getByChatIdSync(String? chatId) {
    return getByIndexSync(r'chatId', [chatId]);
  }

  Future<bool> deleteByChatId(String? chatId) {
    return deleteByIndex(r'chatId', [chatId]);
  }

  bool deleteByChatIdSync(String? chatId) {
    return deleteByIndexSync(r'chatId', [chatId]);
  }

  Future<List<ChatModel?>> getAllByChatId(List<String?> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'chatId', values);
  }

  List<ChatModel?> getAllByChatIdSync(List<String?> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'chatId', values);
  }

  Future<int> deleteAllByChatId(List<String?> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'chatId', values);
  }

  int deleteAllByChatIdSync(List<String?> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'chatId', values);
  }

  Future<Id> putByChatId(ChatModel object) {
    return putByIndex(r'chatId', object);
  }

  Id putByChatIdSync(ChatModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'chatId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChatId(List<ChatModel> objects) {
    return putAllByIndex(r'chatId', objects);
  }

  List<Id> putAllByChatIdSync(List<ChatModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'chatId', objects, saveLinks: saveLinks);
  }
}

extension ChatModelQueryWhereSort
    on QueryBuilder<ChatModel, ChatModel, QWhere> {
  QueryBuilder<ChatModel, ChatModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChatModelQueryWhere
    on QueryBuilder<ChatModel, ChatModel, QWhereClause> {
  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> chatIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chatId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> chatIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chatId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> chatIdEqualTo(
      String? chatId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chatId',
        value: [chatId],
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterWhereClause> chatIdNotEqualTo(
      String? chatId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChatModelQueryFilter
    on QueryBuilder<ChatModel, ChatModel, QFilterCondition> {
  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatId',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatId',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> chatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contactId',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      contactIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contactId',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      contactIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> contactIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      contactIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastActivityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastActivity',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastActivityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastActivity',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastActivityEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActivity',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastActivityGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastActivity',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastActivityLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastActivity',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastActivityBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastActivity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMessage',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMessage',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastMessageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastMessageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSender',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastSenderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSender',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastSenderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastSenderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastSender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastSender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastSender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> lastSenderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastSender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastSenderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSender',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      lastSenderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastSender',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notifKey',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      notifKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notifKey',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notifKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notifKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notifKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notifKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notifKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notifKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notifKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notifKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> notifKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notifKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      notifKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notifKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'picture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receiverName',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receiverName',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> receiverNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> receiverNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiverName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> receiverNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiverName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      receiverNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiverName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reciever',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      recieverIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reciever',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciever',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciever',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciever',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciever',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reciever',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reciever',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reciever',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reciever',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> recieverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciever',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition>
      recieverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reciever',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sender',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sender',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> senderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> timeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> timeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> timeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> timeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> timeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> timeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> unreadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unread',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> unreadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unread',
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> unreadEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> unreadGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> unreadLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterFilterCondition> unreadBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unread',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChatModelQueryObject
    on QueryBuilder<ChatModel, ChatModel, QFilterCondition> {}

extension ChatModelQueryLinks
    on QueryBuilder<ChatModel, ChatModel, QFilterCondition> {}

extension ChatModelQuerySortBy on QueryBuilder<ChatModel, ChatModel, QSortBy> {
  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByContactId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactId', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByContactIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactId', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByLastActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByLastActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByLastMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByLastMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByLastSender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSender', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByLastSenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSender', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByNotifKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifKey', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByNotifKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifKey', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByReceiverName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByReceiverNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByReciever() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciever', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByRecieverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciever', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> sortByUnreadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.desc);
    });
  }
}

extension ChatModelQuerySortThenBy
    on QueryBuilder<ChatModel, ChatModel, QSortThenBy> {
  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByContactId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactId', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByContactIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactId', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByLastActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByLastActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByLastMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByLastMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByLastSender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSender', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByLastSenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSender', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByNotifKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifKey', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByNotifKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifKey', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByReceiverName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByReceiverNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByReciever() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciever', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByRecieverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciever', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.asc);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QAfterSortBy> thenByUnreadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.desc);
    });
  }
}

extension ChatModelQueryWhereDistinct
    on QueryBuilder<ChatModel, ChatModel, QDistinct> {
  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByChatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByContactId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByLastActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActivity');
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByLastMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByLastSender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByNotifKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByReceiverName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiverName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByReciever(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciever', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctBySender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }

  QueryBuilder<ChatModel, ChatModel, QDistinct> distinctByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unread');
    });
  }
}

extension ChatModelQueryProperty
    on QueryBuilder<ChatModel, ChatModel, QQueryProperty> {
  QueryBuilder<ChatModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> chatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatId');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> contactIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactId');
    });
  }

  QueryBuilder<ChatModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<ChatModel, DateTime?, QQueryOperations> lastActivityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActivity');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> lastMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessage');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> lastSenderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSender');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> notifKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifKey');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> receiverNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiverName');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> recieverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciever');
    });
  }

  QueryBuilder<ChatModel, String?, QQueryOperations> senderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sender');
    });
  }

  QueryBuilder<ChatModel, DateTime?, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }

  QueryBuilder<ChatModel, int?, QQueryOperations> unreadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unread');
    });
  }
}
